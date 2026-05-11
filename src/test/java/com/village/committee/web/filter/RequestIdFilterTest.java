package com.village.committee.web.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RequestIdFilter请求ID过滤器")
class RequestIdFilterTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private FilterChain chain;

    @InjectMocks private RequestIdFilter requestIdFilter;

    @Nested
    @DisplayName("请求头中无Request-ID")
    class NoRequestIdHeader {

        @Test
        @DisplayName("应生成新的UUID作为Request-ID")
        void 应生成新UUID() throws Exception {
            when(request.getHeader("X-Request-Id")).thenReturn(null);

            requestIdFilter.doFilter(request, response, chain);

            verify(request).setAttribute(eq("requestId"), anyString());
            verify(response).setHeader(eq("X-Request-Id"), anyString());
            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("空白Request-ID应生成新的")
        void 空白RequestId应生成新的() throws Exception {
            when(request.getHeader("X-Request-Id")).thenReturn("   ");

            requestIdFilter.doFilter(request, response, chain);

            verify(request).setAttribute(eq("requestId"), anyString());
        }
    }

    @Nested
    @DisplayName("请求头中有Request-ID")
    class HasRequestIdHeader {

        @Test
        @DisplayName("应复用请求头中的Request-ID")
        void 应复用RequestId() throws Exception {
            String existingId = "existing-request-id-123";
            when(request.getHeader("X-Request-Id")).thenReturn(existingId);

            requestIdFilter.doFilter(request, response, chain);

            verify(request).setAttribute("requestId", existingId);
            verify(response).setHeader("X-Request-Id", existingId);
        }
    }

    @Nested
    @DisplayName("响应头设置")
    class ResponseHeader {

        @Test
        @DisplayName("应在响应头中设置X-Request-Id")
        void 应设置响应头() throws Exception {
            when(request.getHeader("X-Request-Id")).thenReturn(null);

            requestIdFilter.doFilter(request, response, chain);

            verify(response).setHeader(eq("X-Request-Id"), argThat(id -> id != null && !id.isEmpty()));
        }
    }

    @Nested
    @DisplayName("常量验证")
    class Constants {

        @Test
        @DisplayName("ATTR_REQUEST_ID应为requestId")
        void attrRequestId应正确() {
            assertEquals("requestId", RequestIdFilter.ATTR_REQUEST_ID);
        }

        @Test
        @DisplayName("HEADER_REQUEST_ID应为X-Request-Id")
        void headerRequestId应正确() {
            assertEquals("X-Request-Id", RequestIdFilter.HEADER_REQUEST_ID);
        }
    }

    @Nested
    @DisplayName("FilterChain调用")
    class FilterChainInvocation {

        @Test
        @DisplayName("应始终调用chain.doFilter")
        void 应始终调用Chain() throws Exception {
            when(request.getHeader("X-Request-Id")).thenReturn(null);

            requestIdFilter.doFilter(request, response, chain);

            verify(chain).doFilter(request, response);
        }

        @Test
        @DisplayName("chain抛出异常时也应清理MDC")
        void chain抛出异常也应清理MDC() throws Exception {
            when(request.getHeader("X-Request-Id")).thenReturn(null);
            doThrow(new RuntimeException("test")).when(chain).doFilter(request, response);

            assertThrows(RuntimeException.class,
                () -> requestIdFilter.doFilter(request, response, chain));
        }
    }
}
