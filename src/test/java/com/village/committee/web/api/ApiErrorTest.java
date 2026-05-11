package com.village.committee.web.api;

import org.junit.jupiter.api.*;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ApiError记录类")
class ApiErrorTest {

    @Nested
    @DisplayName("创建ApiError")
    class CreateApiError {

        @Test
        @DisplayName("应正确创建包含所有字段的ApiError")
        void 应正确创建() {
            Instant now = Instant.now();
            ApiError error = new ApiError(now, 404, "NOT_FOUND", "资源不存在", "/api/residents/1", "req-123");

            assertEquals(now, error.timestamp());
            assertEquals(404, error.status());
            assertEquals("NOT_FOUND", error.error());
            assertEquals("资源不存在", error.message());
            assertEquals("/api/residents/1", error.path());
            assertEquals("req-123", error.requestId());
        }

        @Test
        @DisplayName("不同状态码应正确存储")
        void 不同状态码应正确存储() {
            ApiError error400 = new ApiError(Instant.now(), 400, "BAD_REQUEST", "参数错误", "/api/test", null);
            assertEquals(400, error400.status());

            ApiError error500 = new ApiError(Instant.now(), 500, "INTERNAL_SERVER_ERROR", "服务器错误", "/api/test", null);
            assertEquals(500, error500.status());
        }
    }

    @Nested
    @DisplayName("record特性")
    class RecordFeatures {

        @Test
        @DisplayName("equals应基于所有字段")
        void equals应基于所有字段() {
            Instant now = Instant.now();
            ApiError e1 = new ApiError(now, 404, "NOT_FOUND", "不存在", "/api/1", "r1");
            ApiError e2 = new ApiError(now, 404, "NOT_FOUND", "不存在", "/api/1", "r1");
            assertEquals(e1, e2);
        }

        @Test
        @DisplayName("不同字段应不相等")
        void 不同字段应不相等() {
            ApiError e1 = new ApiError(Instant.now(), 404, "NOT_FOUND", "不存在", "/api/1", "r1");
            ApiError e2 = new ApiError(Instant.now(), 500, "ERROR", "错误", "/api/2", "r2");
            assertNotEquals(e1, e2);
        }

        @Test
        @DisplayName("null字段应正常处理")
        void null字段应正常处理() {
            ApiError error = new ApiError(null, 0, null, null, null, null);
            assertNull(error.timestamp());
            assertEquals(0, error.status());
            assertNull(error.error());
            assertNull(error.message());
            assertNull(error.path());
            assertNull(error.requestId());
        }
    }
}
