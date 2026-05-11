package com.village.committee.web;

import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.server.ResponseStatusException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GlobalMvcExceptionHandler全局MVC异常处理")
class GlobalMvcExceptionHandlerTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private Model model;

    @InjectMocks private GlobalMvcExceptionHandler handler;

    @Nested
    @DisplayName("handleRse - 处理ResponseStatusException")
    class HandleRse {

        @Test
        @DisplayName("404异常应设置404状态码并返回error视图")
        void 四零四异常应返回错误视图() {
            when(request.getRequestURI()).thenReturn("/residents/999");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn("req-1");

            ResponseStatusException ex = new ResponseStatusException(HttpStatus.NOT_FOUND, "资源不存在");
            String view = handler.handleRse(ex, request, response, model);

            assertEquals("error", view);
            verify(response).setStatus(404);
            verify(model).addAttribute("status", 404);
            verify(model).addAttribute("error", "404 NOT_FOUND");
            verify(model).addAttribute("message", "资源不存在");
            verify(model).addAttribute("path", "/residents/999");
            verify(model).addAttribute("requestId", "req-1");
        }

        @Test
        @DisplayName("400异常应设置400状态码")
        void 四零零异常应设置四零零() {
            when(request.getRequestURI()).thenReturn("/residents");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn(null);

            ResponseStatusException ex = new ResponseStatusException(HttpStatus.BAD_REQUEST, "参数错误");
            String view = handler.handleRse(ex, request, response, model);

            assertEquals("error", view);
            verify(response).setStatus(400);
            verify(model).addAttribute("status", 400);
        }
    }

    @Nested
    @DisplayName("handleAny - 处理通用异常")
    class HandleAny {

        @Test
        @DisplayName("通用异常应设置500状态码并返回error视图")
        void 通用异常应返回五零零() {
            when(request.getRequestURI()).thenReturn("/residents");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn("req-2");

            Exception ex = new RuntimeException("数据库连接失败");
            String view = handler.handleAny(ex, request, response, model);

            assertEquals("error", view);
            verify(response).setStatus(500);
            verify(model).addAttribute("status", 500);
            verify(model).addAttribute("error", "INTERNAL_SERVER_ERROR");
            verify(model).addAttribute("message", "数据库连接失败");
            verify(model).addAttribute("path", "/residents");
            verify(model).addAttribute("requestId", "req-2");
        }

        @Test
        @DisplayName("NullPointerException应返回500")
        void nullPointer应返回五零零() {
            when(request.getRequestURI()).thenReturn("/test");
            when(request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)).thenReturn(null);

            Exception ex = new NullPointerException("null");
            String view = handler.handleAny(ex, request, response, model);

            assertEquals("error", view);
            verify(response).setStatus(500);
            verify(model).addAttribute("requestId", null);
        }
    }
}
