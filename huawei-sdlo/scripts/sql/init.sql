--=================================================================
-- 华为项目数据库初始化脚本
-- 版本: v1.0
-- 说明: 创建项目所需的所有数据库对象
--=================================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS huawei_sdlo_demo 
    DEFAULT CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE huawei_sdlo_demo;

--=================================================================
-- 1. 用户表
--=================================================================
DROP TABLE IF EXISTS t_user;
CREATE TABLE t_user (
    id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username        VARCHAR(50) NOT NULL COMMENT '用户名',
    password        VARCHAR(128) NOT NULL COMMENT '密码(MD5)',
    real_name       VARCHAR(50) COMMENT '真实姓名',
    phone           VARCHAR(20) COMMENT '手机号',
    email           VARCHAR(100) COMMENT '邮箱',
    avatar          VARCHAR(255) COMMENT '头像URL',
    department      VARCHAR(50) COMMENT '部门',
    position        VARCHAR(50) COMMENT '职位',
    status          TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用 1-正常 2-锁定',
    last_login_time DATETIME COMMENT '最后登录时间',
    create_time     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted         TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0-未删除 1-已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    KEY idx_phone (phone),
    KEY idx_email (email),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

--=================================================================
-- 2. 角色表
--=================================================================
DROP TABLE IF EXISTS t_role;
CREATE TABLE t_role (
    id          BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    role_code   VARCHAR(50) NOT NULL COMMENT '角色编码',
    role_name   VARCHAR(50) NOT NULL COMMENT '角色名称',
    description VARCHAR(255) COMMENT '角色描述',
    status      TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted     TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

--=================================================================
-- 3. 用户角色关联表
--=================================================================
DROP TABLE IF EXISTS t_user_role;
CREATE TABLE t_user_role (
    id          BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    user_id     BIGINT NOT NULL COMMENT '用户ID',
    role_id     BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

--=================================================================
-- 4. 权限表
--=================================================================
DROP TABLE IF EXISTS t_permission;
CREATE TABLE t_permission (
    id           BIGINT NOT NULL AUTO_INCREMENT COMMENT '权限ID',
    perm_code    VARCHAR(100) NOT NULL COMMENT '权限编码',
    perm_name    VARCHAR(50) NOT NULL COMMENT '权限名称',
    perm_type    VARCHAR(20) NOT NULL COMMENT '权限类型: menu, button, api',
    parent_id    BIGINT DEFAULT 0 COMMENT '父权限ID',
    path         VARCHAR(255) COMMENT '路由路径',
    component    VARCHAR(255) COMMENT '组件路径',
    icon         VARCHAR(50) COMMENT '图标',
    sort         INT DEFAULT 0 COMMENT '排序',
    status       TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    create_time  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted      TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_perm_code (perm_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

--=================================================================
-- 5. 角色权限关联表
--=================================================================
DROP TABLE IF EXISTS t_role_permission;
CREATE TABLE t_role_permission (
    id           BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    role_id      BIGINT NOT NULL COMMENT '角色ID',
    perm_id     BIGINT NOT NULL COMMENT '权限ID',
    create_time  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_role_id (role_id),
    KEY idx_perm_id (perm_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

--=================================================================
-- 6. 日志表
--=================================================================
DROP TABLE IF EXISTS t_oper_log;
CREATE TABLE t_oper_log (
    id              BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    oper_module     VARCHAR(50) COMMENT '操作模块',
    oper_type       VARCHAR(50) COMMENT '操作类型',
    oper_desc       VARCHAR(255) COMMENT '操作描述',
    request_method  VARCHAR(10) COMMENT '请求方法',
    request_url     VARCHAR(255) COMMENT '请求URL',
    request_params  TEXT COMMENT '请求参数',
    response_result TEXT COMMENT '返回结果',
    oper_user_id    BIGINT COMMENT '操作用户ID',
    oper_user_name  VARCHAR(50) COMMENT '操作用户名',
    oper_ip         VARCHAR(50) COMMENT '操作IP',
    oper_time       DATETIME COMMENT '操作时间',
    cost_time       BIGINT COMMENT '耗时(毫秒)',
    PRIMARY KEY (id),
    KEY idx_oper_user_id (oper_user_id),
    KEY idx_oper_time (oper_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

--=================================================================
-- 7. 配置表
--=================================================================
DROP TABLE IF EXISTS t_config;
CREATE TABLE t_config (
    id          BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    config_key  VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value VARCHAR(500) NOT NULL COMMENT '配置值',
    config_type VARCHAR(20) DEFAULT 'string' COMMENT '配置类型: string, number, boolean, json',
    config_desc VARCHAR(255) COMMENT '配置描述',
    status      TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用 1-启用',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

--=================================================================
-- 8. 初始化数据
--=================================================================

-- 插入默认角色
INSERT INTO t_role (role_code, role_name, description) VALUES
('ADMIN', '系统管理员', '拥有所有权限'),
('USER', '普通用户', '基本使用权限'),
('GUEST', '访客', '只读权限');

-- 插入默认用户 (密码: admin123)
INSERT INTO t_user (username, password, real_name, phone, email, department, position, status) VALUES
('admin', '0192023a7bbd73250516f069df18b500', '系统管理员', '13800000001', 'admin@huawei.com', '技术部', '经理', 1),
('test', '0192023a7bbd73250516f069df18b500', '测试用户', '13800000002', 'test@huawei.com', '测试部', '测试工程师', 1);

-- 插入默认配置
INSERT INTO t_config (config_key, config_value, config_type, config_desc) VALUES
('system.name', '华为软件交付Demo系统', 'string', '系统名称'),
('system.version', 'v1.0.0', 'string', '系统版本'),
('system.debug', 'true', 'boolean', '调试模式'),
('upload.maxSize', '10485760', 'number', '文件上传大小限制(字节)'),
('upload.allowedTypes', 'jpg,png,pdf,doc,docx', 'string', '允许的文件类型'),
('login.maxRetry', '5', 'number', '登录最大重试次数'),
('login.lockDuration', '1800', 'number', '登录锁定时长(秒)');

--=================================================================
-- 9. 创建索引
--=================================================================
CREATE INDEX idx_user_create_time ON t_user(create_time);
CREATE INDEX idx_role_create_time ON t_role(create_time);
CREATE INDEX idx_log_oper_time ON t_oper_log(oper_time);

--=================================================================
-- 10. 验证
--=================================================================
SELECT '数据库初始化完成!' AS message;
SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema = 'huawei_sdlo_demo';