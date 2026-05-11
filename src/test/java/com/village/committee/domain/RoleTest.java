package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Role实体类")
class RoleTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建角色应包含所有字段")
        void 创建角色应包含所有字段() {
            Role r = new Role();
            r.setId(1L);
            r.setCode("ADMIN");
            r.setName("系统管理员");
            r.setDescription("拥有所有权限");
            r.setSortOrder(1);
            assertEquals(1L, r.getId());
            assertEquals("ADMIN", r.getCode());
            assertEquals("系统管理员", r.getName());
            assertEquals("拥有所有权限", r.getDescription());
            assertEquals(1, r.getSortOrder());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("sortOrder为null时getSortOrder返回0")
        void sortOrder为null时返回0() {
            Role r = new Role();
            r.setSortOrder(null);
            assertEquals(0, r.getSortOrder());
        }

        @Test
        @DisplayName("sortOrder为0时getSortOrder返回0")
        void sortOrder为0时返回0() {
            Role r = new Role();
            r.setSortOrder(0);
            assertEquals(0, r.getSortOrder());
        }

        @Test
        @DisplayName("sortOrder为负数时getSortOrder返回负数")
        void sortOrder为负数时返回负数() {
            Role r = new Role();
            r.setSortOrder(-1);
            assertEquals(-1, r.getSortOrder());
        }
    }
}
