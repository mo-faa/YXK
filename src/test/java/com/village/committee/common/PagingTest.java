package com.village.committee.common;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Paging工具类")
class PagingTest {

    @Nested
    @DisplayName("normalizeQuery - 规范化搜索关键词")
    class NormalizeQuery {

        @Test
        @DisplayName("null应返回null")
        void null应返回null() {
            assertNull(Paging.normalizeQuery(null));
        }

        @Test
        @DisplayName("空字符串应返回null")
        void 空字符串应返回null() {
            assertNull(Paging.normalizeQuery(""));
            assertNull(Paging.normalizeQuery("   "));
        }

        @Test
        @DisplayName("正常关键词应去空格返回")
        void 正常关键词应去空格返回() {
            assertEquals("张三", Paging.normalizeQuery("  张三  "));
        }

        @Test
        @DisplayName("超长关键词应截断到100字符")
        void 超长关键词应截断() {
            String longQuery = "a".repeat(200);
            String result = Paging.normalizeQuery(longQuery);
            assertEquals(100, result.length());
        }

        @Test
        @DisplayName("100字符以内的关键词不应截断")
        void 一百字符以内不应截断() {
            String query = "a".repeat(100);
            assertEquals(100, Paging.normalizeQuery(query).length());
        }
    }

    @Nested
    @DisplayName("normalizePage - 规范化页码")
    class NormalizePage {

        @Test
        @DisplayName("null应返回1")
        void null应返回1() {
            assertEquals(1, Paging.normalizePage(null));
        }

        @Test
        @DisplayName("0应返回1")
        void 零应返回1() {
            assertEquals(1, Paging.normalizePage(0));
        }

        @Test
        @DisplayName("负数应返回1")
        void 负数应返回1() {
            assertEquals(1, Paging.normalizePage(-1));
            assertEquals(1, Paging.normalizePage(-100));
        }

        @Test
        @DisplayName("1应返回1")
        void 一应返回1() {
            assertEquals(1, Paging.normalizePage(1));
        }

        @Test
        @DisplayName("超过10000应返回10000")
        void 超过一万应返回一万() {
            assertEquals(10000, Paging.normalizePage(10001));
            assertEquals(10000, Paging.normalizePage(99999));
        }

        @Test
        @DisplayName("正常页码应原样返回")
        void 正常页码应原样返回() {
            assertEquals(5, Paging.normalizePage(5));
            assertEquals(100, Paging.normalizePage(100));
        }
    }

    @Nested
    @DisplayName("normalizeSize - 规范化每页数量")
    class NormalizeSize {

        @Test
        @DisplayName("null应返回默认值")
        void null应返回默认值() {
            assertEquals(10, Paging.normalizeSize(null, 10, 100));
        }

        @Test
        @DisplayName("0应返回默认值")
        void 零应返回默认值() {
            assertEquals(10, Paging.normalizeSize(0, 10, 100));
        }

        @Test
        @DisplayName("负数应返回默认值")
        void 负数应返回默认值() {
            assertEquals(10, Paging.normalizeSize(-1, 10, 100));
        }

        @Test
        @DisplayName("超过最大值应返回最大值")
        void 超过最大值应返回最大值() {
            assertEquals(100, Paging.normalizeSize(200, 10, 100));
        }

        @Test
        @DisplayName("正常值应原样返回")
        void 正常值应原样返回() {
            assertEquals(20, Paging.normalizeSize(20, 10, 100));
        }
    }

    @Nested
    @DisplayName("offset - 计算偏移量")
    class Offset {

        @Test
        @DisplayName("第1页每页10条偏移量为0")
        void 第一页偏移量为0() {
            assertEquals(0, Paging.offset(1, 10));
        }

        @Test
        @DisplayName("第2页每页10条偏移量为10")
        void 第二页偏移量为10() {
            assertEquals(10, Paging.offset(2, 10));
        }

        @Test
        @DisplayName("第5页每页20条偏移量为80")
        void 第五页偏移量为80() {
            assertEquals(80, Paging.offset(5, 20));
        }
    }

    @Nested
    @DisplayName("totalPages - 计算总页数")
    class TotalPages {

        @Test
        @DisplayName("总数为0应返回0")
        void 总数为0应返回0() {
            assertEquals(0, Paging.totalPages(0, 10));
        }

        @Test
        @DisplayName("总数为负数应返回0")
        void 总数为负数应返回0() {
            assertEquals(0, Paging.totalPages(-1, 10));
        }

        @Test
        @DisplayName("每页大小为0应返回0")
        void 每页大小为0应返回0() {
            assertEquals(0, Paging.totalPages(100, 0));
        }

        @Test
        @DisplayName("100条每页10条应返回10页")
        void 一百条十页() {
            assertEquals(10, Paging.totalPages(100, 10));
        }

        @Test
        @DisplayName("101条每页10条应返回11页")
        void 一百零一条十一页() {
            assertEquals(11, Paging.totalPages(101, 10));
        }

        @Test
        @DisplayName("1条每页10条应返回1页")
        void 一条一页() {
            assertEquals(1, Paging.totalPages(1, 10));
        }
    }

    @Nested
    @DisplayName("hasNext - 是否有下一页")
    class HasNext {

        @Test
        @DisplayName("第1页10条共100条应有下一页")
        void 应有下一页() {
            assertTrue(Paging.hasNext(1, 10, 100));
        }

        @Test
        @DisplayName("第10页10条共100条应无下一页")
        void 应无下一页() {
            assertFalse(Paging.hasNext(10, 10, 100));
        }

        @Test
        @DisplayName("第11页10条共100条应无下一页")
        void 超出范围应无下一页() {
            assertFalse(Paging.hasNext(11, 10, 100));
        }
    }

    @Nested
    @DisplayName("hasPrev - 是否有上一页")
    class HasPrev {

        @Test
        @DisplayName("第1页应无上一页")
        void 第一页应无上一页() {
            assertFalse(Paging.hasPrev(1));
        }

        @Test
        @DisplayName("第2页应有上一页")
        void 第二页应有上一页() {
            assertTrue(Paging.hasPrev(2));
        }

        @Test
        @DisplayName("第100页应有上一页")
        void 第一百页应有上一页() {
            assertTrue(Paging.hasPrev(100));
        }
    }
}
