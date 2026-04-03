package com.mobilestore.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mobilestore.model.User;
import com.mobilestore.service.UserService;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;

public class UserApiServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
            new com.google.gson.JsonPrimitive(src.toString())
        )
        .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                List<User> users = userService.getAllUsers();
                writeSuccess(resp, users);
            } else {
                try {
                    int id = Integer.parseInt(pathInfo.substring(1));
                    User user = userService.getUserById(id);
                    if (user != null) {
                        writeSuccess(resp, user);
                    } else {
                        writeError(resp, "User not found");
                    }
                } catch (NumberFormatException e) {
                    writeError(resp, "Invalid user ID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            User user = gson.fromJson(req.getReader(), User.class);
            int created = userService.createUser(user, user.getPassword());
            if (created > 0) {
                user.setUserId(created);
                writeSuccess(resp, user);
            } else {
                writeError(resp, "Failed to create user");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                writeError(resp, "User ID required");
                return;
            }
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                User user = gson.fromJson(req.getReader(), User.class);
                user.setUserId(id);
                boolean updated = userService.updateUser(user);
                if (updated) {
                    writeSuccess(resp, user);
                } else {
                    writeError(resp, "User not found or update failed");
                }
            } catch (NumberFormatException e) {
                writeError(resp, "Invalid user ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                writeError(resp, "User ID required");
                return;
            }
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                boolean deleted = userService.deleteUser(id);
                if (deleted) {
                    writeSuccess(resp, "User deleted");
                } else {
                    writeError(resp, "User not found or delete failed");
                }
            } catch (NumberFormatException e) {
                writeError(resp, "Invalid user ID");
            }
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
