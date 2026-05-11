package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("UserRole实体类")
class UserRoleTest {

    @Test
    @DisplayName("创建用户角色关联应包含所有字段")
    void 创建用户角色关联应包含所有字段() {
        UserRole ur = new UserRole();
        ur.setId(1L);
        ur.setUserId(1L);
        ur.setRoleId(2L);

        assertEquals(1L, ur.getId());
        assertEquals(1L, ur.getUserId());
        assertEquals(2L, ur.getRoleId());
    }

    @Test
    @DisplayName("所有字段为null时应正常")
    void 所有字段为null时应正常() {
        UserRole ur = new UserRole();
        assertNull(ur.getId());
        assertNull(ur.getUserId());
        assertNull(ur.getRoleId());
        assertNull(ur.getCreatedAt());
    }
}
