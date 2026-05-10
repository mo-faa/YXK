package com.village.committee.domain;

import org.junit.jupiter.api.*;
import java.time.LocalDateTime;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Announcement")
class AnnouncementTest {

    @Test
    @DisplayName("isPublished状态1应返回true")
    void publishedStatus() {
        Announcement a = new Announcement();
        a.setStatus(1);
        assertTrue(a.isPublished());
    }

    @Test
    @DisplayName("isPublished状态0应返回false")
    void draftStatus() {
        Announcement a = new Announcement();
        a.setStatus(0);
        assertFalse(a.isPublished());
    }

    @Test
    @DisplayName("isPublished状态null应返回false")
    void nullStatus() {
        Announcement a = new Announcement();
        a.setStatus(null);
        assertFalse(a.isPublished());
    }

    @Test
    @DisplayName("getStatusText草稿")
    void draftText() {
        Announcement a = new Announcement();
        a.setStatus(0);
        assertEquals("草稿", a.getStatusText());
    }

    @Test
    @DisplayName("getStatusText已发布")
    void publishedText() {
        Announcement a = new Announcement();
        a.setStatus(1);
        assertEquals("已发布", a.getStatusText());
    }

    @Test
    @DisplayName("getStatusText null状态应返回草稿")
    void nullStatusText() {
        Announcement a = new Announcement();
        a.setStatus(null);
        assertEquals("草稿", a.getStatusText());
    }

    @Test
    @DisplayName("getter和setter应正确工作")
    void gettersAndSetters() {
        Announcement a = new Announcement();
        a.setId(1L);
        a.setTitle("测试标题");
        a.setContent("测试内容");
        a.setPublisher("管理员");
        a.setPublishTime(LocalDateTime.now());
        a.setIsTop(true);
        a.setStatus(1);

        assertEquals(1L, a.getId());
        assertEquals("测试标题", a.getTitle());
        assertEquals("测试内容", a.getContent());
        assertEquals("管理员", a.getPublisher());
        assertNotNull(a.getPublishTime());
        assertTrue(a.getIsTop());
        assertEquals(1, a.getStatus());
    }
}

@DisplayName("Resident")
class ResidentTest {

    @Test
    @DisplayName("getter和setter应正确工作")
    void gettersAndSetters() {
        Resident r = new Resident();
        r.setId(1L);
        r.setName("张三");
        r.setIdCard("110101199003077536");
        r.setPhone("13800138000");
        r.setAddress("北京市朝阳区");
        r.setCreatedAt(LocalDateTime.now());

        assertEquals(1L, r.getId());
        assertEquals("张三", r.getName());
        assertEquals("110101199003077536", r.getIdCard());
        assertEquals("13800138000", r.getPhone());
        assertEquals("北京市朝阳区", r.getAddress());
        assertNotNull(r.getCreatedAt());
    }
}

@DisplayName("CommitteeMember")
class CommitteeMemberTest {

    @Test
    @DisplayName("isActiveMember在职应返回true")
    void activeMember() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(true);
        assertTrue(m.isActiveMember());
    }

    @Test
    @DisplayName("isActiveMember离职应返回false")
    void inactiveMember() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(false);
        assertFalse(m.isActiveMember());
    }

    @Test
    @DisplayName("isActiveMember null应返回false")
    void nullActiveMember() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(null);
        assertFalse(m.isActiveMember());
    }

    @Test
    @DisplayName("getStatusText在职")
    void activeText() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(true);
        assertEquals("在职", m.getStatusText());
    }

    @Test
    @DisplayName("getStatusText离职")
    void inactiveText() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(false);
        assertEquals("离职", m.getStatusText());
    }

    @Test
    @DisplayName("getStatusText null应返回离职")
    void nullStatusText() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(null);
        assertEquals("离职", m.getStatusText());
    }

    @Test
    @DisplayName("getIsActiveMember应与isActiveMember一致")
    void isActiveMemberJavaBean() {
        CommitteeMember m = new CommitteeMember();
        m.setIsActive(true);
        assertEquals(m.isActiveMember(), m.getIsActiveMember());
    }

    @Test
    @DisplayName("getter和setter应正确工作")
    void gettersAndSetters() {
        CommitteeMember m = new CommitteeMember();
        m.setId(1L);
        m.setName("王五");
        m.setPosition("村主任");
        m.setPhone("13900139000");
        m.setDuties("负责全面工作");
        m.setJoinTime(LocalDateTime.now());
        m.setIsActive(true);
        m.setCreatedAt(LocalDateTime.now());
        m.setUpdatedAt(LocalDateTime.now());

        assertEquals(1L, m.getId());
        assertEquals("王五", m.getName());
        assertEquals("村主任", m.getPosition());
        assertEquals("13900139000", m.getPhone());
        assertEquals("负责全面工作", m.getDuties());
        assertNotNull(m.getJoinTime());
        assertTrue(m.getIsActive());
        assertNotNull(m.getCreatedAt());
        assertNotNull(m.getUpdatedAt());
    }
}

@DisplayName("OperationLog")
class OperationLogTest {

    @Test
    @DisplayName("getter和setter应正确工作")
    void gettersAndSetters() {
        OperationLog log = new OperationLog();
        log.setId(1L);
        log.setOperator("admin");
        log.setOperationType("CREATE");
        log.setTargetType("ANNOUNCEMENT");
        log.setTargetId(1L);
        log.setDescription("创建公告");
        log.setIpAddress("127.0.0.1");
        log.setUserAgent("Mozilla/5.0");
        log.setCreatedAt(LocalDateTime.now());

        assertEquals(1L, log.getId());
        assertEquals("admin", log.getOperator());
        assertEquals("CREATE", log.getOperationType());
        assertEquals("ANNOUNCEMENT", log.getTargetType());
        assertEquals(1L, log.getTargetId());
        assertEquals("创建公告", log.getDescription());
        assertEquals("127.0.0.1", log.getIpAddress());
        assertEquals("Mozilla/5.0", log.getUserAgent());
        assertNotNull(log.getCreatedAt());
    }
}
