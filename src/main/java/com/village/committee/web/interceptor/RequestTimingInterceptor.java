
package com.village.committee.web.interceptor;

import com.village.committee.service.VisitService;
import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RequestTimingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(RequestTimingInterceptor.class);
    private static final String ATTR_START_NS = "timingStartNs";

    private final VisitService visitService;

    public RequestTimingInterceptor(VisitService visitService) {
        this.visitService = visitService;
    }

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
        Object ridObj = request.getAttribute(RequestIdFilter.ATTR_REQUEST_ID);
        String rid = ridObj == null ? null : String.valueOf(ridObj);

        String method = request.getMethod();
        String uri = request.getRequestURI();
        int status = response.getStatus();

        if (ex != null) {
            log.warn("[{}] {} {} -> {} ({}ms) ex={}", rid, method, uri, status, tookMs, ex.toString());
        } else {
            log.info("[{}] {} {} -> {} ({}ms)", rid, method, uri, status, tookMs);
        }

        // 访问统计：只统计页面 GET（不统计静态资源 / API / 健康检查等）
        if (!"GET".equalsIgnoreCase(method)) return;

        String ctx = request.getContextPath();
        String path = uri;

        if (ctx != null && !ctx.isEmpty() && path.startsWith(ctx)) {
            path = path.substring(ctx.length());
            if (path.isEmpty()) path = "/";
        }

        if (path.startsWith("/static/")) return;
        if (path.startsWith("/api/")) return;
        if (path.startsWith("/db/")) return;

        visitService.record(path, method, status, tookMs, rid);
    }
}
