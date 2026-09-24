# 网上村委会业务办理系统（毕业设计）

> 天津仁爱学院 计算机科学与技术 · 毕业设计 · 于翔堃
>
> 面向村委会日常事务的办理系统：居民档案、公告发布、村委会成员、通知提醒、操作留痕、权限与角色、Excel 导出、系统配置与备份。

![语言](https://img.shields.io/badge/Java-25-blue?style=flat-square)
![框架](https://img.shields.io/badge/Spring%20MVC-7.0.2%20%28%E5%8E%9F%E7%94%9F%EF%BC%8C%E9%9D%9E%20Boot%29-6db33f?style=flat-square)
![持久层](https://img.shields.io/badge/MyBatis-3.5.19-orange?style=flat-square)
![测试](https://img.shields.io/badge/%E5%8D%95%E5%85%83%E6%B5%8B%E8%AF%95-362%20%E4%B8%AA-brightgreen?style=flat-square)

## 项目规模（实测，命令可复核）

| 指标 | 数值 | 怎么数出来的 |
| :--- | :--- | :--- |
| Java 源文件 | 93 个 | `find src -name "*.java" \| wc -l`（含测试 34 个） |
| 数据库表 | 12 张 | `src/main/resources/schema.sql` 中的 `CREATE TABLE` |
| 请求映射 | 80 处 | `@RequestMapping` / `@GetMapping` 等注解统计 |
| 单元测试 | **362 个**（358 `@Test` + 4 `@ParameterizedTest`） | `grep -rhoE "@Test" src/test \| wc -l` |
| 测试类 | 34 个，覆盖 domain / service / web / filter | `src/test/java/com/village/committee/` |

## 技术栈

- **后端**：Java 25 · Spring Framework 7.0.2（`spring-webmvc`，**未使用 Spring Boot**，全部 XML/Java 配置手写）· MyBatis 3.5.19 + mybatis-spring 4.0 · Spring JDBC/Tx
- **安全**：Spring Security Crypto（BCrypt 口令加密）· 自写 `CsrfTokenFilter`（HMAC-SHA256 令牌）· `AuthFilter` 会话校验 · RBAC（`sys_user` / `sys_role` / `sys_permission` 三表 + 两张关联表）
- **数据**：MySQL 8（驱动 9.5.0）· HikariCP 7.0.2 连接池；测试用 H2 2.3.232
- **视图**：JSP 4.0 + JSTL 3.0.1（页面在 `src/main/webapp/WEB-INF/views/`）
- **导出**：Apache POI 5.2.5，Excel 流式导出并对**证件号脱敏**
- **测试**：JUnit 5 + Mockito 5.18 + Spring Test（MockMvc）+ AssertJ；`--add-opens` 适配 JDK 25 模块封装
- **部署**：`gradle war` 打 WAR 包，运行在 Tomcat 11（Servlet 6.1 / JSP 4.0）

## 功能模块

| 模块 | 说明 | 入口 |
| :--- | :--- | :--- |
| 居民档案 | 居民信息 CRUD、分页查询、校验 | `web/ResidentController`、`web/api/ResidentApiController` |
| 公告管理 | 公告发布、列表、详情 | `web/AnnouncementController` |
| 村委会成员 | 成员信息与任期管理 | `web/CommitteeMemberController` |
| 通知提醒 | 站内通知 | `domain/Notification`、`service/NotificationService` |
| 操作留痕 | 全量操作日志，可追溯 | `web/OperationLogController` |
| 用户与权限 | 用户/角色/权限 RBAC、登录鉴权 | `web/UserController`、`web/AuthController` |
| 系统配置与备份 | 系统参数、备份记录 | `web/SystemController`、`service/BackupService` |
| Excel 导出 | POI 流式导出，证件号脱敏 | `web/ExportController`、`service/ExportService` |

## 目录结构

```
src/
├── main/java/com/village/committee/
│   ├── common/       # 分页、校验、统一返回结果
│   ├── config/       # Spring / MyBatis / 数据源配置
│   ├── domain/       # 实体（12 张表一一对应）
│   ├── mapper/       # MyBatis Mapper 接口
│   ├── service/      # 业务逻辑
│   └── web/          # 页面控制器 + /api REST 控制器 + 过滤器
├── main/resources/   # schema.sql（建表）、db.properties（数据源）
├── main/webapp/      # JSP 视图 + 静态资源
└── test/java/...     # 34 个测试类 / 362 个用例
```

## 本地运行

```bash
# 1. 准备数据库
mysql -u root -p < src/main/resources/schema.sql
# 2. 配置数据源（src/main/resources/db.properties）
# 3. 跑测试（H2 内存库，无需 MySQL）
./gradlew test
# 4. 打 WAR 包，部署到 Tomcat 11
./gradlew war
```

## 如实说明

- 这是**课程毕业设计**，不是企业生产环境代码；AI 编程工具是我的日常工具链，架构、模块拆分、接口契约、测试与集成验证由我负责。
- 作者其他（AI Agent 方向的）原创项目见 👉 [mo-faa/jianli](https://github.com/mo-faa/jianli)。

---

**于翔堃 · 2026 届 · 现居天津 · 邮箱 3062949899@qq.com**
