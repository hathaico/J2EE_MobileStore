package com.mobilestore.controller;

import com.mobilestore.model.User;
import com.mobilestore.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.net.URLEncoder;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.OutputStream;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                // Không setAttribute 'user' khi thêm mới
                request.getRequestDispatcher("/WEB-INF/views/admin/user/form.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                User editUser = userService.getUserById(editId);
                request.setAttribute("user", editUser);
                request.getRequestDispatcher("/WEB-INF/views/admin/user/form.jsp").forward(request, response);
                break;
            case "exportExcel":
                exportUserListToExcel(request, response);
                break;
            default:
                // Lấy filter từ request
                String q = request.getParameter("q");
                String role = request.getParameter("role");
                String active = request.getParameter("active");
                List<User> users = userService.getUsersWithFilter(q, role, active);
                // Trả lại filter cho view để giữ trạng thái
                request.setAttribute("qFilter", q);
                request.setAttribute("roleFilter", role);
                request.setAttribute("activeFilter", active);
                request.setAttribute("users", users);
                request.getRequestDispatcher("/WEB-INF/views/admin/user/list.jsp").forward(request, response);
        }
    }

    private void exportUserListToExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String q = request.getParameter("q");
        String role = request.getParameter("role");
        String active = request.getParameter("active");
        List<User> users = userService.getAllUsers();
        // Filter users in-memory (for now)
        if (q != null && !q.trim().isEmpty()) {
            String qLower = q.trim().toLowerCase();
            users.removeIf(u -> (u.getFullName() == null || !u.getFullName().toLowerCase().contains(qLower)) && (u.getEmail() == null || !u.getEmail().toLowerCase().contains(qLower)) && (u.getUsername() == null || !u.getUsername().toLowerCase().contains(qLower)));
        }
        if (role != null && !role.isEmpty()) {
            users.removeIf(u -> u.getRole() == null || !u.getRole().equals(role));
        }
        if (active != null && !active.isEmpty()) {
            boolean isActive = Boolean.parseBoolean(active);
            users.removeIf(u -> u.getIsActive() == null || u.getIsActive() != isActive);
        }
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Users");
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID");
        header.createCell(1).setCellValue("Username");
        header.createCell(2).setCellValue("Full Name");
        header.createCell(3).setCellValue("Email");
        header.createCell(4).setCellValue("Role");
        header.createCell(5).setCellValue("Active");
        header.createCell(6).setCellValue("Created At");
        int rowIdx = 1;
        for (User user : users) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(user.getUserId() != null ? user.getUserId() : 0);
            row.createCell(1).setCellValue(user.getUsername() != null ? user.getUsername() : "");
            row.createCell(2).setCellValue(user.getFullName() != null ? user.getFullName() : "");
            row.createCell(3).setCellValue(user.getEmail() != null ? user.getEmail() : "");
            row.createCell(4).setCellValue(user.getRole() != null ? user.getRole() : "");
            row.createCell(5).setCellValue(user.getIsActive() != null && user.getIsActive() ? "Yes" : "No");
            row.createCell(6).setCellValue(user.getCreatedAt() != null ? user.getCreatedAt().toString() : "");
        }
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=users.xlsx");
        OutputStream out = response.getOutputStream();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";
        if (action.equals("add")) {
            User user = new User();
            user.setUserId(null); // Đảm bảo luôn null khi thêm mới
            user.setUsername(request.getParameter("inputUsernameX"));
            user.setFullName(request.getParameter("new_fullName"));
            user.setEmail(request.getParameter("new_email"));
            String role = request.getParameter("role");
            user.setRole(role != null ? role : "STAFF");
            user.setIsActive(Boolean.parseBoolean(request.getParameter("active")));
            user.setPassword(request.getParameter("new_password"));
            try {
                if (userService.getUserByUsername(user.getUsername()) != null) {
                    throw new IllegalArgumentException("Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác!");
                }
                if (userService.getUserByEmail(user.getEmail()) != null) {
                    throw new IllegalArgumentException("Email đã tồn tại. Vui lòng chọn email khác!");
                }
                int newUserId = userService.createUser(user, request.getParameter("new_password"));
                if (newUserId > 0) {
                    String msg = URLEncoder.encode("Thêm người dùng thành công", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=" + msg);
                    return;
                } else {
                    String msg = URLEncoder.encode("Không thể tạo người dùng mới. Vui lòng kiểm tra lại dữ liệu!", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=" + msg);
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("[DEBUG][USER_ADD] " + e.getMessage());
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/admin/user/form.jsp").forward(request, response);
            }
        } else if (action.equals("edit")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userId == 1) {
                String msg = URLEncoder.encode("Không thể sửa user admin!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=" + msg);
                return;
            }
            User user = userService.getUserById(userId);
            user.setFullName(request.getParameter("new_fullName"));
            user.setEmail(request.getParameter("new_email"));
            user.setRole(request.getParameter("role"));
            user.setIsActive(Boolean.parseBoolean(request.getParameter("active")));
            try {
                userService.updateUser(user);
                String msg = URLEncoder.encode("Cập nhật người dùng thành công", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/users?success=" + msg);
            } catch (Exception e) {
                request.setAttribute("user", user);
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/admin/user/form.jsp").forward(request, response);
            }
        } else if (action.equals("delete")) {
            int userId = Integer.parseInt(request.getParameter("id"));
            if (userId == 1) {
                String msg = URLEncoder.encode("Không thể xoá user admin!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=" + msg);
                return;
            }
            userService.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=Xoá+người+dùng+thành+công");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
