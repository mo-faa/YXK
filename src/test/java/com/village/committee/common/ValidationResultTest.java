package com.village.committee.common;

import org.junit.jupiter.api.*;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ValidationResult")
class ValidationResultTest {

    @Nested
    @DisplayName("ok")
    class Ok {

        @Test
        @DisplayName("应返回有效的结果")
        void shouldBeValid() {
            ValidationResult result = ValidationResult.ok();
            assertTrue(result.isValid());
        }

        @Test
        @DisplayName("错误消息应为null")
        void errorMessageShouldBeNull() {
            ValidationResult result = ValidationResult.ok();
            assertNull(result.getErrorMessage());
        }

        @Test
        @DisplayName("orNull应返回null")
        void orNullShouldReturnNull() {
            ValidationResult result = ValidationResult.ok();
            assertNull(result.orNull());
        }

        @Test
        @DisplayName("orThrow不应抛异常")
        void orThrowShouldNotThrow() {
            ValidationResult result = ValidationResult.ok();
            assertDoesNotThrow(() -> result.orThrow());
        }

        @Test
        @DisplayName("多次调用ok应返回同一实例")
        void shouldBeSameInstance() {
            ValidationResult r1 = ValidationResult.ok();
            ValidationResult r2 = ValidationResult.ok();
            assertSame(r1, r2);
        }
    }

    @Nested
    @DisplayName("error")
    class Error {

        @Test
        @DisplayName("应返回无效的结果")
        void shouldBeInvalid() {
            ValidationResult result = ValidationResult.error("出错了");
            assertFalse(result.isValid());
        }

        @Test
        @DisplayName("错误消息应正确")
        void errorMessageShouldBeCorrect() {
            ValidationResult result = ValidationResult.error("出错了");
            assertEquals("出错了", result.getErrorMessage());
        }

        @Test
        @DisplayName("orNull应返回错误消息")
        void orNullShouldReturnErrorMessage() {
            ValidationResult result = ValidationResult.error("出错了");
            assertEquals("出错了", result.orNull());
        }

        @Test
        @DisplayName("orThrow应抛ResponseStatusException")
        void orThrowShouldThrow() {
            ValidationResult result = ValidationResult.error("出错了");
            ResponseStatusException ex = assertThrows(ResponseStatusException.class, () -> result.orThrow());
            assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
            assertEquals("出错了", ex.getReason());
        }
    }
}
