package com.village.committee.web;

import com.village.committee.mapper.HealthMapper;
import com.village.committee.config.DatabaseInitializer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/db")
public class DbController {

    private final HealthMapper healthMapper;
    private final DatabaseInitializer databaseInitializer;

    public DbController(HealthMapper healthMapper, DatabaseInitializer databaseInitializer) {
        this.healthMapper = healthMapper;
        this.databaseInitializer = databaseInitializer;
    }

    @GetMapping(value = "/ping", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String ping() {
        try {
            return "DB ping result: " + healthMapper.ping();
        } catch (Exception ex) {
            return "DB ping failed: " + ex.getClass().getSimpleName() + " - " + ex.getMessage();
        }
    }
    
    @GetMapping(value = "/init", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String initDatabase() {
        try {
            // 手动触发数据库初始化
            databaseInitializer.init();
            return "Database initialization completed successfully";
        } catch (Exception ex) {
            return "Database initialization failed: " + ex.getClass().getSimpleName() + " - " + ex.getMessage();
        }
    }
}
