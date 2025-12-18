package com.village.committee.web.interceptor;

import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

public class RequestTimingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(RequestTimingInterceptor.class);
    private static final String ATTR_START_NS = "timingStartNs";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        request.setAttribute(ATTR_START_NS, System.nanoTime());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        Object startObj = request.getAttribute(ATTR_START_NS);
        if (!(startObj instanceof Long start)) return;

        long tookMs = (System.nanoTime() - start) / 1_000_000L;
        Object rid = request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID);

        String method = request.getMethod();
        String uri = request.getRequestURI();
        int status = response.getStatus();

        if (ex != null) {
            log.warn("[{}] {} {} -> {} ({}ms) ex={}", rid, method, uri, status, tookMs, ex.toString());
        } else {
            log.info("[{}] {} {} -> {} ({}ms)", rid, method, uri, status, tookMs);
        }
    }
}
