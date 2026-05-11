package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Notification实体类")
class NotificationTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建通知应包含所有字段")
        void 创建通知应包含所有字段() {
            Notification n = new Notification();
            n.setId(1L);
            n.setUserId(1L);
            n.setTitle("新公告发布");
            n.setContent("系统发布了新公告");
            n.setType("announcement");
            n.setIsRead(false);
            n.setRelatedId(5L);
            n.setRelatedType("announcement");
            assertEquals(1L, n.getId());
            assertEquals(1L, n.getUserId());
            assertEquals("新公告发布", n.getTitle());
            assertEquals("系统发布了新公告", n.getContent());
            assertEquals("announcement", n.getType());
            assertFalse(n.getIsRead());
            assertEquals(5L, n.getRelatedId());
            assertEquals("announcement", n.getRelatedType());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("isRead为null时应正常返回null")
        void isRead为null时返回null() {
            Notification n = new Notification();
            n.setIsRead(null);
            assertNull(n.getIsRead());
        }

        @Test
        @DisplayName("relatedId为null时应正常返回null")
        void relatedId为null时返回null() {
            Notification n = new Notification();
            n.setRelatedId(null);
            assertNull(n.getRelatedId());
        }
    }
}
