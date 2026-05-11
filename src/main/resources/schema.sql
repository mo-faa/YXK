-- 先创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS village_committee CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE village_committee;

-- 村民表
CREATE TABLE IF NOT EXISTS residents (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  id_card VARCHAR(18) NULL,
  phone VARCHAR(20) NULL,
  address VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_name (name),
  INDEX idx_id_card (id_card),
  FULLTEXT INDEX ft_search (name, phone, address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 公告表（增加置顶和状态字段）
CREATE TABLE IF NOT EXISTS announcements (
  id BIGINT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  publisher VARCHAR(50) NOT NULL,
  publish_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_top TINYINT(1) DEFAULT 0 COMMENT '是否置顶',
  status TINYINT(1) DEFAULT 1 COMMENT '0-草稿,1-发布',
  PRIMARY KEY (id),
  INDEX idx_status_publish (status, publish_time DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 操作日志表
CREATE TABLE IF NOT EXISTS operation_logs (
  id BIGINT NOT NULL AUTO_INCREMENT,
  operator VARCHAR(50) NOT NULL COMMENT '操作人',
  operation_type VARCHAR(20) NOT NULL COMMENT '操作类型',
  target_type VARCHAR(20) NOT NULL COMMENT '目标类型',
  target_id BIGINT NOT NULL COMMENT '目标ID',
  description TEXT COMMENT '操作描述',
  ip_address VARCHAR(45) NULL,
  user_agent TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_operator_time (operator, created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 村委会成员表
CREATE TABLE IF NOT EXISTS committee_members (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL COMMENT '姓名',
  position VARCHAR(50) NOT NULL COMMENT '职务',
  phone VARCHAR(20) NULL COMMENT '联系电话',
  duties TEXT NULL COMMENT '职责描述',
  join_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '任职时间',
  is_active TINYINT(1) DEFAULT 1 COMMENT '是否在职',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_name (name),
  INDEX idx_position (position),
  INDEX idx_active (is_active),
  INDEX idx_join_time (join_time DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
  id BIGINT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  password_hash VARCHAR(100) NOT NULL COMMENT '密码哈希',
  nickname VARCHAR(50) NULL COMMENT '昵称',
  real_name VARCHAR(50) NULL COMMENT '真实姓名',
  phone VARCHAR(20) NULL COMMENT '手机号',
  email VARCHAR(100) NULL COMMENT '邮箱',
  avatar VARCHAR(255) NULL COMMENT '头像URL',
  enabled TINYINT(1) DEFAULT 1 COMMENT '是否启用',
  login_count INT DEFAULT 0 COMMENT '登录次数',
  last_login_at DATETIME NULL COMMENT '最后登录时间',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_username (username),
  INDEX idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 角色表
CREATE TABLE IF NOT EXISTS sys_role (
  id BIGINT NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
  name VARCHAR(50) NOT NULL COMMENT '角色名称',
  description VARCHAR(200) NULL COMMENT '描述',
  sort_order INT DEFAULT 0 COMMENT '排序',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 权限表
CREATE TABLE IF NOT EXISTS sys_permission (
  id BIGINT NOT NULL AUTO_INCREMENT,
  code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
  name VARCHAR(50) NOT NULL COMMENT '权限名称',
  module VARCHAR(50) NULL COMMENT '所属模块',
  description VARCHAR(200) NULL COMMENT '描述',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_code (code),
  INDEX idx_module (module)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 用户-角色关联表
CREATE TABLE IF NOT EXISTS sys_user_role (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL COMMENT '用户ID',
  role_id BIGINT NOT NULL COMMENT '角色ID',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_role (user_id, role_id),
  INDEX idx_user_id (user_id),
  INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 角色-权限关联表
CREATE TABLE IF NOT EXISTS sys_role_permission (
  id BIGINT NOT NULL AUTO_INCREMENT,
  role_id BIGINT NOT NULL COMMENT '角色ID',
  permission_id BIGINT NOT NULL COMMENT '权限ID',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_role_permission (role_id, permission_id),
  INDEX idx_role_id (role_id),
  INDEX idx_permission_id (permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 消息通知表
CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL COMMENT '接收用户ID',
  title VARCHAR(100) NOT NULL COMMENT '通知标题',
  content TEXT NOT NULL COMMENT '通知内容',
  type VARCHAR(20) DEFAULT 'system' COMMENT '类型: system/announcement/task',
  is_read TINYINT(1) DEFAULT 0 COMMENT '是否已读',
  related_id BIGINT NULL COMMENT '关联ID（公告ID等）',
  related_type VARCHAR(50) NULL COMMENT '关联类型',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at DATETIME NULL COMMENT '阅读时间',
  PRIMARY KEY (id),
  INDEX idx_user_read (user_id, is_read, created_at DESC),
  INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 数据备份记录表
CREATE TABLE IF NOT EXISTS backup_records (
  id BIGINT NOT NULL AUTO_INCREMENT,
  file_name VARCHAR(255) NOT NULL COMMENT '备份文件名',
  file_path VARCHAR(500) NOT NULL COMMENT '文件路径',
  file_size BIGINT NULL COMMENT '文件大小(字节)',
  type VARCHAR(20) NOT NULL COMMENT '备份类型: full/incremental',
  status VARCHAR(20) DEFAULT 'success' COMMENT '状态: success/failed/pending',
  operator VARCHAR(50) NULL COMMENT '操作人',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  finished_at DATETIME NULL COMMENT '完成时间',
  PRIMARY KEY (id),
  INDEX idx_status (status),
  INDEX idx_created (created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
  config_value TEXT NULL COMMENT '配置值',
  config_group VARCHAR(50) NULL COMMENT '配置分组',
  description VARCHAR(200) NULL COMMENT '描述',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_config_key (config_key),
  INDEX idx_group (config_group)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入默认角色
INSERT INTO sys_role (code, name, description, sort_order) VALUES
('ADMIN', '系统管理员', '拥有所有权限', 1),
('MANAGER', '村委会管理员', '管理村务数据', 2),
('USER', '普通用户', '查看基本信息', 3);

-- 插入默认权限
INSERT INTO sys_permission (code, name, module, description) VALUES
('user:view', '查看用户', '用户管理', '查看用户列表和详情'),
('user:edit', '编辑用户', '用户管理', '创建和修改用户'),
('user:delete', '删除用户', '用户管理', '删除用户'),
('resident:view', '查看村民', '村民管理', '查看村民信息'),
('resident:edit', '编辑村民', '村民管理', '添加和修改村民'),
('resident:delete', '删除村民', '村民管理', '删除村民'),
('resident:export', '导出村民', '村民管理', '导出村民数据'),
('announcement:view', '查看公告', '公告管理', '查看公告列表'),
('announcement:edit', '编辑公告', '公告管理', '发布和修改公告'),
('announcement:delete', '删除公告', '公告管理', '删除公告'),
('committee:view', '查看委员', '委员管理', '查看委员信息'),
('committee:edit', '编辑委员', '委员管理', '添加和修改委员'),
('committee:delete', '删除委员', '委员管理', '删除委员'),
('log:view', '查看日志', '日志管理', '查看操作日志'),
('log:export', '导出日志', '日志管理', '导出操作日志'),
('system:config', '系统配置', '系统管理', '管理系统配置'),
('system:backup', '数据备份', '系统管理', '执行数据备份'),
('dashboard:view', '查看仪表盘', '仪表盘', '查看统计仪表盘');

-- 为管理员角色分配所有权限
INSERT INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r CROSS JOIN sys_permission p WHERE r.code = 'ADMIN';

-- 为村委会管理员分配业务权限
INSERT INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.code = 'MANAGER'
AND p.code IN ('resident:view', 'resident:edit', 'resident:export',
                'announcement:view', 'announcement:edit',
                'committee:view', 'committee:edit',
                'log:view', 'log:export', 'dashboard:view');

-- 为普通用户分配基本权限
INSERT INTO sys_role_permission (role_id, permission_id)
SELECT r.id, p.id FROM sys_role r, sys_permission p
WHERE r.code = 'USER'
AND p.code IN ('resident:view', 'announcement:view', 'committee:view', 'dashboard:view');

-- 插入默认管理员账号 (密码: admin123，使用BCrypt加密)
INSERT INTO sys_user (username, password_hash, nickname, real_name, enabled, login_count) VALUES
('admin', '$2b$12$ndhZsY0Loz6GwBI4IP0GfueTBP3gD0ZclRnlScqT9wnL4v7.w6IEO', '系统管理员', '管理员', 1, 0);

-- 为管理员分配角色
INSERT INTO sys_user_role (user_id, role_id)
SELECT u.id, r.id FROM sys_user u, sys_role r WHERE u.username = 'admin' AND r.code = 'ADMIN';

-- 插入默认系统配置
INSERT INTO system_config (config_key, config_value, config_group, description) VALUES
('site.name', '网上村委会', 'basic', '站点名称'),
('site.description', '智慧村务管理系统', 'basic', '站点描述'),
('site.logo', '', 'basic', '站点Logo'),
('notification.enabled', 'true', 'notification', '是否启用通知'),
('notification.email', 'false', 'notification', '邮件通知'),
('backup.auto', 'false', 'backup', '自动备份'),
('backup.interval', '7', 'backup', '备份间隔(天)'),
('security.session_timeout', '30', 'security', '会话超时时间(分钟)');
