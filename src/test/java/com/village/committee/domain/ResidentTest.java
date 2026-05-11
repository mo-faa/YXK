package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Resident实体类")
class ResidentTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建村民应包含所有字段")
        void 创建村民应包含所有字段() {
            Resident r = new Resident();
            r.setId(1L);
            r.setName("王五");
            r.setIdCard("110101199001011234");
            r.setPhone("13800138000");
            r.setAddress("北京市东城区某村1号");
            r.setCreatedAt(java.time.LocalDateTime.of(2026, 1, 1, 0, 0));

            assertEquals(1L, r.getId());
            assertEquals("王五", r.getName());
            assertEquals("110101199001011234", r.getIdCard());
            assertEquals("13800138000", r.getPhone());
            assertEquals("北京市东城区某村1号", r.getAddress());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("所有字段为null时应正常")
        void 所有字段为null时应正常() {
            Resident r = new Resident();
            assertNull(r.getId());
            assertNull(r.getName());
            assertNull(r.getIdCard());
            assertNull(r.getPhone());
            assertNull(r.getAddress());
            assertNull(r.getCreatedAt());
        }

        @Test
        @DisplayName("空字符串字段应能正常设置")
        void 空字符串字段应能正常设置() {
            Resident r = new Resident();
            r.setName("");
            r.setIdCard("");
            r.setPhone("");
            r.setAddress("");
            assertEquals("", r.getName());
            assertEquals("", r.getIdCard());
        }
    }
}
