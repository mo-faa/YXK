package com.village.committee.common;

import org.junit.jupiter.api.*;
import java.util.List;
import java.util.Collections;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Paging")
class PagingTest {

    @Nested
    @DisplayName("normalizeQuery")
    class NormalizeQuery {

        @Test
        @DisplayName("null应返回null")
        void nullQuery() {
            assertNull(Paging.normalizeQuery(null));
        }

        @Test
        @DisplayName("空字符串应返回null")
        void emptyQuery() {
            assertNull(Paging.normalizeQuery(""));
            assertNull(Paging.normalizeQuery("   "));
        }

        @Test
        @DisplayName("应去除首尾空格")
        void trimQuery() {
            assertEquals("test", Paging.normalizeQuery("  test  "));
        }

        @Test
        @DisplayName("超过100字符应截断")
        void longQuery() {
            String longStr = "a".repeat(150);
            String result = Paging.normalizeQuery(longStr);
            assertEquals(100, result.length());
        }

        @Test
        @DisplayName("正常查询应原样返回")
        void normalQuery() {
            assertEquals("test query", Paging.normalizeQuery("test query"));
        }
    }

    @Nested
    @DisplayName("normalizePage")
    class NormalizePage {

        @Test
        @DisplayName("null应返回1")
        void nullPage() {
            assertEquals(1, Paging.normalizePage(null));
        }

        @Test
        @DisplayName("小于1应返回1")
        void lessThanOne() {
            assertEquals(1, Paging.normalizePage(0));
            assertEquals(1, Paging.normalizePage(-1));
            assertEquals(1, Paging.normalizePage(-100));
        }

        @Test
        @DisplayName("超过10000应返回10000")
        void overMax() {
            assertEquals(10000, Paging.normalizePage(10001));
            assertEquals(10000, Paging.normalizePage(99999));
        }

        @Test
        @DisplayName("正常页码应原样返回")
        void normalPage() {
            assertEquals(1, Paging.normalizePage(1));
            assertEquals(5, Paging.normalizePage(5));
            assertEquals(10000, Paging.normalizePage(10000));
        }
    }

    @Nested
    @DisplayName("normalizeSize")
    class NormalizeSize {

        @Test
        @DisplayName("null应返回默认值")
        void nullSize() {
            assertEquals(10, Paging.normalizeSize(null, 10, 100));
        }

        @Test
        @DisplayName("小于1应返回默认值")
        void lessThanOne() {
            assertEquals(10, Paging.normalizeSize(0, 10, 100));
            assertEquals(10, Paging.normalizeSize(-1, 10, 100));
        }

        @Test
        @DisplayName("超过最大值应返回最大值")
        void overMax() {
            assertEquals(100, Paging.normalizeSize(200, 10, 100));
        }

        @Test
        @DisplayName("正常值应原样返回")
        void normalSize() {
            assertEquals(20, Paging.normalizeSize(20, 10, 100));
        }
    }

    @Nested
    @DisplayName("offset")
    class Offset {

        @Test
        @DisplayName("第1页偏移0")
        void page1() {
            assertEquals(0, Paging.offset(1, 10));
        }

        @Test
        @DisplayName("第2页偏移10")
        void page2() {
            assertEquals(10, Paging.offset(2, 10));
        }

        @Test
        @DisplayName("第3页偏移20")
        void page3() {
            assertEquals(20, Paging.offset(3, 10));
        }
    }

    @Nested
    @DisplayName("totalPages")
    class TotalPages {

        @Test
        @DisplayName("总数为0应返回0")
        void zeroTotal() {
            assertEquals(0, Paging.totalPages(0, 10));
        }

        @Test
        @DisplayName("总数小于每页数量应返回1")
        void lessThanSize() {
            assertEquals(1, Paging.totalPages(5, 10));
        }

        @Test
        @DisplayName("总数等于每页数量应返回1")
        void equalSize() {
            assertEquals(1, Paging.totalPages(10, 10));
        }

        @Test
        @DisplayName("总数大于每页数量应向上取整")
        void greaterThanSize() {
            assertEquals(2, Paging.totalPages(15, 10));
            assertEquals(3, Paging.totalPages(25, 10));
        }

        @Test
        @DisplayName("size为0应返回0")
        void zeroSize() {
            assertEquals(0, Paging.totalPages(10, 0));
        }
    }

    @Nested
    @DisplayName("hasNext")
    class HasNext {

        @Test
        @DisplayName("有下一页应返回true")
        void hasNextPage() {
            assertTrue(Paging.hasNext(1, 10, 25));
        }

        @Test
        @DisplayName("无下一页应返回false")
        void noNextPage() {
            assertFalse(Paging.hasNext(3, 10, 25));
            assertFalse(Paging.hasNext(1, 10, 10));
        }
    }

    @Nested
    @DisplayName("hasPrev")
    class HasPrev {

        @Test
        @DisplayName("第1页无上一页")
        void firstPage() {
            assertFalse(Paging.hasPrev(1));
        }

        @Test
        @DisplayName("第2页有上一页")
        void secondPage() {
            assertTrue(Paging.hasPrev(2));
        }
    }
}

@DisplayName("PageResult")
class PageResultTest {

    @Test
    @DisplayName("null items应转为空列表")
    void nullItems() {
        PageResult<String> result = new PageResult<>(null, 1, 10, 0);
        assertEquals(Collections.emptyList(), result.getItems());
    }

    @Test
    @DisplayName("基本属性应正确返回")
    void basicProperties() {
        PageResult<String> result = new PageResult<>(List.of("a", "b"), 2, 10, 25);
        assertEquals(List.of("a", "b"), result.getItems());
        assertEquals(2, result.getPage());
        assertEquals(10, result.getSize());
        assertEquals(25, result.getTotal());
    }

    @Test
    @DisplayName("getTotalPages应正确计算")
    void totalPages() {
        PageResult<String> result = new PageResult<>(List.of(), 1, 10, 25);
        assertEquals(3, result.getTotalPages());
    }

    @Test
    @DisplayName("isHasPrev第1页应返回false")
    void noPrevOnFirstPage() {
        PageResult<String> result = new PageResult<>(List.of("a"), 1, 10, 15);
        assertFalse(result.isHasPrev());
    }

    @Test
    @DisplayName("isHasPrev非第1页应返回true")
    void hasPrevOnSecondPage() {
        PageResult<String> result = new PageResult<>(List.of("a"), 2, 10, 15);
        assertTrue(result.isHasPrev());
    }

    @Test
    @DisplayName("isHasNext最后一页应返回false")
    void noNextOnLastPage() {
        PageResult<String> result = new PageResult<>(List.of("a"), 3, 10, 25);
        assertFalse(result.isHasNext());
    }

    @Test
    @DisplayName("isHasNext非最后一页应返回true")
    void hasNextOnFirstPage() {
        PageResult<String> result = new PageResult<>(List.of("a"), 1, 10, 25);
        assertTrue(result.isHasNext());
    }
}
