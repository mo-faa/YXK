package com.village.committee.common;

import org.junit.jupiter.api.*;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PageResult分页结果")
class PageResultTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建PageResult应包含所有字段")
        void 创建PageResult应包含所有字段() {
            List<String> items = Arrays.asList("a", "b", "c");
            PageResult<String> result = new PageResult<>(items, 1, 10, 30);

            assertEquals(3, result.getItems().size());
            assertEquals(1, result.getPage());
            assertEquals(10, result.getSize());
            assertEquals(30, result.getTotal());
        }

        @Test
        @DisplayName("getTotalPages应正确计算")
        void getTotalPages应正确计算() {
            PageResult<String> r1 = new PageResult<>(List.of(), 1, 10, 100);
            assertEquals(10, r1.getTotalPages());

            PageResult<String> r2 = new PageResult<>(List.of(), 1, 10, 101);
            assertEquals(11, r2.getTotalPages());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("items为null时应返回空列表")
        void items为null时应返回空列表() {
            PageResult<String> result = new PageResult<>(null, 1, 10, 0);
            assertNotNull(result.getItems());
            assertTrue(result.getItems().isEmpty());
        }

        @Test
        @DisplayName("total为0时getTotalPages应返回0")
        void total为零时getTotalPages应返回零() {
            PageResult<String> result = new PageResult<>(List.of(), 1, 10, 0);
            assertEquals(0, result.getTotalPages());
        }

        @Test
        @DisplayName("size为0时getTotalPages应返回0")
        void size为零时getTotalPages应返回零() {
            PageResult<String> result = new PageResult<>(List.of(), 1, 0, 100);
            assertEquals(0, result.getTotalPages());
        }
    }

    @Nested
    @DisplayName("isHasPrev和isHasNext")
    class 上下页判断 {
        @Test
        @DisplayName("第1页isHasPrev应为false")
        void 第一页无上一页() {
            PageResult<String> result = new PageResult<>(List.of("a"), 1, 10, 20);
            assertFalse(result.isHasPrev());
        }

        @Test
        @DisplayName("第2页isHasPrev应为true")
        void 第二页有上一页() {
            PageResult<String> result = new PageResult<>(List.of("a"), 2, 10, 20);
            assertTrue(result.isHasPrev());
        }

        @Test
        @DisplayName("最后一页isHasNext应为false")
        void 最后一页无下一页() {
            PageResult<String> result = new PageResult<>(List.of("a"), 2, 10, 20);
            assertFalse(result.isHasNext());
        }

        @Test
        @DisplayName("非最后一页isHasNext应为true")
        void 非最后一页有下一页() {
            PageResult<String> result = new PageResult<>(List.of("a"), 1, 10, 20);
            assertTrue(result.isHasNext());
        }
    }
}
