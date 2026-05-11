package com.village.committee.web.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Component
public class AuthFilter implements Filter {

    private static final List<String> EXCLUDE_PATHS = Arrays.asList(
        "/login", "/register", "/static/", "/error", "/db/"
    );

    private static final List<String> API_PATHS = Arrays.asList(
        "/api/login", "/api/register", "/api/logout"
    );

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (isExcluded(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            String ajaxHeader = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader)) {
                resp.setStatus(401);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"error\":\"未登录\",\"code\":401}");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + path);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}

    private boolean isExcluded(String path) {
        for (String p : EXCLUDE_PATHS) { if (path.startsWith(p)) return true; }
        for (String p : API_PATHS) { if (path.equals(p)) return true; }
        return false;
    }
}
