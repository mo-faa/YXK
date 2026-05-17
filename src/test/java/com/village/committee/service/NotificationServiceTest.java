package com.village.committee.service;

import com.village.committee.domain.Notification;
import com.village.committee.mapper.NotificationMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.*;
import org.mockito.*;
import org.mockito.junit.jupiter.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("NotificationService通知服务")
class NotificationServiceTest {

    @Mock private NotificationMapper notificationMapper;

    @InjectMocks private NotificationService notificationService;

    @Nested
    @DisplayName("getUnreadCount - 未读消息数")
    class GetUnreadCount {

        @Test
        @DisplayName("应返回正确的未读数")
        void 应返回正确的未读数() {
            when(notificationMapper.countUnread(1L)).thenReturn(5);
            assertEquals(5, notificationService.getUnreadCount(1L));
        }

        @Test
        @DisplayName("无未读消息应返回0")
        void 无未读消息应返回0() {
            when(notificationMapper.countUnread(1L)).thenReturn(0);
            assertEquals(0, notificationService.getUnreadCount(1L));
        }
    }

    @Nested
    @DisplayName("createNotification - 创建通知")
    class CreateNotification {

        @Test
        @DisplayName("创建通知应正确设置所有字段")
        void 创建通知应正确设置所有字段() {
            when(notificationMapper.insert(any(Notification.class))).thenReturn(1);

            Notification result = notificationService.createNotification(
                    1L, "测试通知", "通知内容", "system", 5L, "announcement");

            assertNotNull(result);
            assertEquals(1L, result.getUserId());
            assertEquals("测试通知", result.getTitle());
            assertEquals("通知内容", result.getContent());
            assertEquals("system", result.getType());
            assertEquals(5L, result.getRelatedId());
            assertEquals("announcement", result.getRelatedType());
            assertFalse(result.getIsRead());
            verify(notificationMapper).insert(any(Notification.class));
        }

        @Test
        @DisplayName("type为null时应默认为system")
        void type为null时应默认为system() {
            when(notificationMapper.insert(any(Notification.class))).thenReturn(1);

            Notification result = notificationService.createNotification(
                    1L, "标题", "内容", null, null, null);

            assertEquals("system", result.getType());
        }
    }

    @Nested
    @DisplayName("markAsRead - 标记已读")
    class MarkAsRead {

        @Test
        @DisplayName("标记已读应调用mapper")
        void 标记已读应调用mapper() {
            notificationService.markAsRead(1L);
            verify(notificationMapper).markAsRead(1L);
        }
    }

    @Nested
    @DisplayName("markAllAsRead - 全部标记已读")
    class MarkAllAsRead {

        @Test
        @DisplayName("全部标记已读应调用mapper")
        void 全部标记已读应调用mapper() {
            notificationService.markAllAsRead(1L);
            verify(notificationMapper).markAllAsRead(1L);
        }
    }

    @Nested
    @DisplayName("deleteNotification - 删除通知")
    class DeleteNotification {

        @Test
        @DisplayName("删除通知应调用mapper")
        void 删除通知应调用mapper() {
            notificationService.deleteNotification(1L);
            verify(notificationMapper).deleteById(1L);
        }
    }

    @Nested
    @DisplayName("sendAnnouncementNotification - 发送公告通知")
    class SendAnnouncementNotification {

        @Test
        @DisplayName("应创建类型为announcement的通知")
        void 应创建公告类型通知() {
            when(notificationMapper.insert(any(Notification.class))).thenReturn(1);

            notificationService.sendAnnouncementNotification(1L, 10L, "重要公告");

            ArgumentCaptor<Notification> captor = ArgumentCaptor.forClass(Notification.class);
            verify(notificationMapper).insert(captor.capture());

            Notification n = captor.getValue();
            assertEquals("announcement", n.getType());
            assertEquals(10L, n.getRelatedId());
            assertTrue(n.getTitle().contains("公告"));
            assertTrue(n.getContent().contains("重要公告"));
        }
    }
}
