
package com.village.committee.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

/**
 * 数据库初始化器
 * 在应用启动时自动创建数据库和表
 */
@Component
public class DatabaseInitializer {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseInitializer.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostConstruct
    public void init() {
        try {
            logger.info("开始初始化数据库...");

            // 读取schema.sql文件
            ClassPathResource resource = new ClassPathResource("schema.sql");
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {

                // 读取整个SQL文件内容
                String sql = reader.lines().collect(Collectors.joining("\n"));
                
                // 分割SQL语句
                String[] statements = sql.split(";\s*\n");
                
                // 逐个执行SQL语句
                for (String statement : statements) {
                    if (!statement.trim().isEmpty()) {
                        jdbcTemplate.execute(statement);
                    }
                }

                logger.info("数据库初始化完成");
            }
        } catch (Exception e) {
            logger.error("数据库初始化失败", e);
        }
    }
}
