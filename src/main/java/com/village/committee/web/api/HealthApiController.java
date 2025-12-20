package com.village.committee.web.api;

import com.village.committee.mapper.HealthMapper;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthApiController {

    private final HealthMapper healthMapper;

    public HealthApiController(HealthMapper healthMapper) {
        this.healthMapper = healthMapper;
    }

    @GetMapping("/api/health")
    public Map<String, Object> health() {
        Map<String, Object> m = new LinkedHashMap<>();
        boolean dbOk = false;

        try {
            String db = healthMapper.ping();
            dbOk = true;
            m.put("dbPing", db);
        } catch (Exception ex) {
            m.put("dbError", ex.getClass().getSimpleName() + ": " + ex.getMessage());
        }

        // 匹配前端期望的格式
        m.put("ok", true); // 应用本身是正常的
        m.put("dbOk", dbOk);
        m.put("version", "1.0.0"); // 添加版本信息
        m.put("uptime", "运行中"); // 添加运行状态信息
        m.put("time", Instant.now().toString());

        return m;
    }
}
