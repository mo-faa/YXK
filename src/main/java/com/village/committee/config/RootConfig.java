package com.village.committee.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@PropertySource("classpath:db.properties")
@EnableTransactionManagement
@MapperScan(basePackages = "com.village.committee.mapper")
@ComponentScan(basePackages = "com.village.committee.service")
public class RootConfig {

    @Bean
    public DataSource dataSource(Environment env) {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(env.getRequiredProperty("db.url"));
        cfg.setUsername(env.getRequiredProperty("db.username"));
        cfg.setPassword(env.getRequiredProperty("db.password"));
        cfg.setDriverClassName(env.getRequiredProperty("db.driverClassName"));

        cfg.setMaximumPoolSize(env.getProperty("db.maxPoolSize", Integer.class, 10));
        cfg.setMinimumIdle(env.getProperty("db.minIdle", Integer.class, 2));

        // 允许应用在 DB 暂不可用时也能启动
        cfg.setInitializationFailTimeout(-1);

        cfg.setPoolName("VillageHikariCP");
        return new HikariDataSource(cfg);
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource ds) {
        return new DataSourceTransactionManager(ds);
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource ds) throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(ds);

        org.apache.ibatis.session.Configuration mybatisCfg = new org.apache.ibatis.session.Configuration();
        mybatisCfg.setMapUnderscoreToCamelCase(true);
        factoryBean.setConfiguration(mybatisCfg);

        SqlSessionFactory factory = factoryBean.getObject();
        if (factory == null) {
            throw new IllegalStateException("SqlSessionFactory is null (unexpected).");
        }
        return factory;
    }

    @Bean
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory factory) {
        return new SqlSessionTemplate(factory);
    }
}

