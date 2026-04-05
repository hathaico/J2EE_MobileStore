package com.mobilestore.springcontroller;

import com.mobilestore.model.ChatRequest;
import com.mobilestore.model.ChatResponse;
import com.mobilestore.service.ChatBotService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

@WebServlet("/api/chatbot/*")
public class ChatBotController extends HttpServlet {

    private ChatBotService chatBotService = new ChatBotService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if ("/message".equals(path)) {
                processMessage(request, response, out);
            } else {
                sendError(out, "Unknown endpoint");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(out, "Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();
        PrintWriter out = response.getWriter();

        if ("/health".equals(path)) {
            out.println("Chatbot API is running!");
        } else if ("/greeting".equals(path)) {
            ChatRequest req = new ChatRequest("hello");
            req.setIntent("GREETING");
            ChatResponse resp = chatBotService.processMessage(req);
            resp.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ISO_TIME));
            response.setContentType("application/json");
            out.println(gson.toJson(resp));
        } else {
            out.println("Chatbot API - Health OK");
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void processMessage(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws IOException {
        // Read request body
        StringBuilder sb = new StringBuilder();
        try (Scanner scanner = new Scanner(request.getInputStream())) {
            scanner.useDelimiter("\\A");
            if (scanner.hasNext()) {
                sb.append(scanner.next());
            }
        }

        try {
            // Parse JSON request
            ChatRequest chatRequest = gson.fromJson(sb.toString(), ChatRequest.class);

            if (chatRequest == null || chatRequest.getUserMessage() == null) {
                sendError(out, "Invalid request: userMessage is required");
                return;
            }

            // Process message
            ChatResponse chatResponse = chatBotService.processMessage(chatRequest);
            chatResponse.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ISO_TIME));

            // Send response
            out.println(gson.toJson(chatResponse));
            out.flush();

        } catch (com.google.gson.JsonSyntaxException e) {
            sendError(out, "Invalid JSON format");
        } catch (Exception e) {
            ChatResponse errorResponse = new ChatResponse();
            errorResponse.setMessage("❌ Có lỗi xảy ra. Vui lòng thử lại hoặc liên hệ nhân viên CSKH.");
            errorResponse.setResponseType("ERROR");
            errorResponse.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ISO_TIME));
            out.println(gson.toJson(errorResponse));
        }
    }

    private void sendError(PrintWriter out, String message) {
        ChatResponse errorResponse = new ChatResponse();
        errorResponse.setMessage("❌ " + message);
        errorResponse.setResponseType("ERROR");
        errorResponse.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ISO_TIME));
        out.println(gson.toJson(errorResponse));
    }
}
