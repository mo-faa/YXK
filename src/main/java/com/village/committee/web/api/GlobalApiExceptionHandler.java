package com.village.committee.web.api;

import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.time.Instant;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalApiExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiError> handleResponseStatus(ResponseStatusException ex, HttpServletRequest req) {
        int status = ex.getStatusCode().value();
        ApiError body = new ApiError(
                Instant.now(),
                status,
                ex.getStatusCode().toString(),
                ex.getReason(),
                req.getRequestURI(),
                (String) req.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)
        );
        return ResponseEntity.status(status).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleAny(Exception ex, HttpServletRequest req) {
        ApiError body = new ApiError(
                Instant.now(),
                500,
                "INTERNAL_SERVER_ERROR",
                ex.getMessage(),
                req.getRequestURI(),
                (String) req.getAttribute(RequestIdFilter.ATTR_REQUEST_ID)
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }
}

