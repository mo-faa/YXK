package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("OperationLog实体类")
class OperationLogTest {

    @Test
    @DisplayName("创建操作日志应包含所有字段")
    void 创建操作日志应包含所有字段() {
        OperationLog log = new OperationLog();
        log.setId(1L);
        log.setOperator("admin");
        log.setOperationType("CREATE");
        log.setTargetType("resident");
        log.setTargetId(10L);
        log.setDescription("创建村民记录");
        log.setIpAddress("192.168.1.1");
        log.setUserAgent("Mozilla/5.0");

        assertEquals(1L, log.getId());
        assertEquals("admin", log.getOperator());
        assertEquals("CREATE", log.getOperationType());
        assertEquals("resident", log.getTargetType());
        assertEquals(10L, log.getTargetId());
        assertEquals("创建村民记录", log.getDescription());
        assertEquals("192.168.1.1", log.getIpAddress());
        assertEquals("Mozilla/5.0", log.getUserAgent());
    }

    @Test
    @DisplayName("所有字段为null时应正常")
    void 所有字段为null时应正常() {
        OperationLog log = new OperationLog();
        assertNull(log.getId());
        assertNull(log.getOperator());
        assertNull(log.getOperationType());
        assertNull(log.getTargetType());
        assertNull(log.getTargetId());
        assertNull(log.getDescription());
        assertNull(log.getIpAddress());
        assertNull(log.getUserAgent());
        assertNull(log.getCreatedAt());
    }
}
