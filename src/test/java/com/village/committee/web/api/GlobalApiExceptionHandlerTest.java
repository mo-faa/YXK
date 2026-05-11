package com.village.committee.web.api;

import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GlobalApiExceptionHandler全局API异常处理")
class GlobalApiExceptionHandlerTest {

    @Mock private HttpServletRequest request;

    @InjectMocks private GlobalApiExceptionHandler handler;

    @Nested
    @DisplayName("handleResponseStatus - 处理ResponseStatusException")
    class HandleResponseStatus {

        @Test
        @DisplayName("404异常应返回404状态码")
        void 四零四异常应返回四零四() {
            when(request.getRequestURI()).thenReturn("/api/residents/999");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn("req-123");

            ResponseStatusException ex = new ResponseStatusException(HttpStatus.NOT_FOUND, "资源不存在");
            ResponseEntity<ApiError> response = handler.handleResponseStatus(ex, request);

            assertEquals(404, response.getStatusCode().value());
            assertNotNull(response.getBody());
            assertEquals(404, response.getBody().status());
            assertEquals("资源不存在", response.getBody().message());
            assertEquals("/api/residents/999", response.getBody().path());
            assertEquals("req-123", response.getBody().requestId());
        }

        @Test
        @DisplayName("400异常应返回400状态码")
        void 四零零异常应返回四零零() {
            when(request.getRequestURI()).thenReturn("/api/residents");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn(null);

            ResponseStatusException ex = new ResponseStatusException(HttpStatus.BAD_REQUEST, "参数错误");
            ResponseEntity<ApiError> response = handler.handleResponseStatus(ex, request);

            assertEquals(400, response.getStatusCode().value());
            assertNotNull(response.getBody());
            assertEquals("参数错误", response.getBody().message());
            assertNull(response.getBody().requestId());
        }

        @Test
        @DisplayName("ApiError应包含时间戳")
        void apiError应包含时间戳() {
            when(request.getRequestURI()).thenReturn("/api/test");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn("r1");

            ResponseStatusException ex = new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "error");
            ResponseEntity<ApiError> response = handler.handleResponseStatus(ex, request);

            assertNotNull(response.getBody().timestamp());
        }
    }

    @Nested
    @DisplayName("handleAny - 处理通用异常")
    class HandleAny {

        @Test
        @DisplayName("通用异常应返回500状态码")
        void 通用异常应返回五零零() {
            when(request.getRequestURI()).thenReturn("/api/residents");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn("req-456");

            Exception ex = new RuntimeException("数据库连接失败");
            ResponseEntity<ApiError> response = handler.handleAny(ex, request);

            assertEquals(500, response.getStatusCode().value());
            assertNotNull(response.getBody());
            assertEquals(500, response.getBody().status());
            assertEquals("INTERNAL_SERVER_ERROR", response.getBody().error());
            assertEquals("数据库连接失败", response.getBody().message());
            assertEquals("req-456", response.getBody().requestId());
        }

        @Test
        @DisplayName("NullPointerException应返回500")
        void nullPointer应返回五零零() {
            when(request.getRequestURI()).thenReturn("/api/test");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn(null);

            Exception ex = new NullPointerException("null value");
            ResponseEntity<ApiError> response = handler.handleAny(ex, request);

            assertEquals(500, response.getStatusCode().value());
            assertEquals("null value", response.getBody().message());
        }
    }
}
