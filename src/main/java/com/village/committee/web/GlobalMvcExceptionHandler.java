package com.village.committee.web;

import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.server.ResponseStatusException;

@ControllerAdvice(annotations = Controller.class)
public class GlobalMvcExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public String handleRse(ResponseStatusException ex, HttpServletRequest req, HttpServletResponse resp, Model model) {
        int status = ex.getStatusCode().value();
        resp.setStatus(status);

        model.addAttribute("status", status);
        model.addAttribute("error", ex.getStatusCode().toString());
        model.addAttribute("message", ex.getReason());
        model.addAttribute("path", req.getRequestURI());
        model.addAttribute("requestId", req.getAttribute(RequestIdFilter.ATTR_REQUEST_ID));
        return "error";
    }

    @ExceptionHandler(Exception.class)
    public String handleAny(Exception ex, HttpServletRequest req, HttpServletResponse resp, Model model) {
        resp.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());

        model.addAttribute("status", 500);
        model.addAttribute("error", "INTERNAL_SERVER_ERROR");
        model.addAttribute("message", ex.getMessage());
        model.addAttribute("path", req.getRequestURI());
        model.addAttribute("requestId", req.getAttribute(RequestIdFilter.ATTR_REQUEST_ID));
        return "error";
    }
}
