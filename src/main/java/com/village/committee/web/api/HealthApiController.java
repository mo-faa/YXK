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
        m.put("status", "UP");
        m.put("time", Instant.now().toString());

        try {
            String db = healthMapper.ping();
            m.put("db", "UP");
            m.put("dbPing", db);
        } catch (Exception ex) {
            m.put("db", "DOWN");
            m.put("dbError", ex.getClass().getSimpleName() + ": " + ex.getMessage());
        }
        return m;
    }
}
