package com.village.committee.web.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.*;
import org.mockito.*;
import org.mockito.junit.jupiter.*;

import java.io.*;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AuthFilter认证过滤器")
class AuthFilterTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private FilterChain chain;
    @Mock private HttpSession session;

    private AuthFilter authFilter;

    @BeforeEach
    void setUp() {
        authFilter = new AuthFilter();
    }

    @Nested
    @DisplayName("排除路径 - 不需要认证")
    class 排除路径 {

        @Test
        @DisplayName("登录页面应直接放行")
        void 登录页面应直接放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/login");
            when(request.getContextPath()).thenReturn("/YXK");

            authFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
            verify(response, never()).sendRedirect(anyString());
        }

        @Test
        @DisplayName("注册页面应直接放行")
        void 注册页面应直接放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/register");
            when(request.getContextPath()).thenReturn("/YXK");

            authFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("静态资源应直接放行")
        void 静态资源应直接放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/static/css/main.css");
            when(request.getContextPath()).thenReturn("/YXK");

            authFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("错误页面应直接放行")
        void 错误页面应直接放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/error");
            when(request.getContextPath()).thenReturn("/YXK");

            authFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }
    }

    @Nested
    @DisplayName("需要认证的路径")
    class 需要认证的路径 {

        @Test
        @DisplayName("未登录访问受保护路径应重定向到登录页")
        void 未登录应重定向() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getSession(false)).thenReturn(null);
            when(request.getHeader("X-Requested-With")).thenReturn(null);

            authFilter.doFilter(request, response, chain);

            verify(response).sendRedirect(contains("/login"));
            verify(chain, never()).doFilter(request, response);
        }

        @Test
        @DisplayName("已登录访问受保护路径应放行")
        void 已登录应放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("userId")).thenReturn(1L);

            authFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("AJAX未登录请求应返回401状态码")
        void Ajax未登录应返回401() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getSession(false)).thenReturn(null);
            when(request.getHeader("X-Requested-With")).thenReturn("XMLHttpRequest");
            PrintWriter writer = mock(PrintWriter.class);
            when(response.getWriter()).thenReturn(writer);

            authFilter.doFilter(request, response, chain);

            verify(response).setStatus(401);
            verify(response).setContentType(contains("application/json"));
        }

        @Test
        @DisplayName("session存在但userId为null应重定向")
        void session存在但userId为null应重定向() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/users");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("userId")).thenReturn(null);
            when(request.getHeader("X-Requested-With")).thenReturn(null);

            authFilter.doFilter(request, response, chain);

            verify(response).sendRedirect(contains("/login"));
        }
    }
}
