package com.village.committee.web.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import org.slf4j.MDC;

public class RequestIdFilter implements Filter {

    public static final String ATTR_REQUEST_ID = "requestId";
    public static final String HEADER_REQUEST_ID = "X-Request-Id";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String rid = req.getHeader(HEADER_REQUEST_ID);
        if (rid == null || rid.isBlank()) {
            rid = UUID.randomUUID().toString();
        }

        req.setAttribute(ATTR_REQUEST_ID, rid);
        resp.setHeader(HEADER_REQUEST_ID, rid);

        MDC.put(ATTR_REQUEST_ID, rid);
        try {
            chain.doFilter(request, response);
        } finally {
            MDC.remove(ATTR_REQUEST_ID);
        }
    }
}
