package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

@DisplayName("CommitteeMember实体类")
class CommitteeMemberTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建成员应包含所有字段")
        void 创建成员应包含所有字段() {
            CommitteeMember m = new CommitteeMember();
            m.setId(1L);
            m.setName("李四");
            m.setPosition("村主任");
            m.setPhone("13900139000");
            m.setDuties("主持村委会全面工作");
            m.setJoinTime(LocalDateTime.of(2025, 1, 1, 0, 0));
            m.setIsActive(true);
            m.setCreatedAt(LocalDateTime.now());
            m.setUpdatedAt(LocalDateTime.now());

            assertEquals(1L, m.getId());
            assertEquals("李四", m.getName());
            assertEquals("村主任", m.getPosition());
            assertEquals("13900139000", m.getPhone());
            assertEquals("主持村委会全面工作", m.getDuties());
            assertTrue(m.getIsActive());
        }
    }

    @Nested
    @DisplayName("isActiveMember方法")
    class IsActiveMember方法 {
        @Test
        @DisplayName("isActive为true时返回true")
        void isActive为true时返回true() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(true);
            assertTrue(m.isActiveMember());
        }

        @Test
        @DisplayName("isActive为false时返回false")
        void isActive为false时返回false() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(false);
            assertFalse(m.isActiveMember());
        }

        @Test
        @DisplayName("isActive为null时返回false")
        void isActive为null时返回false() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(null);
            assertFalse(m.isActiveMember());
        }
    }

    @Nested
    @DisplayName("getIsActiveMember方法")
    class GetIsActiveMember方法 {
        @Test
        @DisplayName("应与isActiveMember结果一致")
        void 应与IsActiveMember结果一致() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(true);
            assertEquals(m.isActiveMember(), m.getIsActiveMember());
        }
    }

    @Nested
    @DisplayName("getStatusText方法")
    class GetStatusText方法 {
        @Test
        @DisplayName("isActive为true时返回在职")
        void isActive为true时返回在职() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(true);
            assertEquals("在职", m.getStatusText());
        }

        @Test
        @DisplayName("isActive为false时返回离职")
        void isActive为false时返回离职() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(false);
            assertEquals("离职", m.getStatusText());
        }

        @Test
        @DisplayName("isActive为null时返回离职")
        void isActive为null时返回离职() {
            CommitteeMember m = new CommitteeMember();
            m.setIsActive(null);
            assertEquals("离职", m.getStatusText());
        }
    }
}
