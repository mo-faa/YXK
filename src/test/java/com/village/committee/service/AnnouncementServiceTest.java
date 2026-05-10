package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.domain.Announcement;
import com.village.committee.mapper.AnnouncementMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.time.LocalDateTime;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AnnouncementService")
class AnnouncementServiceTest {

    @Mock
    private AnnouncementMapper announcementMapper;

    @InjectMocks
    private AnnouncementService announcementService;

    @Nested
    @DisplayName("validate")
    class Validate {

        @Test
        @DisplayName("null公告应抛异常")
        void nullAnnouncement() {
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(null));
            assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
            assertTrue(ex.getReason().contains("不能为空"));
        }

        @Test
        @DisplayName("标题为空应抛异常")
        void blankTitle() {
            Announcement a = new Announcement();
            a.setTitle("");
            a.setContent("内容");
            a.setPublisher("发布人");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("标题不能为空"));
        }

        @Test
        @DisplayName("内容为空应抛异常")
        void blankContent() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("");
            a.setPublisher("发布人");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("内容不能为空"));
        }

        @Test
        @DisplayName("发布人为空应抛异常")
        void blankPublisher() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("内容");
            a.setPublisher("");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("发布人不能为空"));
        }

        @Test
        @DisplayName("标题超过100字符应抛异常")
        void titleTooLong() {
            Announcement a = new Announcement();
            a.setTitle("a".repeat(101));
            a.setContent("内容");
            a.setPublisher("发布人");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("标题不能超过100"));
        }

        @Test
        @DisplayName("内容超过10000字符应抛异常")
        void contentTooLong() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("a".repeat(10001));
            a.setPublisher("发布人");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("内容不能超过10000"));
        }

        @Test
        @DisplayName("标题包含HTML标签应抛异常")
        void titleWithHtml() {
            Announcement a = new Announcement();
            a.setTitle("<script>alert(1)</script>");
            a.setContent("内容");
            a.setPublisher("发布人");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> announcementService.validate(a));
            assertTrue(ex.getReason().contains("HTML"));
        }

        @Test
        @DisplayName("正常公告应不抛异常")
        void validAnnouncement() {
            Announcement a = new Announcement();
            a.setTitle("正常标题");
            a.setContent("正常内容");
            a.setPublisher("管理员");
            assertDoesNotThrow(() -> announcementService.validate(a));
        }
    }

    @Nested
    @DisplayName("validateAndGetError")
    class ValidateAndGetError {

        @Test
        @DisplayName("null公告应返回错误消息")
        void nullAnnouncement() {
            assertEquals("公告信息不能为空", announcementService.validateAndGetError(null));
        }

        @Test
        @DisplayName("标题为空应返回错误消息")
        void blankTitle() {
            Announcement a = new Announcement();
            a.setTitle("");
            a.setContent("内容");
            a.setPublisher("发布人");
            assertEquals("标题不能为空", announcementService.validateAndGetError(a));
        }

        @Test
        @DisplayName("正常公告应返回null")
        void validAnnouncement() {
            Announcement a = new Announcement();
            a.setTitle("标题");
            a.setContent("内容");
            a.setPublisher("发布人");
            assertNull(announcementService.validateAndGetError(a));
        }
    }

    @Nested
    @DisplayName("create")
    class Create {

        @Test
        @DisplayName("创建公告应调用mapper.insert")
        void createSuccess() {
            Announcement a = new Announcement();
            a.setTitle("测试标题");
            a.setContent("测试内容");
            a.setPublisher("管理员");

            when(announcementMapper.insert(any())).thenReturn(1);

            Announcement result = announcementService.create(a);
            assertNotNull(result);
            verify(announcementMapper).insert(a);
        }

        @Test
        @DisplayName("创建时publishTime为null应自动设置")
        void autoPublishTime() {
            Announcement a = new Announcement();
            a.setTitle("测试标题");
            a.setContent("测试内容");
            a.setPublisher("管理员");
            a.setPublishTime(null);

            when(announcementMapper.insert(any())).thenReturn(1);

            announcementService.create(a);
            assertNotNull(a.getPublishTime());
        }

        @Test
        @DisplayName("创建时isTop为null应设为false")
        void autoIsTop() {
            Announcement a = new Announcement();
            a.setTitle("测试标题");
            a.setContent("测试内容");
            a.setPublisher("管理员");
            a.setIsTop(null);

            when(announcementMapper.insert(any())).thenReturn(1);

            announcementService.create(a);
            assertFalse(a.getIsTop());
        }

        @Test
        @DisplayName("创建时status为null应设为1")
        void autoStatus() {
            Announcement a = new Announcement();
            a.setTitle("测试标题");
            a.setContent("测试内容");
            a.setPublisher("管理员");
            a.setStatus(null);

            when(announcementMapper.insert(any())).thenReturn(1);

            announcementService.create(a);
            assertEquals(1, a.getStatus());
        }
    }

    @Nested
    @DisplayName("update")
    class Update {

        @Test
        @DisplayName("更新成功应返回true")
        void updateSuccess() {
            Announcement a = new Announcement();
            a.setTitle("更新标题");
            a.setContent("更新内容");
            a.setPublisher("管理员");

            when(announcementMapper.update(any())).thenReturn(1);

            assertTrue(announcementService.update(1L, a));
            assertEquals(1L, a.getId());
        }

        @Test
        @DisplayName("更新失败应返回false")
        void updateFail() {
            Announcement a = new Announcement();
            a.setTitle("更新标题");
            a.setContent("更新内容");
            a.setPublisher("管理员");

            when(announcementMapper.update(any())).thenReturn(0);

            assertFalse(announcementService.update(999L, a));
        }
    }

    @Nested
    @DisplayName("delete")
    class Delete {

        @Test
        @DisplayName("删除成功应返回true")
        void deleteSuccess() {
            when(announcementMapper.deleteById(1L)).thenReturn(1);
            assertTrue(announcementService.delete(1L));
        }

        @Test
        @DisplayName("删除不存在应返回false")
        void deleteNotFound() {
            when(announcementMapper.deleteById(999L)).thenReturn(0);
            assertFalse(announcementService.delete(999L));
        }
    }

    @Nested
    @DisplayName("list和countAll")
    class ListAndCount {

        @Test
        @DisplayName("list应返回所有公告")
        void listAll() {
            when(announcementMapper.findAll()).thenReturn(List.of(new Announcement()));
            assertEquals(1, announcementService.list().size());
        }

        @Test
        @DisplayName("countAll应返回总数")
        void countAll() {
            when(announcementMapper.count()).thenReturn(5L);
            assertEquals(5L, announcementService.countAll());
        }
    }

    @Nested
    @DisplayName("latest")
    class Latest {

        @Test
        @DisplayName("limit为0应使用默认5")
        void zeroLimit() {
            when(announcementMapper.findLatest(5)).thenReturn(List.of());
            announcementService.latest(0);
            verify(announcementMapper).findLatest(5);
        }

        @Test
        @DisplayName("limit超过100应限制为100")
        void overMaxLimit() {
            when(announcementMapper.findLatest(100)).thenReturn(List.of());
            announcementService.latest(200);
            verify(announcementMapper).findLatest(100);
        }
    }

    @Nested
    @DisplayName("page")
    class Page {

        @Test
        @DisplayName("分页查询应正确返回PageResult")
        void pageQuery() {
            when(announcementMapper.countByQuery(null, null, null)).thenReturn(1L);
            when(announcementMapper.findPage(null, null, null, 0, 10)).thenReturn(List.of(new Announcement()));

            PageResult<Announcement> result = announcementService.page(null, null, null, 1, 10);
            assertEquals(1, result.getItems().size());
            assertEquals(1, result.getPage());
            assertEquals(10, result.getSize());
            assertEquals(1L, result.getTotal());
        }

        @Test
        @DisplayName("超出页码应返回空列表")
        void outOfRange() {
            when(announcementMapper.countByQuery(null, null, null)).thenReturn(5L);

            PageResult<Announcement> result = announcementService.page(null, null, null, 100, 10);
            assertEquals(0, result.getItems().size());
        }
    }
}
