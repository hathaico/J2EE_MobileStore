package com.mobilestore.service;

import com.mobilestore.model.*;
import com.mobilestore.dao.ChatProductDAO;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ShippingDAO;
import com.mobilestore.dao.VoucherDAO;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class ChatBotService {
    private ChatProductDAO productDAO = new ChatProductDAO();
    private ShippingDAO shippingDAO = new ShippingDAO();
    private VoucherDAO voucherDAO = new VoucherDAO();
    private OrderDAO orderDAO = new OrderDAO();

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
        return "DEFAULT";
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

        List<ChatProductSpec> recommendations = new ArrayList<>();

        if (budget != null) {
            recommendations = productDAO.getProductsByPriceRange(budget - 2000000, budget + 2000000);
        } else if (brand != null && !brand.isEmpty()) {
            recommendations = productDAO.getProductsByBrand(brand);
        } else {
            recommendations = productDAO.getTopRatedProducts(5);
        }

        if (recommendations.isEmpty()) {
            recommendations = productDAO.getTopRatedProducts(5);
        }

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
        List<ChatProductSpec> results = productDAO.searchProducts(message);

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
            allProducts = productDAO.getProductsByBrand(brand);
        } else {
            allProducts = productDAO.searchProducts(message);
            if (allProducts.isEmpty()) {
                allProducts = productDAO.getAllProducts();
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
            inStock = productDAO.getProductsByBrand(brand).stream()
                    .filter(p -> p.getStock() > 0)
                    .collect(Collectors.toList());
        } else {
            inStock = productDAO.getInStockProducts();
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
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        Date today = new Date();
        List<Voucher> activeVouchers = vouchers.stream()
                .filter(Voucher::isActive)
                .filter(v -> v.getStartDate() == null || !v.getStartDate().after(today))
                .filter(v -> v.getEndDate() == null || !v.getEndDate().before(today))
                .filter(v -> v.getQuantity() == null || v.getUsedCount() == null || v.getUsedCount() < v.getQuantity())
                .limit(5)
                .collect(Collectors.toList());

        StringBuilder sb = new StringBuilder();
        sb.append("🎉 <b>ƯU ĐÃI HIỆN TẠI</b>\n\n");

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

            List<ChatProductSpec> found = productDAO.searchProducts(key);
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
