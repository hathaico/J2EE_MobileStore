package com.mobilestore.controller;

import com.mobilestore.service.ChatBotService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Admin Chatbot Training Controller
 * Provides a training sync page for chatbot dataset export and cache refresh.
 */
@WebServlet("/admin/chatbot-training")
public class AdminChatbotTrainingController extends HttpServlet {
    private ChatBotService chatBotService;

    @Override
    public void init() throws ServletException {
        chatBotService = new ChatBotService();
        chatBotService.setServletContext(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "chatbot-training");
        request.setAttribute("pageTitle", "Chatbot Training");
        request.setAttribute("adminPageDesc", "Đồng bộ và xem trước dataset training của chatbot từ dữ liệu live.");
        request.setAttribute("trainingDatasetJson", chatBotService.exportTrainingDatasetSnapshotJson());
        request.getRequestDispatcher("/WEB-INF/views/admin/chatbot-training.jsp")
               .forward(request, response);
    }
}
