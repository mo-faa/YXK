package com.village.committee.web.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class CsrfTokenFilter implements Filter {

    private static final String SESSION_KEY = "CSRF_TOKEN";
    private static final String PARAM = "_csrf";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI();
        // API 端不做 CSRF，方便你直接 curl / Postman 测试
        if (path != null && path.startsWith(req.getContextPath() + "/api/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(true);
        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null || token.isBlank()) {
            token = UUID.randomUUID().toString().replace("-", "");
            session.setAttribute(SESSION_KEY, token);
        }

        // JSP 直接用 ${_csrf}
        req.setAttribute(PARAM, token);

        String method = req.getMethod();
        if (isStateChanging(method)) {
            String got = req.getParameter(PARAM);
            if (got == null || got.isBlank()) {
                got = req.getHeader("X-CSRF-TOKEN");
            }
            if (got == null || !token.equals(got)) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
                resp.setContentType("text/plain; charset=UTF-8");
                resp.getWriter().write("Forbidden (CSRF token missing or invalid)");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isStateChanging(String method) {
        if (method == null) return false;
        return switch (method) {
            case "POST", "PUT", "DELETE", "PATCH" -> true;
            default -> false;
        };
    }
}
