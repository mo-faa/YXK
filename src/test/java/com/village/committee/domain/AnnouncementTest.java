package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

@DisplayName("Announcement实体类")
class AnnouncementTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建公告应包含所有字段")
        void 创建公告应包含所有字段() {
            Announcement a = new Announcement();
            a.setId(1L);
            a.setTitle("测试公告");
            a.setContent("公告内容");
            a.setPublisher("管理员");
            a.setPublishTime(LocalDateTime.of(2026, 5, 10, 12, 0));
            a.setIsTop(true);
            a.setStatus(1);
            assertEquals(1L, a.getId());
            assertEquals("测试公告", a.getTitle());
            assertEquals("公告内容", a.getContent());
            assertEquals("管理员", a.getPublisher());
            assertTrue(a.getIsTop());
            assertEquals(1, a.getStatus());
        }
    }

    @Nested
    @DisplayName("isPublished方法")
    class IsPublished方法 {
        @Test
        @DisplayName("status为1时isPublished返回true")
        void status为1时返回true() {
            Announcement a = new Announcement();
            a.setStatus(1);
            assertTrue(a.isPublished());
        }

        @Test
        @DisplayName("status为0时isPublished返回false")
        void status为0时返回false() {
            Announcement a = new Announcement();
            a.setStatus(0);
            assertFalse(a.isPublished());
        }

        @Test
        @DisplayName("status为null时isPublished返回false")
        void status为null时返回false() {
            Announcement a = new Announcement();
            a.setStatus(null);
            assertFalse(a.isPublished());
        }
    }

    @Nested
    @DisplayName("getStatusText方法")
    class GetStatusText方法 {
        @Test
        @DisplayName("status为1时返回已发布")
        void status为1时返回已发布() {
            Announcement a = new Announcement();
            a.setStatus(1);
            assertEquals("已发布", a.getStatusText());
        }

        @Test
        @DisplayName("status为0时返回草稿")
        void status为0时返回草稿() {
            Announcement a = new Announcement();
            a.setStatus(0);
            assertEquals("草稿", a.getStatusText());
        }

        @Test
        @DisplayName("status为null时返回草稿")
        void status为null时返回草稿() {
            Announcement a = new Announcement();
            a.setStatus(null);
            assertEquals("草稿", a.getStatusText());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("isTop为null时应正常返回null")
        void isTop为null时返回null() {
            Announcement a = new Announcement();
            a.setIsTop(null);
            assertNull(a.getIsTop());
        }

        @Test
        @DisplayName("超长标题应能正常设置")
        void 超长标题应能正常设置() {
            Announcement a = new Announcement();
            String longTitle = "测".repeat(500);
            a.setTitle(longTitle);
            assertEquals(longTitle, a.getTitle());
        }

        @Test
        @DisplayName("空内容应能正常设置")
        void 空内容应能正常设置() {
            Announcement a = new Announcement();
            a.setContent("");
            assertEquals("", a.getContent());
        }
    }
}
