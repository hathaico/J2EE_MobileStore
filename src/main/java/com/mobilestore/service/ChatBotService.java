package com.mobilestore.service;

import com.mobilestore.model.*;
import com.mobilestore.dao.ChatProductDAO;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ShippingDAO;
import com.mobilestore.dao.VoucherDAO;
import jakarta.servlet.ServletContext;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Properties;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class ChatBotService {
    private static final String TRAINING_DATASET_PATH = "/assets/data/chatbot-training-dataset.json";
    private static final String TRAINING_DATASET_SNAPSHOT_FILE = "chatbot-training-dataset.snapshot.json";
    private static final String TRAINING_DATASET_HISTORY_PREFIX = "chatbot-training-dataset.";
    private static final String TRAINING_DATASET_HISTORY_SUFFIX = ".json";
    private static final String TRAINING_HISTORY_RETENTION_PROPERTY = "chatbot.training.history.retention-days";
    private static final String TRAINING_HISTORY_RETENTION_ENV = "CHATBOT_TRAINING_HISTORY_RETENTION_DAYS";
    private static final int DEFAULT_TRAINING_HISTORY_RETENTION_DAYS = 30;

    private ChatProductDAO productDAO = new ChatProductDAO();
    private ShippingDAO shippingDAO = new ShippingDAO();
    private VoucherDAO voucherDAO = new VoucherDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private final com.google.gson.Gson gson = new com.google.gson.Gson();

    private ServletContext servletContext;
    private volatile TrainingDataset trainingDataset;

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public void clearTrainingDatasetCache() {
        synchronized (this) {
            trainingDataset = null;
        }
    }

    public String exportTrainingDatasetSnapshotJson() {
        TrainingDataset dataset = loadTrainingDataset();
        if (dataset == null) {
            return "{}";
        }

        com.google.gson.JsonObject root = gson.toJsonTree(dataset).getAsJsonObject();
        com.google.gson.JsonObject masterData = root.has("master_data") && root.get("master_data").isJsonObject()
                ? root.getAsJsonObject("master_data")
                : new com.google.gson.JsonObject();

        masterData.add("products", gson.toJsonTree(getAllProductsAcrossSources()));
        masterData.add("promotions", gson.toJsonTree(buildTrainingPromotionSnapshots()));
        root.add("master_data", masterData);

        return gson.toJson(root);
    }

    public String writeTrainingDatasetSnapshotFile() throws java.io.IOException {
        String snapshotJson = exportTrainingDatasetSnapshotJson();
        Path snapshotPath = resolveTrainingDatasetSnapshotPath();

        Path parent = snapshotPath.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        Files.writeString(snapshotPath, snapshotJson, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE);

        return snapshotPath.toAbsolutePath().toString();
    }

    public String writeTrainingDatasetPrimaryFile() throws java.io.IOException {
        String snapshotJson = exportTrainingDatasetSnapshotJson();
        Path datasetPath = resolveTrainingDatasetPrimaryPath();

        Path parent = datasetPath.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        Files.writeString(datasetPath, snapshotJson, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE);

        writeTrainingDatasetHistoryCopy(snapshotJson);
        pruneTrainingDatasetVersions(resolveTrainingHistoryRetentionDays());

        clearTrainingDatasetCache();
        return datasetPath.toAbsolutePath().toString();
    }

    public String restoreTrainingDatasetFromFile(String fileName) throws java.io.IOException {
        Path sourcePath = resolveTrainingDatasetHistoryPath(fileName);
        if (sourcePath == null || !Files.exists(sourcePath)) {
            throw new java.io.FileNotFoundException("Training dataset version not found: " + fileName);
        }

        String content = Files.readString(sourcePath, StandardCharsets.UTF_8);
        Path datasetPath = resolveTrainingDatasetPrimaryPath();
        Path parent = datasetPath.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        Files.writeString(datasetPath, content, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE);

        clearTrainingDatasetCache();
        return datasetPath.toAbsolutePath().toString();
    }

    public List<TrainingDatasetVersionInfo> listTrainingDatasetVersions() {
        Path historyDir = resolveTrainingDatasetHistoryDirectory();
        if (historyDir == null || !Files.exists(historyDir) || !Files.isDirectory(historyDir)) {
            return Collections.emptyList();
        }

        List<TrainingDatasetVersionInfo> versions = new ArrayList<>();
        try (java.util.stream.Stream<Path> paths = Files.list(historyDir)) {
            paths.filter(path -> Files.isRegularFile(path))
                    .filter(path -> isTrainingDatasetHistoryFile(path.getFileName().toString()))
                    .sorted((a, b) -> {
                        try {
                            return Files.getLastModifiedTime(b).compareTo(Files.getLastModifiedTime(a));
                        } catch (java.io.IOException e) {
                            return a.getFileName().toString().compareToIgnoreCase(b.getFileName().toString());
                        }
                    })
                    .limit(12)
                    .forEach(path -> versions.add(buildVersionInfo(path)));
        } catch (java.io.IOException ignored) {
            return versions;
        }

        return versions;
    }

    public int pruneTrainingDatasetVersions(int olderThanDays) {
        if (olderThanDays < 0) {
            return 0;
        }

        Path historyDir = resolveTrainingDatasetHistoryDirectory();
        if (historyDir == null || !Files.exists(historyDir) || !Files.isDirectory(historyDir)) {
            return 0;
        }

        long cutoffMillis = System.currentTimeMillis() - (olderThanDays * 24L * 60L * 60L * 1000L);
        int deletedCount = 0;

        try (java.util.stream.Stream<Path> paths = Files.list(historyDir)) {
            List<Path> candidates = paths
                    .filter(path -> Files.isRegularFile(path))
                    .filter(path -> isTrainingDatasetHistoryFile(path.getFileName().toString()))
                    .collect(Collectors.toList());

            for (Path file : candidates) {
                try {
                    long modified = Files.getLastModifiedTime(file).toMillis();
                    if (modified < cutoffMillis) {
                        Files.deleteIfExists(file);
                        deletedCount++;
                    }
                } catch (java.io.IOException ignored) {
                    // Skip any file that cannot be deleted.
                }
            }
        } catch (java.io.IOException ignored) {
            return deletedCount;
        }

        return deletedCount;
    }

    @SuppressWarnings("unused")
    private static class TrainingDataset {
        List<TrainingIntent> intents;
        TrainingMasterData master_data;
        TrainingTone tone_and_voice;
        List<TrainingEdgeCase> edge_cases;
        TrainingContactInfo contact_info;
    }

    private static class TrainingIntent {
        String name;
        List<String> keywords;
    }

    private static class TrainingMasterData {
        List<TrainingProductData> products;
        List<TrainingPromotionData> promotions;
    }

    private static class TrainingProductData {
        Integer id;
        String name;
        Integer price;
        Integer original_price;
        Integer stock;
        String status;
        String cpu;
        Integer ram;
        String storage;
        String battery;
        String camera;
        Double rating;
        List<String> colors;
        String image;
        String image_url;
        String imageUrl;
    }

    private static class TrainingPromotionData {
        String id;
        String title;
        String discount;
        Boolean active;
    }

    @SuppressWarnings("unused")
    private static class TrainingTone {
        @com.google.gson.annotations.SerializedName("do")
        List<String> doItems;
        List<String> dont;
    }

    @SuppressWarnings("unused")
    private static class TrainingEdgeCase {
        String scenario;
        String action;
    }

    @SuppressWarnings("unused")
    private static class TrainingContactInfo {
        String hotline;
        String email;
    }

    @SuppressWarnings("unused")
    private static class TrainingPromotionSnapshot {
        String id;
        String title;
        String discount;
        Boolean active;
    }

    public static class TrainingDatasetVersionInfo {
        private String fileName;
        private long lastModified;
        private long sizeBytes;
        private boolean restorable;

        public String getFileName() {
            return fileName;
        }

        public long getLastModified() {
            return lastModified;
        }

        public long getSizeBytes() {
            return sizeBytes;
        }

        public boolean isRestorable() {
            return restorable;
        }
    }

    public ChatResponse processMessage(ChatRequest request) {
        String userMessage = request.getUserMessage().trim().toLowerCase();

        // Detect intent
        String intent = detectIntent(userMessage);

        // Process based on intent
        switch (intent) {
            case "GREETING":
                return handleGreeting();
            case "PRODUCT_RECOMMENDATION":
                return handleProductRecommendation(userMessage);
            case "PRODUCT_SEARCH":
                return handleProductSearch(userMessage);
            case "COMPARISON":
                return handleComparison(userMessage);
            case "PRICE_CHECK":
                return handlePriceCheck(userMessage);
            case "STOCK_CHECK":
                return handleStockCheck(userMessage);
            case "SHIPPING_INFO":
                return handleShippingInfo(userMessage);
            case "PROMOTION":
                return handlePromotion();
            case "TECHNICAL_FAQ":
                return handleTechnicalFAQ(userMessage);
            case "ORDER_STATUS":
                return handleOrderStatus(userMessage);
            default:
                return handleDefault();
        }
    }

    private String detectIntent(String message) {
        if (message.contains("xin chào") || message.contains("xin chao") || message.contains("hello") || containsWholeWord(message, "hi")) {
            return "GREETING";
        }
        if (message.contains("tư vấn") || message.contains("tu van") || message.contains("recommend") || message.contains("suggest")) {
            return "PRODUCT_RECOMMENDATION";
        }
        if (message.contains("so sánh") || message.contains("so sanh") || message.contains("compare") || message.contains("vs")) {
            return "COMPARISON";
        }
        if (message.contains("giá") || message.contains("gia") || message.contains("bao nhiêu") || message.contains("bao nhieu") || message.contains("price")) {
            return "PRICE_CHECK";
        }
        if (message.contains("tồn kho") || message.contains("ton kho") || message.contains("còn hàng") || message.contains("con hang") || message.contains("stock")) {
            return "STOCK_CHECK";
        }
        if (message.contains("vận chuyển") || message.contains("van chuyen") || message.contains("ship") || message.contains("giao")) {
            return "SHIPPING_INFO";
        }
        if (message.contains("ưu đãi") || message.contains("uu dai") || message.contains("khuyến mãi") || message.contains("khuyen mai") || message.contains("promotion")) {
            return "PROMOTION";
        }
        if (message.contains("pin") || message.contains("camera") || message.contains("ram") ||
            message.contains("cpu") || message.contains("chống nước") || message.contains("sạc nhanh")) {
            return "TECHNICAL_FAQ";
        }
        if (message.contains("đơn hàng") || message.contains("don hang") || message.contains("order") ||
            message.contains("mã đơn") || message.contains("ma don") || message.contains("ord")) {
            return "ORDER_STATUS";
        }
        if (message.contains("search") || message.contains("tìm") || message.contains("tim") || message.contains("loài") || message.contains("dien thoai") || message.contains("điện thoại") ||
            message.contains("iphone") || message.contains("samsung") || message.contains("xiaomi") ||
            message.contains("oppo") || message.contains("nothing")) {
            return "PRODUCT_SEARCH";
        }

        String trainingIntent = detectIntentFromTrainingDataset(message);
        if (trainingIntent != null) {
            return trainingIntent;
        }

        return "DEFAULT";
    }

    private String detectIntentFromTrainingDataset(String message) {
        TrainingDataset dataset = loadTrainingDataset();
        if (dataset == null || dataset.intents == null || dataset.intents.isEmpty()) {
            return null;
        }

        String normalizedMessage = normalizeText(message);
        TrainingIntent bestIntent = null;
        int bestScore = 0;

        for (TrainingIntent intent : dataset.intents) {
            if (intent == null || intent.name == null || intent.keywords == null) {
                continue;
            }

            int score = 0;
            for (String keyword : intent.keywords) {
                String normalizedKeyword = normalizeText(keyword);
                if (normalizedKeyword.isEmpty()) {
                    continue;
                }
                if (normalizedMessage.contains(normalizedKeyword)) {
                    score += 2;
                }
            }

            if (score > bestScore) {
                bestScore = score;
                bestIntent = intent;
            }
        }

        if (bestIntent == null || bestScore == 0) {
            return null;
        }

        return mapTrainingIntent(bestIntent.name);
    }

    private String mapTrainingIntent(String trainingIntentName) {
        if (trainingIntentName == null) {
            return null;
        }

        switch (trainingIntentName.trim().toUpperCase(Locale.ROOT)) {
            case "GREETING":
                return "GREETING";
            case "PRICE_QUERY":
                return "PRICE_CHECK";
            case "STOCK_CHECK":
                return "STOCK_CHECK";
            case "COMPARISON":
                return "COMPARISON";
            case "TECH_SPECS":
                return "TECHNICAL_FAQ";
            case "BUDGET_RECOMMENDATION":
                return "PRODUCT_RECOMMENDATION";
            case "PROMOTION":
                return "PROMOTION";
            case "ORDER_STATUS":
                return "ORDER_STATUS";
            case "PRODUCT_SEARCH":
                return "PRODUCT_SEARCH";
            case "SHIPPING_INFO":
                return "SHIPPING_INFO";
            case "OUT_OF_SCOPE":
                return "DEFAULT";
            default:
                return null;
        }
    }

    private TrainingDataset loadTrainingDataset() {
        if (trainingDataset != null) {
            return trainingDataset;
        }

        synchronized (this) {
            if (trainingDataset != null) {
                return trainingDataset;
            }

            TrainingDataset loaded = readTrainingDataset();
            if (loaded != null) {
                trainingDataset = loaded;
            }
            return trainingDataset;
        }
    }

    private TrainingDataset readTrainingDataset() {
        InputStream stream = null;

        try {
            if (servletContext != null) {
                stream = servletContext.getResourceAsStream(TRAINING_DATASET_PATH);
            }

            if (stream == null) {
                stream = getClass().getResourceAsStream(TRAINING_DATASET_PATH);
            }

            if (stream == null) {
                return null;
            }

            try (InputStream input = stream;
                 InputStreamReader reader = new InputStreamReader(input, StandardCharsets.UTF_8)) {
                return gson.fromJson(reader, TrainingDataset.class);
            }
        } catch (Exception ignored) {
            return null;
        }
    }

    private Path resolveTrainingDatasetSnapshotPath() {
        if (servletContext != null) {
            String realPath = servletContext.getRealPath("/assets/data/" + TRAINING_DATASET_SNAPSHOT_FILE);
            if (realPath != null && !realPath.trim().isEmpty()) {
                return Paths.get(realPath);
            }
        }

        return Paths.get(System.getProperty("user.dir"), "src", "main", "webapp", "assets", "data", TRAINING_DATASET_SNAPSHOT_FILE);
    }

    private Path resolveTrainingDatasetPrimaryPath() {
        if (servletContext != null) {
            String realPath = servletContext.getRealPath(TRAINING_DATASET_PATH);
            if (realPath != null && !realPath.trim().isEmpty()) {
                return Paths.get(realPath);
            }
        }

        return Paths.get(System.getProperty("user.dir"), "src", "main", "webapp", "assets", "data", TRAINING_DATASET_PATH.substring(1));
    }

    private Path resolveTrainingDatasetHistoryDirectory() {
        if (servletContext != null) {
            String realPath = servletContext.getRealPath("/assets/data");
            if (realPath != null && !realPath.trim().isEmpty()) {
                return Paths.get(realPath);
            }
        }

        return Paths.get(System.getProperty("user.dir"), "src", "main", "webapp", "assets", "data");
    }

    private Path resolveTrainingDatasetHistoryPath(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        String normalized = fileName.trim();
        if (!isTrainingDatasetHistoryFile(normalized) && !TRAINING_DATASET_SNAPSHOT_FILE.equals(normalized)) {
            return null;
        }

        Path historyDir = resolveTrainingDatasetHistoryDirectory();
        if (historyDir == null) {
            return null;
        }

        return historyDir.resolve(normalized).normalize();
    }

    private boolean isTrainingDatasetHistoryFile(String fileName) {
        if (fileName == null) {
            return false;
        }
        return fileName.startsWith(TRAINING_DATASET_HISTORY_PREFIX)
                && fileName.endsWith(TRAINING_DATASET_HISTORY_SUFFIX)
                && !TRAINING_DATASET_SNAPSHOT_FILE.equals(fileName)
                && !TRAINING_DATASET_PATH.substring(1).equals(fileName);
    }

    private void writeTrainingDatasetHistoryCopy(String json) throws java.io.IOException {
        Path historyDir = resolveTrainingDatasetHistoryDirectory();
        if (historyDir == null) {
            return;
        }

        Files.createDirectories(historyDir);
        String timestamp = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss"));
        Path historyPath = historyDir.resolve(TRAINING_DATASET_HISTORY_PREFIX + timestamp + TRAINING_DATASET_HISTORY_SUFFIX);
        Files.writeString(historyPath, json, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE);
    }

    private TrainingDatasetVersionInfo buildVersionInfo(Path path) {
        TrainingDatasetVersionInfo info = new TrainingDatasetVersionInfo();
        info.fileName = path.getFileName().toString();
        try {
            info.lastModified = Files.getLastModifiedTime(path).toMillis();
            info.sizeBytes = Files.size(path);
        } catch (java.io.IOException ignored) {
            info.lastModified = 0L;
            info.sizeBytes = 0L;
        }
        info.restorable = true;
        return info;
    }

    private String normalizeText(String text) {
        if (text == null) {
            return "";
        }

        String normalized = java.text.Normalizer.normalize(text, java.text.Normalizer.Form.NFD);
        normalized = normalized.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ").trim();
    }

    private ChatResponse handleGreeting() {
        ChatResponse response = new ChatResponse();
        response.setMessage("👋 Xin chào! Tôi là trợ lý bán hàng ảo của cửa hàng. Tôi rất vui được giúp bạn tìm được chiếc điện thoại hoặc thiết bị phù hợp nhất.\n\n" +
                "Bạn có thể hỏi tôi về:\n" +
                "📱 Tư vấn sản phẩm theo nhu cầu\n" +
                "🔍 Tìm kiếm và so sánh điện thoại\n" +
                "💰 Kiểm tra giá và khuyến mãi\n" +
                "📦 Thông tin vận chuyển\n" +
                "❓ Hỏi đáp kỹ thuật\n\n" +
                "Anh/chị muốn tìm tư vấn gì hôm nay ạ?");
        response.setResponseType("TEXT");
        response.setSuggestedQuestions(Arrays.asList(
                "Tư vấn giúp tôi với ngân sách 10 triệu",
                "So sánh iPhone 15 và Samsung S24",
                "Có ưu đãi nào không?"
        ));
        return response;
    }

    private ChatResponse handleProductRecommendation(String message) {
        ChatResponse response = new ChatResponse();
        
        // Extract budget if mentioned
        Integer budget = extractBudget(message);
        String brand = extractBrand(message);

        List<ChatProductSpec> recommendations = resolveRecommendedProducts(budget, brand, 5);

        if (recommendations.isEmpty()) {
            response.setMessage("😔 Xin lỗi, hiện tại chưa có sản phẩm phù hợp để gợi ý. Vui lòng thử lại sau.");
        } else {
            int count = Math.min(5, recommendations.size());
            response.setMessage("✨ Mình đã chọn " + count + " sản phẩm phù hợp. Bạn xem danh sách chi tiết ngay bên dưới nhé.");
            response.setProducts(recommendations.subList(0, count));
        }

        response.setResponseType("PRODUCT_LIST");
        response.setSuggestedQuestions(Arrays.asList(
                "So sánh giữa các sản phẩm này",
                "Có combo nào không?",
                "Phí vận chuyển là bao nhiêu?"
        ));
        return response;
    }

    private ChatResponse handleProductSearch(String message) {
        ChatResponse response = new ChatResponse();
        List<ChatProductSpec> results = searchProductsAcrossSources(message);

        if (results.isEmpty()) {
            response.setMessage("🔍 Không tìm thấy sản phẩm nào với từ khóa \"" + message + "\".\n" +
                    "Hãy thử tìm kiếm lại với tên khác hoặc yêu cầu tư vấn.");
        } else {
            response.setMessage(String.format("🔍 Tìm thấy %d sản phẩm phù hợp. Bạn xem danh sách bên dưới nhé.", results.size()));
            response.setProducts(results);
        }

        response.setResponseType("PRODUCT_LIST");
        return response;
    }

    private ChatResponse handleComparison(String message) {
        ChatResponse response = new ChatResponse();
        List<ChatProductSpec> selected = pickProductsForComparison(message);

        if (selected.size() < 2) {
            response.setMessage("📊 Bạn hãy nhập rõ tên 2 sản phẩm để so sánh. Ví dụ: \"so sánh iPhone và Samsung\".");
            response.setResponseType("TEXT");
            response.setSuggestedQuestions(Arrays.asList(
                    "So sánh iPhone và Samsung",
                    "So sánh các máy dưới 15 triệu",
                    "Tư vấn máy pin tốt"
            ));
            return response;
        }

        StringBuilder table = new StringBuilder();
        table.append("📊 <b>BẢNG SO SÁNH SẢN PHẨM</b><br><br>");
        table.append("<table border='1' cellspacing='0' cellpadding='8' style='border-collapse:collapse; width:100%;'>");

        table.append("<tr><th>Tiêu chí</th>");
        for (ChatProductSpec p : selected) {
            table.append("<th>").append(p.getName()).append("</th>");
        }
        table.append("</tr>");

        appendComparisonRow(table, "Giá", selected, p -> p.formatPrice());
        appendComparisonRow(table, "Thương hiệu", selected, ChatProductSpec::getBrand);
        appendComparisonRow(table, "Model/Chip", selected, ChatProductSpec::getCpu);
        appendComparisonRow(table, "RAM", selected, p -> p.getRam() + "GB");
        appendComparisonRow(table, "Bộ nhớ", selected, p -> p.getStorage() + "GB");
        appendComparisonRow(table, "Pin", selected, p -> p.getBattery() + "mAh");
        appendComparisonRow(table, "Camera", selected, ChatProductSpec::getRearCamera);
        appendComparisonRow(table, "Màu sắc", selected, ChatProductSpec::getColors);
        appendComparisonRow(table, "Tồn kho", selected, ChatProductSpec::getStockStatus);
        table.append("</table>");

        response.setMessage(table.toString());
        // Comparison already renders as an HTML table in message,
        // avoid sending product cards again to prevent duplicated content.
        response.setProducts(Collections.emptyList());
        response.setResponseType("COMPARISON");
        response.setSuggestedQuestions(Arrays.asList(
                "Máy nào phù hợp chơi game?",
                "Máy nào pin tốt hơn?",
                "Tư vấn thêm theo ngân sách của tôi"
        ));
        return response;
    }

    private ChatResponse handlePriceCheck(String message) {
        ChatResponse response = new ChatResponse();
        List<ChatProductSpec> allProducts;
        String brand = extractBrand(message);
        if (brand != null) {
            allProducts = searchProductsByBrandAcrossSources(brand);
        } else {
            allProducts = searchProductsAcrossSources(message);
            if (allProducts.isEmpty()) {
                allProducts = getAllProductsAcrossSources();
            }
        }

        if (allProducts.isEmpty()) {
            response.setMessage("💰 Hiện chưa có dữ liệu giá phù hợp với yêu cầu của bạn.");
            response.setResponseType("TEXT");
            return response;
        }

        int limit = Math.min(6, allProducts.size());
        List<ChatProductSpec> displayProducts = allProducts.subList(0, limit);
        response.setMessage("💰 Mình đã lọc " + limit + " sản phẩm theo giá. Bạn xem chi tiết ngay bên dưới nhé.");
        response.setProducts(displayProducts);
        response.setResponseType("PRODUCT_LIST");
        response.setSuggestedQuestions(Arrays.asList(
                "Sản phẩm nào dưới 10 triệu?",
                "Máy nào đáng mua nhất?",
                "So sánh 2 sản phẩm này"
        ));
        return response;
    }

    private ChatResponse handleStockCheck(String message) {
        ChatResponse response = new ChatResponse();
        List<ChatProductSpec> inStock;
        String brand = extractBrand(message);
        if (brand != null) {
            inStock = searchProductsByBrandAcrossSources(brand).stream()
                    .filter(p -> p.getStock() > 0)
                    .collect(Collectors.toList());
        } else {
            inStock = getInStockProductsAcrossSources();
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📦 <b>TÌNH TRẠNG HÀNG</b>\n\n");
        
        for (ChatProductSpec product : inStock) {
            String status = product.getStock() > 0 ? "✅ Còn hàng" : "❌ Hết hàng";
            sb.append(String.format("• <b>%s</b> - %s (%d sản phẩm)\n", 
                product.getName(), status, product.getStock()));
        }

        response.setMessage(sb.toString());
        response.setResponseType("TEXT");
        return response;
    }

    private ChatResponse handleShippingInfo(String message) {
        ChatResponse response = new ChatResponse();
        response.setMessage(shippingDAO.getShippingDescription() +
                "\n✨ <b>LƯU Ý:</b> Giao hàng từ thứ 2 đến thứ 7. Thứ chủ nhật không giao hàng.");
        response.setResponseType("TEXT");
        return response;
    }

    private ChatResponse handlePromotion() {
        ChatResponse response = new ChatResponse();
        StringBuilder sb = new StringBuilder();
        sb.append("🎉 <b>ƯU ĐÃI HIỆN TẠI</b>\n\n");

        List<String> datasetPromotions = getTrainingPromotionLines();
        if (!datasetPromotions.isEmpty()) {
            for (String line : datasetPromotions) {
                sb.append(line).append("\n");
            }
            sb.append("\n");
        } else {
            List<Voucher> vouchers = voucherDAO.getAllVouchers();
            Date today = new Date();
            List<Voucher> activeVouchers = vouchers.stream()
                    .filter(Voucher::isActive)
                    .filter(v -> v.getStartDate() == null || !v.getStartDate().after(today))
                    .filter(v -> v.getEndDate() == null || !v.getEndDate().before(today))
                    .filter(v -> v.getQuantity() == null || v.getUsedCount() == null || v.getUsedCount() < v.getQuantity())
                    .limit(5)
                    .collect(Collectors.toList());

            if (activeVouchers.isEmpty()) {
                sb.append("Hiện tại chưa có voucher công khai. Bạn có thể theo dõi trang ưu đãi để cập nhật sớm nhất.\n\n");
            } else {
                for (Voucher voucher : activeVouchers) {
                    sb.append("• <b>").append(voucher.getCode()).append("</b>");
                    if (voucher.getDescription() != null && !voucher.getDescription().trim().isEmpty()) {
                        sb.append(" - ").append(voucher.getDescription().trim());
                    }
                    sb.append("\n");
                    if (voucher.getDiscountType() != null && voucher.getDiscountValue() != null) {
                        if ("PERCENT".equalsIgnoreCase(voucher.getDiscountType())) {
                            sb.append("  Giảm: ").append(voucher.getDiscountValue().stripTrailingZeros().toPlainString()).append("%\n");
                        } else {
                            sb.append("  Giảm: ").append(String.format("%,.0f ₫", voucher.getDiscountValue())).append("\n");
                        }
                    }
                    if (voucher.getMinOrderValue() != null) {
                        sb.append("  Đơn tối thiểu: ").append(String.format("%,.0f ₫", voucher.getMinOrderValue())).append("\n");
                    }
                    sb.append("\n");
                }
            }
        }

        sb.append("💡 Bạn có thể áp mã tại bước thanh toán để nhận giảm giá.");
        response.setMessage(sb.toString());
        response.setResponseType("TEXT");
        return response;
    }

    private ChatResponse handleTechnicalFAQ(String message) {
        ChatResponse response = new ChatResponse();
        
        if (message.contains("chống nước")) {
            response.setMessage("💧 <b>CHỐNG NƯỚC IP68 LÀ GÌ?</b>\n\n" +
                    "IP68 là tiêu chuẩn chống nước cao nhất:\n" +
                    "• Chịu được ngâm nước sâu 1.5m trong 30 phút\n" +
                    "• Chống bụi hoàn toàn\n" +
                    "• Tất cả sản phẩm của chúng tôi đều có IP68\n\n" +
                    "⚠️ <b>Lưu ý:</b> Nước nóng, nước biển, hóa chất có thể làm hỏng thiết bị!");
        } else if (message.contains("sạc nhanh")) {
            response.setMessage("⚡ <b>SẠC NHANH</b>\n\n" +
                    "So sánh tốc độ sạc:\n" +
                    "• iPhone 15 Pro: 20W (sạc 0→100% trong ~45 phút)\n" +
                    "• Samsung S24 Ultra: 45W (sạc 0→100% trong ~30 phút)\n" +
                    "• Xiaomi 14T Pro: 120W HyperCharge (sạc 0→100% trong ~20 phút)\n" +
                    "• Nothing Phone 2: 45W (sạc 0→100% trong ~30 phút)\n\n" +
                    "💡 Sạc nhanh 120W rất an toàn, không làm hỏng pin!");
        } else if (message.contains("camera")) {
            response.setMessage("📷 <b>THÔNG TIN CAMERA</b>\n\n" +
                    "Megapixel cao ≠ chất lượng tốt. Hãy xem xét:\n" +
                    "• Kích thước cảm biến\n" +
                    "• Khẩu độ\n" +
                    "• Xử lý AI\n" +
                    "• Chế độ đêm\n\n" +
                    "📱 Gợi ý: Samsung S24 Ultra có camera tốt nhất, giải pháp xóa phông đỉnh cao!\n\n" +
                    "Bạn muốn tư vấn về camera cho mục đích nào? (chụp ảnh, chụp video, selfie)");
        } else if (message.contains("pin")) {
            response.setMessage("🔋 <b>DUNG LƯỢNG PIN</b>\n\n" +
                    "Thời lượng pin phụ thuộc vào:\n" +
                    "• Dung lượng (mAh)\n" +
                    "• Kích thước màn hình và tần số\n" +
                    "• Hiệu suất CPU\n" +
                    "• Cách sử dụng của bạn\n\n" +
                    "💡 Với pin 5000mAh+, bạn sử dụng cả ngày mà không lo hết pin!");
        } else {
            response.setMessage("❓ Bạn muốn hỏi về điều gì? Tôi có thể giới thiệu:\n" +
                    "• 💧 Chống nước IP68\n" +
                    "• ⚡ Sạc nhanh\n" +
                    "• 📷 Camera\n" +
                    "• 🔋 Pin\n" +
                    "• 💾 RAM/Bộ nhớ\n\n" +
                    "Hoặc nhắn cho nhân viên tư vấn trực tiếp để giải đáp!");
        }
        
        response.setResponseType("TEXT");
        return response;
    }

    private ChatResponse handleOrderStatus(String message) {
        ChatResponse response = new ChatResponse();
        Integer orderId = extractOrderId(message);

        if (orderId == null) {
            response.setMessage("📦 <b>TRA CỨU ĐƠN HÀNG</b>\n\n" +
                    "Bạn vui lòng gửi mã/ID đơn hàng để mình kiểm tra giúp.\n" +
                    "Ví dụ: \"kiểm tra đơn 123\" hoặc \"trạng thái ORD123\".");
            response.setResponseType("TEXT");
            response.setSuggestedQuestions(Arrays.asList(
                    "Kiểm tra đơn 123",
                    "Trạng thái ORD123",
                    "Đơn hàng của tôi đang ở đâu?"
            ));
            return response;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.setMessage("❌ Không tìm thấy đơn hàng #" + orderId + ".\n" +
                    "Bạn vui lòng kiểm tra lại mã đơn hoặc liên hệ CSKH.");
            response.setResponseType("TEXT");
            return response;
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📦 <b>THÔNG TIN ĐƠN HÀNG #").append(order.getOrderId()).append("</b>\n\n");
        sb.append("• Trạng thái: <b>").append(order.getStatusLabel()).append("</b>\n");
        sb.append("• Thanh toán: ").append(order.getPaymentStatusLabel()).append(" (")
                .append(order.getPaymentMethodLabel()).append(")\n");
        sb.append("• Tổng tiền: <b>").append(order.getFormattedTotal()).append("</b>\n");

        if (order.getCreatedAtFormatted() != null && !order.getCreatedAtFormatted().isEmpty()) {
            sb.append("• Ngày đặt: ").append(order.getCreatedAtFormatted()).append("\n");
        }

        if (order.getShippingAddress() != null && !order.getShippingAddress().trim().isEmpty()) {
            sb.append("• Địa chỉ giao: ").append(order.getShippingAddress()).append("\n");
        }

        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            sb.append("\n<b>Sản phẩm:</b>\n");
            int limit = Math.min(5, order.getOrderItems().size());
            for (int i = 0; i < limit; i++) {
                OrderItem item = order.getOrderItems().get(i);
                sb.append("- ").append(item.getProductName())
                        .append(" x").append(item.getQuantity())
                        .append(" (" ).append(item.getFormattedSubtotal()).append(")\n");
            }
            if (order.getOrderItems().size() > limit) {
                sb.append("... và ").append(order.getOrderItems().size() - limit).append(" sản phẩm khác\n");
            }
        }

        response.setMessage(sb.toString());
        response.setResponseType("TEXT");
        response.setSuggestedQuestions(Arrays.asList(
                "Bao giờ đơn hàng được giao?",
                "Tôi muốn đổi địa chỉ giao hàng",
                "Tôi muốn hủy đơn"
        ));
        return response;
    }

    private ChatResponse handleDefault() {
        ChatResponse response = new ChatResponse();
        response.setMessage("😊 Tôi không hiểu rõ câu hỏi của bạn. Bạn có thể:\n\n" +
                "📱 Tìm kiếm sản phẩm (ví dụ: \"iPhone 15\", \"Samsung\")\n" +
                "💰 Hỏi về giá cả\n" +
                "📊 So sánh sản phẩm\n" +
                "📦 Kiểm tra tồn kho\n" +
                "❓ Hỏi câu hỏi kỹ thuật\n" +
                "🎉 Xem khuyến mãi\n\n" +
                "Hoặc bạn có muốn chat với nhân viên tư vấn trực tiếp không ạ?");
        response.setResponseType("TEXT");
        return response;
    }

    // Helper methods
    private Integer extractBudget(String message) {
        Pattern pattern = Pattern.compile("(\\d{1,4})\\s*(triệu|tr|m|k|ngàn|nghìn)?");
        java.util.regex.Matcher matcher = pattern.matcher(message);
        if (matcher.find()) {
            String unit = matcher.group(2);
            Integer value = Integer.parseInt(matcher.group(1));
            if (unit == null || unit.trim().isEmpty()) {
                // Nếu không ghi đơn vị, giả định đã nhập giá VNĐ nếu >= 100000, ngược lại coi như triệu.
                return value >= 100000 ? value : value * 1000000;
            }

            String normalized = unit.trim().toLowerCase();
            if ("k".equals(normalized) || "ngàn".equals(normalized) || "nghìn".equals(normalized)) {
                return value * 1000;
            }

            return value * 1000000;
        }
        return null;
    }

    private boolean containsWholeWord(String text, String word) {
        if (text == null || word == null || word.trim().isEmpty()) {
            return false;
        }
        Pattern p = Pattern.compile("(^|\\s)" + Pattern.quote(word) + "(\\s|$)", Pattern.CASE_INSENSITIVE);
        return p.matcher(text).find();
    }

    private String extractBrand(String message) {
        String[] brands = {"apple", "iphone", "samsung", "xiaomi", "oppo", "nothing"};
        for (String brand : brands) {
            if (message.contains(brand)) {
                return brand.startsWith("apple") || brand.startsWith("iphone") ? "Apple" : 
                       brand.equals("samsung") ? "Samsung" :
                       brand.equals("xiaomi") ? "Xiaomi" :
                       brand.equals("oppo") ? "OPPO" : "Nothing";
            }
        }
        return null;
    }

    private Integer extractOrderId(String message) {
        if (message == null || message.trim().isEmpty()) {
            return null;
        }

        Pattern ordPattern = Pattern.compile("ord\\s*#?\\s*(\\d+)", Pattern.CASE_INSENSITIVE);
        java.util.regex.Matcher ordMatcher = ordPattern.matcher(message);
        if (ordMatcher.find()) {
            return parsePositiveInt(ordMatcher.group(1));
        }

        Pattern hashPattern = Pattern.compile("#(\\d+)");
        java.util.regex.Matcher hashMatcher = hashPattern.matcher(message);
        if (hashMatcher.find()) {
            return parsePositiveInt(hashMatcher.group(1));
        }

        Pattern anyNumberPattern = Pattern.compile("\\b(\\d{1,9})\\b");
        java.util.regex.Matcher anyNumberMatcher = anyNumberPattern.matcher(message);
        if (anyNumberMatcher.find()) {
            return parsePositiveInt(anyNumberMatcher.group(1));
        }

        return null;
    }

    private Integer parsePositiveInt(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : null;
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private List<ChatProductSpec> pickProductsForComparison(String message) {
        List<ChatProductSpec> candidates = new ArrayList<>();
        String normalized = message == null ? "" : message.toLowerCase();

        String[] splitTokens = {" so sánh ", " so sanh ", " vs ", " và ", ","};
        List<String> parts = new ArrayList<>();
        parts.add(normalized);
        for (String token : splitTokens) {
            List<String> nextParts = new ArrayList<>();
            for (String part : parts) {
                nextParts.addAll(Arrays.asList(part.split(Pattern.quote(token))));
            }
            parts = nextParts;
        }

        for (String part : parts) {
            String key = part.trim();
            if (key.length() < 2) {
                continue;
            }

            // Ignore generic tokens to avoid triggering comparison with random products.
            if ("so sánh".equals(key) || "so sanh".equals(key) || "sản phẩm".equals(key) ||
                "san pham".equals(key) || "product".equals(key) || "products".equals(key)) {
                continue;
            }

            List<ChatProductSpec> found = searchProductsAcrossSources(key);
            if (!found.isEmpty()) {
                ChatProductSpec first = found.get(0);
                boolean exists = candidates.stream().anyMatch(p -> p.getId().equals(first.getId()));
                if (!exists) {
                    candidates.add(first);
                }
            }
            if (candidates.size() == 3) {
                break;
            }
        }

        if (candidates.size() > 3) {
            return candidates.subList(0, 3);
        }
        return candidates;
    }

    private List<ChatProductSpec> resolveRecommendedProducts(Integer budget, String brand, int limit) {
        List<ChatProductSpec> products = getAllProductsAcrossSources();
        if (products.isEmpty()) {
            return Collections.emptyList();
        }

        List<ChatProductSpec> filtered = new ArrayList<>(products);
        if (budget != null) {
            int minPrice = Math.max(0, budget - 2000000);
            int maxPrice = budget + 2000000;
            filtered = filtered.stream()
                    .filter(p -> resolveDisplayPrice(p) >= minPrice && resolveDisplayPrice(p) <= maxPrice)
                    .collect(Collectors.toList());
        }

        if (brand != null && !brand.trim().isEmpty()) {
            String normalizedBrand = normalizeText(brand);
            filtered = filtered.stream()
                    .filter(p -> normalizeText(p.getBrand()).contains(normalizedBrand)
                            || normalizeText(p.getName()).contains(normalizedBrand))
                    .collect(Collectors.toList());
        }

        filtered.sort((a, b) -> {
            double ratingA = a.getRating() == null ? 0.0 : a.getRating();
            double ratingB = b.getRating() == null ? 0.0 : b.getRating();
            int byRating = Double.compare(ratingB, ratingA);
            if (byRating != 0) {
                return byRating;
            }
            return Integer.compare(resolveDisplayPrice(a), resolveDisplayPrice(b));
        });

        if (filtered.isEmpty() && budget != null) {
            filtered = products.stream()
                    .sorted((a, b) -> Double.compare(
                            b.getRating() == null ? 0.0 : b.getRating(),
                            a.getRating() == null ? 0.0 : a.getRating()))
                    .collect(Collectors.toList());
        }

        return filtered.stream().limit(limit).collect(Collectors.toList());
    }

    private List<ChatProductSpec> searchProductsAcrossSources(String keyword) {
        Map<Integer, ChatProductSpec> merged = new LinkedHashMap<>();

        for (ChatProductSpec product : searchTrainingProducts(keyword)) {
            if (product != null && product.getId() != null) {
                merged.put(product.getId(), product);
            }
        }

        for (ChatProductSpec product : productDAO.searchProducts(keyword)) {
            if (product != null && product.getId() != null) {
                if (merged.containsKey(product.getId())) {
                    enrichProductWithDbData(merged.get(product.getId()), product);
                } else {
                    merged.put(product.getId(), product);
                }
            }
        }

        if (merged.isEmpty()) {
            merged.putAll(indexProducts(getAllProductsAcrossSources()));
        }

        return new ArrayList<>(merged.values());
    }

    private List<ChatProductSpec> searchProductsByBrandAcrossSources(String brand) {
        String normalizedBrand = normalizeText(brand);
        if (normalizedBrand.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Integer, ChatProductSpec> merged = new LinkedHashMap<>();
        for (ChatProductSpec product : getAllProductsAcrossSources()) {
            String productBrand = normalizeText(product.getBrand());
            String productName = normalizeText(product.getName());
            if (productBrand.contains(normalizedBrand) || productName.contains(normalizedBrand)) {
                if (product.getId() != null) {
                    merged.put(product.getId(), product);
                }
            }
        }
        return new ArrayList<>(merged.values());
    }

    private List<ChatProductSpec> getInStockProductsAcrossSources() {
        return getAllProductsAcrossSources().stream()
                .filter(p -> p.getStock() > 0)
                .collect(Collectors.toList());
    }

    private List<ChatProductSpec> getAllProductsAcrossSources() {
        Map<Integer, ChatProductSpec> merged = new LinkedHashMap<>();

        for (ChatProductSpec product : getTrainingProducts()) {
            if (product != null && product.getId() != null) {
                merged.put(product.getId(), product);
            }
        }

        for (ChatProductSpec product : productDAO.getAllProducts()) {
            if (product != null && product.getId() != null) {
                if (merged.containsKey(product.getId())) {
                    enrichProductWithDbData(merged.get(product.getId()), product);
                } else {
                    merged.put(product.getId(), product);
                }
            }
        }

        return new ArrayList<>(merged.values());
    }

    private void enrichProductWithDbData(ChatProductSpec target, ChatProductSpec source) {
        if (target == null || source == null) {
            return;
        }

        if (isBlank(target.getImageUrl()) && !isBlank(source.getImageUrl())) {
            target.setImageUrl(source.getImageUrl());
        }
        if (target.getRating() == null && source.getRating() != null) {
            target.setRating(source.getRating());
        }
        if (target.getStock() == null && source.getStock() != null) {
            target.setStock(source.getStock());
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private Map<Integer, ChatProductSpec> indexProducts(List<ChatProductSpec> products) {
        Map<Integer, ChatProductSpec> indexed = new LinkedHashMap<>();
        for (ChatProductSpec product : products) {
            if (product != null && product.getId() != null) {
                indexed.put(product.getId(), product);
            }
        }
        return indexed;
    }

    private List<ChatProductSpec> getTrainingProducts() {
        TrainingDataset dataset = loadTrainingDataset();
        if (dataset == null || dataset.master_data == null || dataset.master_data.products == null) {
            return Collections.emptyList();
        }

        List<ChatProductSpec> mapped = new ArrayList<>();
        for (TrainingProductData product : dataset.master_data.products) {
            ChatProductSpec spec = mapTrainingProduct(product);
            if (spec != null) {
                mapped.add(spec);
            }
        }
        return mapped;
    }

    private List<ChatProductSpec> searchTrainingProducts(String keyword) {
        String normalizedKeyword = normalizeText(keyword);
        if (normalizedKeyword.isEmpty()) {
            return Collections.emptyList();
        }

        List<ChatProductSpec> matches = new ArrayList<>();
        for (ChatProductSpec product : getTrainingProducts()) {
            String name = normalizeText(product.getName());
            String brand = normalizeText(product.getBrand());
            String desc = normalizeText(product.getDescription());
            if (name.contains(normalizedKeyword) || brand.contains(normalizedKeyword) || desc.contains(normalizedKeyword)) {
                matches.add(product);
            }
        }
        return matches;
    }

    private List<String> getTrainingPromotionLines() {
        TrainingDataset dataset = loadTrainingDataset();
        if (dataset == null || dataset.master_data == null || dataset.master_data.promotions == null) {
            return Collections.emptyList();
        }

        List<String> lines = new ArrayList<>();
        for (TrainingPromotionData promo : dataset.master_data.promotions) {
            if (promo == null || Boolean.FALSE.equals(promo.active) || promo.title == null || promo.title.trim().isEmpty()) {
                continue;
            }

            StringBuilder line = new StringBuilder();
            line.append("• <b>").append(promo.title.trim()).append("</b>");
            if (promo.discount != null && !promo.discount.trim().isEmpty()) {
                line.append(" - ").append(promo.discount.trim());
            }
            lines.add(line.toString());
        }

        return lines;
    }

    private List<TrainingPromotionSnapshot> buildTrainingPromotionSnapshots() {
        List<TrainingPromotionSnapshot> snapshots = new ArrayList<>();
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        Date today = new Date();

        for (Voucher voucher : vouchers) {
            if (voucher == null || !voucher.isActive()) {
                continue;
            }
            if (voucher.getStartDate() != null && voucher.getStartDate().after(today)) {
                continue;
            }
            if (voucher.getEndDate() != null && voucher.getEndDate().before(today)) {
                continue;
            }
            if (voucher.getQuantity() != null && voucher.getUsedCount() != null && voucher.getUsedCount() >= voucher.getQuantity()) {
                continue;
            }

            TrainingPromotionSnapshot snapshot = new TrainingPromotionSnapshot();
            snapshot.id = String.valueOf(voucher.getVoucherId());
            snapshot.title = voucher.getCode();
            snapshot.discount = formatVoucherDiscount(voucher);
            snapshot.active = true;
            snapshots.add(snapshot);
        }

        if (!snapshots.isEmpty()) {
            return snapshots;
        }

        TrainingDataset dataset = loadTrainingDataset();
        if (dataset == null || dataset.master_data == null || dataset.master_data.promotions == null) {
            return snapshots;
        }

        for (TrainingPromotionData promo : dataset.master_data.promotions) {
            if (promo == null || promo.title == null || promo.title.trim().isEmpty()) {
                continue;
            }

            TrainingPromotionSnapshot snapshot = new TrainingPromotionSnapshot();
            snapshot.id = promo.id;
            snapshot.title = promo.title;
            snapshot.discount = promo.discount;
            snapshot.active = promo.active;
            snapshots.add(snapshot);
        }

        return snapshots;
    }

    private String formatVoucherDiscount(Voucher voucher) {
        if (voucher == null || voucher.getDiscountValue() == null) {
            return "";
        }

        if ("PERCENT".equalsIgnoreCase(voucher.getDiscountType())) {
            return voucher.getDiscountValue().stripTrailingZeros().toPlainString() + "%";
        }

        return String.format("%,.0f ₫", voucher.getDiscountValue());
    }

    private ChatProductSpec mapTrainingProduct(TrainingProductData product) {
        if (product == null || product.name == null || product.name.trim().isEmpty()) {
            return null;
        }

        ChatProductSpec spec = new ChatProductSpec();
        spec.setId(product.id);
        spec.setName(product.name.trim());
        spec.setBrand(inferBrandFromName(product.name));
        spec.setPrice(product.price == null ? 0 : product.price);
        spec.setDiscountedPrice(null);
        spec.setCpu(defaultIfBlank(product.cpu, "Đang cập nhật"));
        spec.setRam(product.ram == null ? 0 : product.ram);
        spec.setStorage(parseStorage(product.storage));
        spec.setBattery(parseBattery(product.battery));
        spec.setFrontCamera(defaultIfBlank(product.camera, "Đang cập nhật"));
        spec.setRearCamera(defaultIfBlank(product.camera, "Đang cập nhật"));
        spec.setColors(product.colors == null || product.colors.isEmpty() ? "Nhiều màu" : String.join(", ", product.colors));
        spec.setStock(product.stock == null ? 0 : product.stock);
        spec.setDescription(buildTrainingProductDescription(product));
        spec.setRating(product.rating == null ? 4.5d : product.rating);
        spec.setImageUrl(resolveTrainingProductImage(product));
        return spec;
    }

    private String resolveTrainingProductImage(TrainingProductData product) {
        if (product == null) {
            return null;
        }
        if (!isBlank(product.imageUrl)) {
            return product.imageUrl.trim();
        }
        if (!isBlank(product.image_url)) {
            return product.image_url.trim();
        }
        if (!isBlank(product.image)) {
            return product.image.trim();
        }
        return null;
    }

    private String buildTrainingProductDescription(TrainingProductData product) {
        List<String> parts = new ArrayList<>();
        if (product.status != null && !product.status.trim().isEmpty()) {
            parts.add(product.status.trim());
        }
        if (product.original_price != null && product.price != null && product.original_price > product.price) {
            parts.add("Giá gốc: " + formatCurrency(product.original_price));
        }
        if (product.cpu != null && !product.cpu.trim().isEmpty()) {
            parts.add("CPU: " + product.cpu.trim());
        }
        if (product.camera != null && !product.camera.trim().isEmpty()) {
            parts.add("Camera: " + product.camera.trim());
        }
        return parts.isEmpty() ? "Sản phẩm trong training dataset" : String.join(" | ", parts);
    }

    private String inferBrandFromName(String name) {
        String normalized = normalizeText(name);
        if (normalized.contains("iphone") || normalized.contains("apple")) {
            return "Apple";
        }
        if (normalized.contains("samsung")) {
            return "Samsung";
        }
        if (normalized.contains("xiaomi")) {
            return "Xiaomi";
        }
        if (normalized.contains("oppo")) {
            return "OPPO";
        }
        if (normalized.contains("realme")) {
            return "Realme";
        }
        if (normalized.contains("nothing")) {
            return "Nothing";
        }
        return "Không rõ";
    }

    private Integer parseStorage(String storage) {
        if (storage == null) {
            return 0;
        }
        Pattern pattern = Pattern.compile("(\\d{2,4})");
        java.util.regex.Matcher matcher = pattern.matcher(storage);
        if (matcher.find()) {
            return parsePositiveInt(matcher.group(1));
        }
        return 0;
    }

    private Integer parseBattery(String battery) {
        if (battery == null) {
            return 0;
        }
        Pattern pattern = Pattern.compile("(\\d{3,5})");
        java.util.regex.Matcher matcher = pattern.matcher(battery);
        if (matcher.find()) {
            return parsePositiveInt(matcher.group(1));
        }
        return 0;
    }

    private int resolveDisplayPrice(ChatProductSpec product) {
        if (product == null) {
            return Integer.MAX_VALUE;
        }
        Integer discounted = product.getDiscountedPrice();
        if (discounted != null && discounted > 0) {
            return discounted;
        }
        return product.getPrice() == null ? Integer.MAX_VALUE : product.getPrice();
    }

    private String formatCurrency(Integer value) {
        if (value == null) {
            return "0 ₫";
        }
        return String.format("%,d ₫", value);
    }

    private int resolveTrainingHistoryRetentionDays() {
        Integer value = parsePositiveOrZeroInt(System.getProperty(TRAINING_HISTORY_RETENTION_PROPERTY));
        if (value != null) {
            return value;
        }

        value = parsePositiveOrZeroInt(System.getenv(TRAINING_HISTORY_RETENTION_ENV));
        if (value != null) {
            return value;
        }

        value = readRetentionDaysFromPropertiesFile();
        if (value != null) {
            return value;
        }

        return DEFAULT_TRAINING_HISTORY_RETENTION_DAYS;
    }

    private Integer readRetentionDaysFromPropertiesFile() {
        Properties props = new Properties();

        if (servletContext != null) {
            try (InputStream is = servletContext.getResourceAsStream("/WEB-INF/classes/chatbot.properties")) {
                if (is != null) {
                    props.load(new InputStreamReader(is, StandardCharsets.UTF_8));
                    Integer parsed = parsePositiveOrZeroInt(props.getProperty(TRAINING_HISTORY_RETENTION_PROPERTY));
                    if (parsed != null) {
                        return parsed;
                    }
                }
            } catch (Exception ignored) {
                // Fall back to local file lookup.
            }
        }

        Path localConfig = Paths.get("chatbot.properties");
        if (!Files.exists(localConfig) || !Files.isRegularFile(localConfig)) {
            return null;
        }

        try (InputStream is = Files.newInputStream(localConfig)) {
            props.clear();
            props.load(new InputStreamReader(is, StandardCharsets.UTF_8));
            return parsePositiveOrZeroInt(props.getProperty(TRAINING_HISTORY_RETENTION_PROPERTY));
        } catch (Exception ignored) {
            return null;
        }
    }

    private Integer parsePositiveOrZeroInt(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return null;
        }
        try {
            int parsed = Integer.parseInt(raw.trim());
            return parsed >= 0 ? parsed : null;
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private String defaultIfBlank(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }
        return value.trim();
    }

    private void appendComparisonRow(StringBuilder table,
                                     String label,
                                     List<ChatProductSpec> products,
                                     java.util.function.Function<ChatProductSpec, String> valueFn) {
        table.append("<tr><td><b>").append(label).append("</b></td>");
        for (ChatProductSpec p : products) {
            String value = valueFn.apply(p);
            table.append("<td>").append(value == null ? "-" : value).append("</td>");
        }
        table.append("</tr>");
    }
}
