package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.domain.OperationLog;
import com.village.committee.mapper.OperationLogMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class OperationLogService {

    private static final String DEFAULT_OPERATOR = "SYSTEM";

    private final OperationLogMapper operationLogMapper;

    public OperationLogService(OperationLogMapper operationLogMapper) {
        this.operationLogMapper = operationLogMapper;
    }

    @Transactional
    public void log(HttpServletRequest request,
                    String operationType,
                    String targetType,
                    Long targetId,
                    String description) {

        OperationLog log = new OperationLog();
        log.setOperator(resolveOperator(request));
        log.setOperationType(operationType);
        log.setTargetType(targetType);
        log.setTargetId(targetId);
        log.setDescription(description);
        log.setIpAddress(resolveClientIp(request));
        log.setUserAgent(resolveUserAgent(request));
        log.setCreatedAt(LocalDateTime.now());

        operationLogMapper.insert(log);
    }

    @Transactional(readOnly = true)
    public List<OperationLog> list() {
        return operationLogMapper.findAll();
    }

    @Transactional(readOnly = true)
    public OperationLog get(Long id) {
        return operationLogMapper.findById(id);
    }

    @Transactional(readOnly = true)
    public PageResult<OperationLog> page(String q, String operationType, String targetType,
                                          Integer page, Integer size) {
        String query = Paging.normalizeQuery(q);
        String opType = Paging.normalizeQuery(operationType);
        String tgType = Paging.normalizeQuery(targetType);
        int p = Paging.normalizePage(page);
        int s = Paging.normalizeSize(size, 20, 100);

        long total = operationLogMapper.count(query, opType, tgType);
        int offset = Paging.offset(p, s);

        if (total > 0 && offset >= total) {
            return new PageResult<>(List.of(), p, s, total);
        }

        List<OperationLog> items = operationLogMapper.findPage(query, opType, tgType, offset, s);
        return new PageResult<>(items, p, s, total);
    }

    @Transactional(readOnly = true)
    public List<OperationLog> latest(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        if (limit > 100) {
            limit = 100;
        }
        return operationLogMapper.findLatest(limit);
    }

    @Transactional(readOnly = true)
    public long countSince(LocalDateTime from) {
        return operationLogMapper.countSince(from);
    }

    @Transactional(readOnly = true)
    public long countToday() {
        LocalDateTime startOfToday = LocalDateTime.now()
                .withHour(0).withMinute(0).withSecond(0).withNano(0);
        return operationLogMapper.countSince(startOfToday);
    }

    @Transactional(readOnly = true)
    public List<String> getOperationTypes() {
        return operationLogMapper.findDistinctOperationTypes();
    }

    @Transactional(readOnly = true)
    public List<String> getTargetTypes() {
        return operationLogMapper.findDistinctTargetTypes();
    }

    @Transactional(readOnly = true)
    public long countAll() {
        return operationLogMapper.countAll();
    }

    @Transactional(readOnly = true)
    public long countByOperationType(String operationType) {
        return operationLogMapper.countByOperationType(operationType);
    }

    @Transactional(readOnly = true)
    public long countByTargetType(String targetType) {
        return operationLogMapper.countByTargetType(targetType);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getRecentOperationStats(int days) {
        return operationLogMapper.getRecentOperationStats(days);
    }

    private String resolveOperator(HttpServletRequest request) {
        if (request == null) {
            return DEFAULT_OPERATOR;
        }

        String remoteUser = request.getRemoteUser();
        if (StringUtils.hasText(remoteUser)) {
            return remoteUser.trim();
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object u1 = session.getAttribute("username");
            if (u1 != null && StringUtils.hasText(String.valueOf(u1))) {
                return String.valueOf(u1).trim();
            }
            Object u2 = session.getAttribute("user");
            if (u2 != null && StringUtils.hasText(String.valueOf(u2))) {
                return String.valueOf(u2).trim();
            }
        }

        String headerOp = request.getHeader("X-Operator");
        if (StringUtils.hasText(headerOp)) {
            return headerOp.trim();
        }

        return DEFAULT_OPERATOR;
    }

    private String resolveClientIp(HttpServletRequest request) {
        if (request == null) {
            return "";
        }

        String xff = request.getHeader("X-Forwarded-For");
        if (StringUtils.hasText(xff)) {
            String first = xff.split(",")[0].trim();
            if (StringUtils.hasText(first)) {
                return first;
            }
        }

        String realIp = request.getHeader("X-Real-IP");
        if (StringUtils.hasText(realIp)) {
            return realIp.trim();
        }

        String ra = request.getRemoteAddr();
        return ra == null ? "" : ra;
    }

    private String resolveUserAgent(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        String ua = request.getHeader("User-Agent");
        return ua == null ? "" : ua;
    }
}
