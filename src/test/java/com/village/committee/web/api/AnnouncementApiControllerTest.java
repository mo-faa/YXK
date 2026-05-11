package com.village.committee.web.api;

import com.village.committee.domain.Announcement;
import com.village.committee.service.AnnouncementService;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AnnouncementApiController公告API")
class AnnouncementApiControllerTest {

    @Mock private AnnouncementService announcementService;

    @InjectMocks private AnnouncementApiController announcementApiController;

    @Nested
    @DisplayName("list - 获取所有公告")
    class ListAnnouncements {

        @Test
        @DisplayName("应返回所有公告列表")
        void 应返回所有公告() {
            when(announcementService.list()).thenReturn(List.of(new Announcement()));

            List<Announcement> result = announcementApiController.list();

            assertEquals(1, result.size());
        }
    }

    @Nested
    @DisplayName("get - 获取单个公告")
    class GetAnnouncement {

        @Test
        @DisplayName("存在的公告应返回公告对象")
        void 存在的公告应返回() {
            Announcement a = new Announcement();
            a.setId(1L);
            a.setTitle("测试公告");
            when(announcementService.get(1L)).thenReturn(a);

            Announcement result = announcementApiController.get(1L);

            assertEquals(1L, result.getId());
        }

        @Test
        @DisplayName("不存在的公告应抛出404异常")
        void 不存在的公告应抛出四零四() {
            when(announcementService.get(999L)).thenReturn(null);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.get(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("create - 创建公告")
    class CreateAnnouncement {

        @Test
        @DisplayName("创建成功应返回201状态码")
        void 创建成功应返回二零一() {
            Announcement a = new Announcement();
            a.setTitle("测试标题");
            a.setContent("测试内容");
            a.setPublisher("管理员");
            when(announcementService.create(any(Announcement.class))).thenReturn(a);

            ResponseEntity<Announcement> result = announcementApiController.create(a);

            assertEquals(HttpStatus.CREATED, result.getStatusCode());
        }

        @Test
        @DisplayName("null公告应抛出400异常")
        void null公告应抛出四零零() {
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(null));
            assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
        }

        @Test
        @DisplayName("标题为空应抛出400异常")
        void 标题为空应抛出四零零() {
            Announcement a = new Announcement();
            a.setTitle(null);
            a.setContent("内容");
            a.setPublisher("管理员");

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(a));
            assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
            assertTrue(ex.getReason().contains("title"));
        }

        @Test
        @DisplayName("内容为空应抛出400异常")
        void 内容为空应抛出四零零() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent(null);
            a.setPublisher("管理员");

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(a));
            assertTrue(ex.getReason().contains("content"));
        }

        @Test
        @DisplayName("发布人为空应抛出400异常")
        void 发布人为空应抛出四零零() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("内容");
            a.setPublisher(null);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(a));
            assertTrue(ex.getReason().contains("publisher"));
        }

        @Test
        @DisplayName("标题超过100字符应抛出400异常")
        void 标题超长应抛出四零零() {
            Announcement a = new Announcement();
            a.setTitle("a".repeat(101));
            a.setContent("内容");
            a.setPublisher("管理员");

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(a));
            assertTrue(ex.getReason().contains("title too long"));
        }

        @Test
        @DisplayName("发布人超过50字符应抛出400异常")
        void 发布人超长应抛出四零零() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("内容");
            a.setPublisher("a".repeat(51));

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.create(a));
            assertTrue(ex.getReason().contains("publisher too long"));
        }
    }

    @Nested
    @DisplayName("update - 更新公告")
    class UpdateAnnouncement {

        @Test
        @DisplayName("更新成功应返回公告对象")
        void 更新成功应返回公告() {
            Announcement a = new Announcement();
            a.setTitle("更新标题");
            a.setContent("更新内容");
            a.setPublisher("管理员");
            when(announcementService.update(1L, a)).thenReturn(true);
            when(announcementService.get(1L)).thenReturn(a);

            Announcement result = announcementApiController.update(1L, a);

            assertNotNull(result);
        }

        @Test
        @DisplayName("更新不存在的公告应抛出404异常")
        void 更新不存在应抛出四零四() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("内容");
            a.setPublisher("管理员");
            when(announcementService.update(999L, a)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.update(999L, a));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("delete - 删除公告")
    class DeleteAnnouncement {

        @Test
        @DisplayName("删除成功应返回204状态码")
        void 删除成功应返回二零四() {
            when(announcementService.delete(1L)).thenReturn(true);

            ResponseEntity<Void> result = announcementApiController.delete(1L);

            assertEquals(HttpStatus.NO_CONTENT, result.getStatusCode());
        }

        @Test
        @DisplayName("删除不存在的公告应抛出404异常")
        void 删除不存在应抛出四零四() {
            when(announcementService.delete(999L)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementApiController.delete(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }
}
