package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Permission实体类")
class PermissionTest {

    @Test
    @DisplayName("创建权限应包含所有字段")
    void 创建权限应包含所有字段() {
        Permission p = new Permission();
        p.setId(1L);
        p.setCode("user:view");
        p.setName("查看用户");
        p.setModule("用户管理");
        assertEquals(1L, p.getId());
        assertEquals("user:view", p.getCode());
        assertEquals("查看用户", p.getName());
        assertEquals("用户管理", p.getModule());
    }

    @Test
    @DisplayName("所有字段为null时应正常")
    void 所有字段为null时应正常() {
        Permission p = new Permission();
        assertNull(p.getId());
        assertNull(p.getCode());
        assertNull(p.getName());
        assertNull(p.getModule());
    }
}
