package com.mobilestore.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mobilestore.model.User;
import com.mobilestore.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

public class AuthApiServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
            new com.google.gson.JsonPrimitive(src.toString())
        )
        .create();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        String path = req.getPathInfo();
        System.out.println("DEBUG pathInfo: " + path);
        if (path != null) {
            path = path.trim().toLowerCase().replaceAll("^/+", "").replaceAll("/+$", "");
        }
        try {
            if (path == null || path.isEmpty()) {
                writeError(resp, "Invalid endpoint");
                return;
            }
            if ("login".equals(path)) {
                handleLogin(req, resp);
            } else if ("register".equals(path)) {
                handleRegister(req, resp);
            } else if ("logout".equals(path)) {
                handleLogout(req, resp);
            } else {
                writeError(resp, "Unknown endpoint: " + path);
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            User loginRequest = gson.fromJson(req.getReader(), User.class);
            User user = userService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                writeSuccess(resp, user);
            } else {
                writeError(resp, "Invalid email or password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            User user = gson.fromJson(req.getReader(), User.class);
            if (user == null) {
                writeError(resp, "Invalid or missing JSON body");
                return;
            }
            // Nếu role null hoặc không hợp lệ, mặc định là USER
            if (user.getRole() == null || 
                !(user.getRole().equalsIgnoreCase("ADMIN") || user.getRole().equalsIgnoreCase("STAFF") || user.getRole().equalsIgnoreCase("USER"))) {
                user.setRole("USER");
            }
            int created = userService.createUser(user, user.getPassword());
            if (created > 0) {
                user.setUserId(created);
                writeSuccess(resp, user);
            } else {
                writeError(resp, "Failed to register user");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            writeSuccess(resp, "Logged out");
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    private void writeSuccess(HttpServletResponse resp, Object data) throws IOException {
        resp.getWriter().write(gson.toJson(new ApiResponse("success", data)));
    }

    private void writeError(HttpServletResponse resp, String message) throws IOException {
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.getWriter().write(gson.toJson(new ApiResponse("error", message)));
    }

    static class ApiResponse {
        String status;
        Object data;
        ApiResponse(String status, Object data) {
            this.status = status;
            this.data = data;
        }
    }
}
