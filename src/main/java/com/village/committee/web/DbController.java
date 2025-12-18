package com.village.committee.web;

import com.village.committee.mapper.HealthMapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/db")
public class DbController {

    private final HealthMapper healthMapper;

    public DbController(HealthMapper healthMapper) {
        this.healthMapper = healthMapper;
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
}
