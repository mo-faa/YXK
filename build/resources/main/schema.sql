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
