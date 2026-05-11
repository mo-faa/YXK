package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

@DisplayName("User实体类")
class UserTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {

        @Test
        @DisplayName("创建User应包含所有字段")
        void 创建User应包含所有字段() {
            User user = new User();
            user.setId(1L);
            user.setUsername("admin");
            user.setPasswordHash("$2a$10$hash");
            user.setNickname("管理员");
            user.setRealName("张三");
            user.setPhone("13800138000");
            user.setEmail("admin@example.com");
            user.setAvatar("/avatar.png");
            user.setEnabled(true);
            user.setLoginCount(5);
            user.setLastLoginAt(LocalDateTime.of(2026, 1, 1, 12, 0));
            user.setCreatedAt(LocalDateTime.of(2025, 1, 1, 0, 0));
            user.setUpdatedAt(LocalDateTime.of(2026, 5, 1, 0, 0));

            assertEquals(1L, user.getId());
            assertEquals("admin", user.getUsername());
            assertEquals("$2a$10$hash", user.getPasswordHash());
            assertEquals("管理员", user.getNickname());
            assertEquals("张三", user.getRealName());
            assertEquals("13800138000", user.getPhone());
            assertEquals("admin@example.com", user.getEmail());
            assertEquals("/avatar.png", user.getAvatar());
            assertTrue(user.isEnabled());
            assertEquals(5, user.getLoginCount());
            assertNotNull(user.getLastLoginAt());
            assertNotNull(user.getCreatedAt());
            assertNotNull(user.getUpdatedAt());
        }

        @Test
        @DisplayName("默认构造器应创建空User")
        void 默认构造器应创建空User() {
            User user = new User();
            assertNull(user.getId());
            assertNull(user.getUsername());
            assertTrue(user.isEnabled());
            assertEquals(0, user.getLoginCount());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {

        @Test
        @DisplayName("enabled为null时isEnabled应返回true")
        void enabled为null时isEnabled应返回true() {
            User user = new User();
            user.setEnabled(null);
            assertTrue(user.isEnabled());
        }

        @Test
        @DisplayName("enabled为false时isEnabled应返回false")
        void enabled为false时isEnabled应返回false() {
            User user = new User();
            user.setEnabled(false);
            assertFalse(user.isEnabled());
        }

        @Test
        @DisplayName("loginCount为null时getLoginCount应返回0")
        void loginCount为null时getLoginCount应返回0() {
            User user = new User();
            user.setLoginCount(null);
            assertEquals(0, user.getLoginCount());
        }

        @Test
        @DisplayName("loginCount为0时getLoginCount应返回0")
        void loginCount为0时getLoginCount应返回0() {
            User user = new User();
            user.setLoginCount(0);
            assertEquals(0, user.getLoginCount());
        }

        @Test
        @DisplayName("loginCount为Integer.MAX_VALUE时getLoginCount应返回MAX_VALUE")
        void loginCount为MAX时getLoginCount应返回MAX() {
            User user = new User();
            user.setLoginCount(Integer.MAX_VALUE);
            assertEquals(Integer.MAX_VALUE, user.getLoginCount());
        }
    }

    @Nested
    @DisplayName("状态文本方法")
    class 状态文本方法 {

        @Test
        @DisplayName("enabled为true时getStatusText返回启用")
        void enabled为true时返回启用() {
            User user = new User();
            user.setEnabled(true);
            assertEquals("启用", user.getStatusText());
        }

        @Test
        @DisplayName("enabled为false时getStatusText返回禁用")
        void enabled为false时返回禁用() {
            User user = new User();
            user.setEnabled(false);
            assertEquals("禁用", user.getStatusText());
        }

        @Test
        @DisplayName("enabled为null时getStatusText返回禁用")
        void enabled为null时返回禁用() {
            User user = new User();
            user.setEnabled(null);
            assertEquals("禁用", user.getStatusText());
        }

        @Test
        @DisplayName("enabled为true时getEnabledClass返回bg-success")
        void enabled为true时返回BgSuccess() {
            User user = new User();
            user.setEnabled(true);
            assertEquals("bg-success", user.getEnabledClass());
        }

        @Test
        @DisplayName("enabled为false时getEnabledClass返回bg-secondary")
        void enabled为false时返回BgSecondary() {
            User user = new User();
            user.setEnabled(false);
            assertEquals("bg-secondary", user.getEnabledClass());
        }
    }

    @Nested
    @DisplayName("日期格式化方法")
    class 日期格式化方法 {

        @Test
        @DisplayName("lastLoginAt非空时格式化为yyyy-MM-dd HH:mm")
        void lastLoginAt非空时格式化正确() {
            User user = new User();
            user.setLastLoginAt(LocalDateTime.of(2026, 5, 10, 14, 30));
            assertEquals("2026-05-10 14:30", user.getLastLoginAtFormatted());
        }

        @Test
        @DisplayName("lastLoginAt为null时返回空字符串")
        void lastLoginAt为null时返回空字符串() {
            User user = new User();
            user.setLastLoginAt(null);
            assertEquals("", user.getLastLoginAtFormatted());
        }

        @Test
        @DisplayName("createdAt非空时格式化为yyyy-MM-dd HH:mm:ss")
        void createdAt非空时格式化正确() {
            User user = new User();
            user.setCreatedAt(LocalDateTime.of(2026, 5, 10, 14, 30, 45));
            assertEquals("2026-05-10 14:30:45", user.getCreatedAtFormatted());
        }

        @Test
        @DisplayName("createdAt为null时返回空字符串")
        void createdAt为null时返回空字符串() {
            User user = new User();
            user.setCreatedAt(null);
            assertEquals("", user.getCreatedAtFormatted());
        }
    }

    @Nested
    @DisplayName("异常输入")
    class 异常输入 {

        @Test
        @DisplayName("超长用户名应能正常设置")
        void 超长用户名应能正常设置() {
            User user = new User();
            String longName = "a".repeat(1000);
            user.setUsername(longName);
            assertEquals(longName, user.getUsername());
        }

        @Test
        @DisplayName("空字符串字段应能正常设置")
        void 空字符串字段应能正常设置() {
            User user = new User();
            user.setUsername("");
            user.setNickname("");
            user.setRealName("");
            assertEquals("", user.getUsername());
            assertEquals("", user.getNickname());
            assertEquals("", user.getRealName());
        }
    }
}
