package com.village.committee.web.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CsrfTokenFilter CSRF过滤器")
class CsrfTokenFilterTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private FilterChain chain;
    @Mock private HttpSession session;

    @InjectMocks private CsrfTokenFilter csrfTokenFilter;

    @Nested
    @DisplayName("GET请求 - 不验证CSRF")
    class GetRequest {

        @Test
        @DisplayName("GET请求应直接放行")
        void get请求应直接放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/announcements");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("GET");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("existing-token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("GET请求应设置_csrf请求属性")
        void get请求应设置Csrf属性() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/announcements");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("GET");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("test-csrf-token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(request).setAttribute("_csrf", "test-csrf-token");
        }
    }

    @Nested
    @DisplayName("POST请求 - 验证CSRF")
    class PostRequest {

        @Test
        @DisplayName("POST请求带正确CSRF token应放行")
        void post请求带正确Token应放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("POST");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("valid-token");
            when(request.getParameter("_csrf")).thenReturn("valid-token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("POST请求无CSRF token应返回403")
        void post请求无Token应返回403() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("POST");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("valid-token");
            when(request.getParameter("_csrf")).thenReturn(null);
            when(request.getHeader("X-CSRF-TOKEN")).thenReturn(null);
            when(response.getWriter()).thenReturn(new java.io.PrintWriter(new java.io.StringWriter()));

            csrfTokenFilter.doFilter(request, response, chain);

            verify(response).setStatus(HttpServletResponse.SC_FORBIDDEN);
            verify(chain, never()).doFilter(request, response);
        }

        @Test
        @DisplayName("POST请求带错误CSRF token应返回403")
        void post请求带错误Token应返回403() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("POST");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("valid-token");
            when(request.getParameter("_csrf")).thenReturn("wrong-token");
            when(response.getWriter()).thenReturn(new java.io.PrintWriter(new java.io.StringWriter()));

            csrfTokenFilter.doFilter(request, response, chain);

            verify(response).setStatus(HttpServletResponse.SC_FORBIDDEN);
        }

        @Test
        @DisplayName("POST请求通过X-CSRF-TOKEN头应放行")
        void post请求通过Header应放行() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("POST");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("valid-token");
            when(request.getParameter("_csrf")).thenReturn(null);
            when(request.getHeader("X-CSRF-TOKEN")).thenReturn("valid-token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }
    }

    @Nested
    @DisplayName("API路径 - 跳过CSRF验证")
    class ApiPath {

        @Test
        @DisplayName("API路径POST请求应跳过CSRF验证")
        void api路径应跳过Csrf() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/api/residents");
            when(request.getContextPath()).thenReturn("/YXK");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }
    }

    @Nested
    @DisplayName("Token生成")
    class TokenGeneration {

        @Test
        @DisplayName("session中无token时应生成新token")
        void 无token应生成新() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/announcements");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("GET");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn(null);

            csrfTokenFilter.doFilter(request, response, chain);

            verify(session).setAttribute(eq("CSRF_TOKEN"), anyString());
            verify(request).setAttribute(eq("_csrf"), anyString());
        }

        @Test
        @DisplayName("session中已有token应复用")
        void 已有token应复用() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/announcements");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("GET");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("existing-token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(session, never()).setAttribute(eq("CSRF_TOKEN"), anyString());
            verify(request).setAttribute("_csrf", "existing-token");
        }
    }

    @Nested
    @DisplayName("其他HTTP方法")
    class OtherMethods {

        @Test
        @DisplayName("PUT请求应验证CSRF")
        void put请求应验证Csrf() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents/1");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("PUT");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("token");
            when(request.getParameter("_csrf")).thenReturn("token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("DELETE请求应验证CSRF")
        void delete请求应验证Csrf() throws Exception {
            when(request.getRequestURI()).thenReturn("/YXK/residents/1");
            when(request.getContextPath()).thenReturn("/YXK");
            when(request.getMethod()).thenReturn("DELETE");
            when(request.getSession(true)).thenReturn(session);
            when(session.getAttribute("CSRF_TOKEN")).thenReturn("token");
            when(request.getParameter("_csrf")).thenReturn("token");

            csrfTokenFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }
    }
}
