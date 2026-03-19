package com.mobilestore;

import com.mobilestore.model.User;
import com.mobilestore.service.UserService;
import com.mobilestore.dao.UserDAO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class UserServiceTest {
        @Test
        public void testRegisterWithShortUsername() {
            xoaUserTest("ab", "shortname@example.com");
            User user = new User();
            user.setUsername("ab"); // quá ngắn
            user.setEmail("shortname@example.com");
            user.setPassword("123456");
            user.setFullName("Tên Ngắn");
            user.setRole("USER");
            boolean result = userService.register(user);
            Assertions.assertFalse(result, "Đăng ký với username quá ngắn phải trả về false");
        }

        @Test
        public void testRegisterWithLongUsername() {
            String longName = "a".repeat(60);
            xoaUserTest(longName, "longname@example.com");
            User user = new User();
            user.setUsername(longName); // quá dài
            user.setEmail("longname@example.com");
            user.setPassword("123456");
            user.setFullName("Tên Dài");
            user.setRole("USER");
            boolean result = userService.register(user);
            Assertions.assertFalse(result, "Đăng ký với username quá dài phải trả về false");
        }

        @Test
        public void testRegisterWithPasswordSameAsUsername() {
            xoaUserTest("samepass", "samepass@example.com");
            User user = new User();
            user.setUsername("samepass");
            user.setEmail("samepass@example.com");
            user.setPassword("samepass"); // mật khẩu trùng username
            user.setFullName("Trùng Mật Khẩu");
            user.setRole("USER");
            boolean result = userService.register(user);
            // Nếu muốn cứng hơn, có thể sửa logic để không cho phép
            // Ở đây chỉ kiểm tra hiện tại có cho phép không
            Assertions.assertTrue(result, "Hệ thống hiện tại cho phép mật khẩu trùng username (nên cân nhắc bổ sung kiểm tra)");
        }

        @Test
        public void testChangePasswordToSameAsOld() {
            xoaUserTest("sameold", "sameold@example.com");
            User user = new User();
            user.setUsername("sameold");
            user.setEmail("sameold@example.com");
            user.setPassword("oldpass");
            user.setFullName("Trùng Mật Khẩu Cũ");
            user.setRole("USER");
            userService.register(user);
            User dbUser = userService.getUserByUsername("sameold");
            // Đổi mật khẩu thành đúng mật khẩu cũ
            boolean changed = userService.updatePassword(dbUser.getUserId(), "oldpass", "oldpass");
            // Nếu muốn cứng hơn, có thể sửa logic để không cho phép
            Assertions.assertTrue(changed, "Hệ thống hiện tại cho phép đổi mật khẩu trùng mật khẩu cũ (nên cân nhắc bổ sung kiểm tra)");
        }
    private UserService userService;
    // Hàm tiện ích xóa user test theo username/email (xóa thật sự trong DB)
    private void xoaUserTest(String username, String email) {
        UserDAO userDAO = new UserDAO();
        userDAO.deleteUserByUsername(username);
        userDAO.deleteUserByEmail(email);
    }

    @BeforeEach
    public void setUp() {
        userService = new UserService();
    }

    @Test
    public void testRegisterWithInvalidEmail() {
            xoaUserTest("invalidemail", "invalid-email");
        User user = new User();
        user.setUsername("invalidemail");
        user.setFullName("Người Dùng Lỗi Email");
        user.setEmail("invalid-email");
        user.setPassword("123456");
        user.setRole("USER");
        boolean result = userService.register(user);
        Assertions.assertFalse(result, "Đăng ký với email không hợp lệ phải trả về false");
    }

    @Test
    public void testRegisterWithExistingUsernameOrEmail() {
            xoaUserTest("testuser", "testuser@example.com");
        User user1 = new User();
        user1.setUsername("testuser");
        user1.setEmail("testuser@example.com");
        user1.setPassword("123456");
        user1.setFullName("Test User");
        user1.setRole("USER");
        boolean first = userService.register(user1);
        Assertions.assertTrue(first);

        User user2 = new User();
        user2.setUsername("testuser"); // trùng username
        user2.setEmail("testuser@example.com"); // trùng email
        user2.setPassword("abcdef");
        user2.setFullName("Test User 2");
        user2.setRole("USER");
        boolean second = userService.register(user2);
        Assertions.assertFalse(second);
    }

    @Test
    public void testRegisterWithShortPassword() {
            xoaUserTest("shortpass", "shortpass@example.com");
        User user = new User();
        user.setUsername("shortpass");
        user.setEmail("shortpass@example.com");
        user.setPassword("123"); // quá ngắn
        user.setFullName("Short Pass");
        user.setRole("USER");
        boolean result = userService.register(user);
        Assertions.assertFalse(result);
    }

    @Test
    public void testRegisterSuccess() {
            xoaUserTest("validuser", "validuser@example.com");
        User user = new User();
        user.setUsername("validuser");
        user.setEmail("validuser@example.com");
        user.setPassword("validpass");
        user.setFullName("Valid User");
        user.setRole("USER");
        boolean result = userService.register(user);
        Assertions.assertTrue(result);
    }

    @Test
    public void testAuthenticateSuccessAndFail() {
            xoaUserTest("authuser", "authuser@example.com");
        User user = new User();
        user.setUsername("authuser");
        user.setEmail("authuser@example.com");
        user.setPassword("authpass");
        user.setFullName("Auth User");
        user.setRole("USER");
        userService.register(user);
        // Đăng nhập đúng
        User found = userService.authenticate("authuser@example.com", "authpass");
        Assertions.assertNotNull(found);
        // Đăng nhập sai
        User notFound = userService.authenticate("authuser@example.com", "wrongpass");
        Assertions.assertNull(notFound);
    }

    @Test
    public void testGetUserByEmailOrUsernameNotFound() {
        User byEmail = userService.getUserByEmail("notfound@example.com");
        User byUsername = userService.getUserByUsername("notfounduser");
        Assertions.assertNull(byEmail);
        Assertions.assertNull(byUsername);
    }

    @Test
    public void testUpdatePassword() {
            xoaUserTest("changepass", "changepass@example.com");
        User user = new User();
        user.setUsername("changepass");
        user.setEmail("changepass@example.com");
        user.setPassword("oldpass");
        user.setFullName("Change Pass");
        user.setRole("USER");
        userService.register(user);
        User dbUser = userService.getUserByUsername("changepass");
        // Đổi mật khẩu đúng
        boolean changed = userService.updatePassword(dbUser.getUserId(), "oldpass", "newpass123");
        Assertions.assertTrue(changed);
        // Đổi mật khẩu sai
        Assertions.assertThrows(IllegalArgumentException.class, () -> {
            userService.updatePassword(dbUser.getUserId(), "wrongold", "anotherpass");
        });
    }
}
