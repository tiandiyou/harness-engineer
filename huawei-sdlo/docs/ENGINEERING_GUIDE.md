# 华为软件交付工程使用指南

> 本文档适用于开发团队、测试团队、项目经理  
> 版本: v1.0 | 更新: 2026-04-07

---

## 第一章：环境准备

### 1.1 开发环境搭建

#### JDK 17 安装
```bash
# 检查Java版本
java -version

# 安装JDK 17 (Ubuntu)
sudo apt update
sudo apt install openjdk-17-jdk

# 验证
java -version
# 输出: openjdk version "17.0.x"
```

#### Maven 安装
```bash
# 安装Maven
sudo apt install maven

# 验证
mvn -version
```

#### Git 配置
```bash
# 配置Git
git config --global user.name "Your Name"
git config --global user.email "your.email@huawei.com"

# 生成SSH密钥
ssh-keygen -t rsa -C "your.email@huawei.com"

# 添加到GitLab/GitHub
cat ~/.ssh/id_rsa.pub
# 将公钥添加到Git平台
```

### 1.2 IDE 配置

#### IntelliJ IDEA 推荐配置
```
Settings → Editor
├── Code Style → Java → 导入华为代码规范
├── Inspections → 开启所有检查
├── Version Control → 配置Git
└── Build → Maven → 配置阿里云镜像

Settings → Plugins
├── Lombok
├── SonarLint
└── GitToolBox
```

#### VS Code 推荐插件
```
- Java Extension Pack
- Maven for Java
- SonarLint
- GitLens
- Prettier
```

### 1.3 开发工具安装

```bash
# Docker Desktop (Windows/Mac)
下载: https://www.docker.com/products/docker-desktop

# Kubernetes (可选)
下载: https://kubernetes.io/docs/tasks/tools/

# PostgreSQL / MySQL
sudo apt install postgresql mysql-server

# Redis
sudo apt install redis-server

# Nginx
sudo apt install nginx
```

---

## 第二章：项目初始化

### 2.1 从模板创建项目

```bash
# 方式1: 从模板创建 (推荐)
git clone https://gitlab.huawei.com/templates/spring-boot-template.git
cd spring-boot-template
rm -rf .git
git init
git add .
git commit -m "chore: 初始化项目"

# 方式2: 手动创建
mkdir -p src/main/java/com/huawei/project
mkdir -p src/main/resources
mkdir -p src/test/java
```

### 2.2 项目结构示例

```
项目目录结构 (Spring Boot)
├── src/
│   ├── main/
│   │   ├── java/com/huawei/{project}/
│   │   │   ├── controller/      # REST接口
│   │   │   ├── service/          # 业务逻辑
│   │   │   ├── mapper/           # 数据访问
│   │   │   ├── entity/           # 数据实体
│   │   │   ├── dto/              # 数据传输对象
│   │   │   ├── config/           # 配置类
│   │   │   └── common/           # 公共组件
│   │   └── resources/
│   │       ├── mapper/           # MyBatis映射
│   │       ├── application.yml   # 应用配置
│   │       └── logback-spring.xml
│   └── test/
│       ├── java/                 # 单元测试
│       └── resources/
│           └── application-test.yml
├── docs/
│   ├── design/                   # 设计文档
│   ├── api/                      # API文档
│   └── test/                     # 测试文档
├── scripts/
│   ├── deploy/                   # 部署脚本
│   ├── sql/                      # 数据库脚本
│   └── tools/                    # 工具脚本
├── pom.xml
└── README.md
```

### 2.3 配置文件说明

#### application.yml (开发环境)
```yaml
server:
  port: 8080

spring:
  application:
    name: huawei-sdlo-demo
  profiles:
    active: dev
  datasource:
    url: jdbc:mysql://localhost:3306/demo?useUnicode=true
    username: root
    password: root
  redis:
    host: localhost
    port: 6379

# 日志配置
logging:
  level:
    com.huawei: DEBUG
    org.springframework: INFO
  file:
    name: logs/app.log
```

#### application-dev.yml (开发)
```yaml
spring:
  datasource:
    url: jdbc:mysql://dev-db.huawei.com:3306/demo
```

#### application-test.yml (测试)
```yaml
spring:
  datasource:
    url: jdbc:mysql://test-db.huawei.com:3306/demo
```

#### application-prod.yml (生产)
```yaml
spring:
  datasource:
    url: jdbc:mysql://prod-db.huawei.com:3306/demo
```

---

## 第三章：Git工作流

### 3.1 分支策略

```bash
# 1. 克隆仓库
git clone https://gitlab.huawei.com/team/project.git
cd project

# 2. 创建功能分支
git checkout -b feature/REQ-001-user-login

# 3. 开发并提交
git add .
git commit -m "feat: 实现用户登录功能"

# 4. 定期同步主分支
git fetch origin
git rebase origin/develop

# 5. 推送并创建MR
git push -u origin feature/REQ-001-user-login
```

### 3.2 提交规范

```
提交信息格式: <type>(<scope>): <subject>

类型(type):
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试
- chore: 构建/工具

示例:
feat(auth): 实现手机号验证码登录
fix(order): 修复订单查询超时问题
docs(api): 更新API文档
```

### 3.3 代码审查流程

```
1. 本地开发完成
   ↓
2. 提交到远程分支
   ↓
3. 创建Merge Request (MR)
   ↓
4. 至少2人代码审查
   ↓
5. 修改审查意见 (如有)
   ↓
6. 合并到develop分支
   ↓
7. 自动触发CI/CD
```

---

## 第四章：开发规范

### 4.1 代码规范检查

```bash
# 在项目根目录执行
mvn checkstyle:check

# 启用IDE实时检查
# IntelliJ: Settings → Editor → Inspections → Checkstyle
```

#### checkstyle规则 (华为版)
```xml
<!-- checkstyle.xml -->
<module name="Checker">
    <module name="TreeWalker">
        <!-- 命名规范 -->
        <module name="ConstantName"/>
        <module name="LocalFinalVariableName"/>
        <module name="LocalVariableName"/>
        <module name="MemberName"/>
        <module name="MethodName"/>
        <module name="PackageName"/>
        <module name="ParameterName"/>
        <module name="StaticVariableName"/>
        <module name="TypeName"/>
        
        <!-- 格式规范 -->
        <module name="Indentation"/>
        <module name="LineLength">
            <property name="max" value="120"/>
        </module>
        <module name="WhitespaceAfter"/>
        <module name="WhitespaceAround"/>
    </module>
</module>
```

### 4.2 单元测试编写

```java
// 示例: UserService单元测试
@SpringBootTest
class UserServiceTest {
    
    @Autowired
    private UserService userService;
    
    @MockBean
    private UserMapper userMapper;
    
    @Test
    void testGetUserById() {
        // Arrange
        Long userId = 1L;
        User expectedUser = new User();
        expectedUser.setId(userId);
        expectedUser.setName("Test User");
        when(userMapper.selectById(userId)).thenReturn(expectedUser);
        
        // Act
        User result = userService.getUserById(userId);
        
        // Assert
        assertNotNull(result);
        assertEquals(userId, result.getId());
        assertEquals("Test User", result.getName());
    }
    
    @Test
    void testCreateUser() {
        // Arrange
        User user = new User();
        user.setName("New User");
        user.setEmail("new@huawei.com");
        
        when(userMapper.insert(user)).thenReturn(1);
        
        // Act
        boolean result = userService.createUser(user);
        
        // Assert
        assertTrue(result);
        verify(userMapper, times(1)).insert(user);
    }
}
```

### 4.3 运行测试

```bash
# 运行所有单元测试
mvn test

# 运行单个测试类
mvn test -Dtest=UserServiceTest

# 运行单个测试方法
mvn test -Dtest=UserServiceTest#testGetUserById

# 生成测试报告
mvn test surefire-report:report

# 查看报告
open target/site/surefire-report.html
```

---

## 第五章：接口开发

### 5.1 REST接口规范

```java
// 示例: 用户Controller
@RestController
@RequestMapping("/api/v1/users")
@Api(tags = "用户管理")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/{id}")
    @ApiOperation("根据ID获取用户")
    @ApiImplicitParam(name = "id", value = "用户ID", paramType = "path")
    public Result<User> getUser(@PathVariable Long id) {
        User user = userService.getUserById(id);
        return Result.success(user);
    }
    
    @PostMapping
    @ApiOperation("创建用户")
    public Result<Long> createUser(@RequestBody @Valid UserCreateDTO dto) {
        Long id = userService.createUser(dto);
        return Result.success(id);
    }
    
    @PutMapping("/{id}")
    @ApiOperation("更新用户")
    public Result<Void> updateUser(
            @PathVariable Long id,
            @RequestBody @Valid UserUpdateDTO dto) {
        userService.updateUser(id, dto);
        return Result.success();
    }
    
    @DeleteMapping("/{id}")
    @ApiOperation("删除用户")
    public Result<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.success();
    }
}
```

### 5.2 接口文档 (Swagger)

```yaml
# Swagger配置
springfox:
  documentation:
    enabled: true
    swagger:
      v2:
        path: /v2/api-docs
```

访问: `http://localhost:8080/swagger-ui.html`

---

## 第六章：数据库开发

### 6.1 数据库设计规范

```sql
-- 示例: 用户表
CREATE TABLE `t_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(128) NOT NULL COMMENT '密码',
  `phone` VARCHAR(20) COMMENT '手机号',
  `email` VARCHAR(100) COMMENT '邮箱',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0-未删除, 1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_phone` (`phone`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
```

### 6.2 MyBatis使用

```java
// Mapper接口
@Mapper
public interface UserMapper {
    
    @Select("SELECT * FROM t_user WHERE id = #{id}")
    User selectById(Long id);
    
    @Insert("INSERT INTO t_user(username, password, phone, email) " +
            "VALUES(#{username}, #{password}, #{phone}, #{email})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);
    
    @Update("UPDATE t_user SET username=#{username}, phone=#{phone} WHERE id=#{id}")
    int update(User user);
    
    @Delete("DELETE FROM t_user WHERE id = #{id}")
    int deleteById(Long id);
}
```

### 6.3 数据迁移 (Flyway)

```
src/main/resources/db/migration/
├── V1__init_schema.sql
├── V2__add_user_table.sql
└── V3__alter_user_table.sql
```

```yaml
# application.yml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
```

---

## 第七章：自动化测试

### 7.1 接口自动化测试

```java
// REST-assured测试示例
@Test
class UserApiTest {
    
    private static RequestSpecification spec;
    
    @BeforeAll
    static void setup() {
        spec = new RequestSpecBuilder()
            .setBaseUri("http://localhost:8080")
            .setBasePath("/api/v1")
            .setContentType(ContentType.JSON)
            .build();
    }
    
    @Test
    void testCreateUser() {
        given(spec)
            .body("{\"username\":\"test\",\"password\":\"123456\"}")
            .when()
            .post("/users")
            .then()
            .statusCode(200)
            .body("code", equalTo(0))
            .body("data.id", notNullValue());
    }
    
    @Test
    void testGetUser() {
        given(spec)
            .when()
            .get("/users/1")
            .then()
            .statusCode(200)
            .body("code", equalTo(0));
    }
}
```

### 7.2 UI自动化测试

```java
// Selenium测试示例
@Test
class LoginPageTest {
    
    private WebDriver driver;
    
    @BeforeEach
    void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
    }
    
    @Test
    void testLoginSuccess() {
        driver.get("http://localhost:8080/login");
        
        driver.findElement(By.id("username")).sendKeys("admin");
        driver.findElement(By.id("password")).sendKeys("123456");
        driver.findElement(By.id("loginBtn")).click();
        
        assertTrue(driver.getCurrentUrl().contains("/home"));
    }
    
    @AfterEach
    void tearDown() {
        driver.quit();
    }
}
```

### 7.3 运行自动化测试

```bash
# 运行所有测试
mvn test

# 运行单元测试
mvn test -Dtest=*Test

# 运行集成测试
mvn verify -DskipUnitTests=true

# 运行UI测试
mvn test -Dtest=*PageTest -Dbrowser=chrome
```

---

## 第八章：持续集成/部署

### 8.1 Jenkins配置

```bash
# 1. 安装Jenkins
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins jenkins/jenkins:lts

# 2. 安装必要插件
# Manage Jenkins → Plugin Manager
# 安装: Maven Integration, Git, Pipeline, SonarQube Scanner

# 3. 配置Maven
# Manage Jenkins → Global Tool Configuration → Maven
# 安装: Maven 3.8+
```

### 8.2 Jenkinsfile

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                junit 'target/surefire-reports/*.xml'
            }
        }
        
        stage('SonarQube') {
            steps {
                sh 'mvn sonar:sonar'
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
```

### 8.3 Docker部署

```dockerfile
# Dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```bash
# 构建镜像
docker build -t huawei-sdlo-demo:latest .

# 运行容器
docker run -d -p 8080:8080 --name sdlo-demo huawei-sdlo-demo:latest
```

### 8.4 Kubernetes部署

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: huawei-sdlo-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: huawei-sdlo-demo
  template:
    metadata:
      labels:
        app: huawei-sdlo-demo
    spec:
      containers:
      - name: app
        image: huawei-sdlo-demo:latest
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: "1000m"
            memory: "1Gi"
          requests:
            cpu: "500m"
            memory: "512Mi"
```

---

## 第九章：监控与运维

### 9.1 日志配置

```xml
<!-- logback-spring.xml -->
<configuration>
    <property name="LOG_PATH" value="logs"/>
    
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_PATH}/app.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_PATH}/app.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <logger name="com.huawei" level="DEBUG"/>
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/>
    </root>
</configuration>
```

### 9.2 监控配置

```yaml
# Prometheus配置
# prometheus.yml
scrape_configs:
  - job_name: 'huawei-sdlo-demo'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['localhost:8080']
```

```yaml
# Spring Boot配置
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
```

### 9.3 健康检查

```java
// 健康检查接口
@RestController
public class HealthController {
    
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> result = new HashMap<>();
        result.put("status", "UP");
        result.put("timestamp", Instant.now().toString());
        return ResponseEntity.ok(result);
    }
}
```

---

## 第十章：常见问题处理

### 10.1 开发问题

| 问题 | 解决方案 |
|------|----------|
| 编译失败 | `mvn clean compile` 清理重编译 |
| 依赖冲突 | 检查pom.xml，排除冲突依赖 |
| 测试失败 | 检查测试数据，查看测试报告 |
| 接口404 | 检查Controller路径和端口 |

### 10.2 部署问题

| 问题 | 解决方案 |
|------|----------|
| 启动失败 | 查看logs/app.log日志 |
| 内存溢出 | 增加JVM堆内存 `-Xmx2g` |
| 数据库连接 | 检查数据库配置和网络 |

### 10.3 性能问题

| 问题 | 解决方案 |
|------|----------|
| 接口慢 | 检查SQL，添加索引 |
| CPU高 | 检查死循环或复杂计算 |
| 内存高 | 检查内存泄漏，添加GC日志 |

---

## 附录：快速检查清单

### 开发前检查
- [ ] 开发环境已搭建完成
- [ ] Git仓库已克隆到本地
- [ ] 开发规范已阅读并理解
- [ ] 相关文档已查阅

### 提交前检查
- [ ] 代码编译通过
- [ ] 单元测试通过
- [ ] 代码规范检查通过
- [ ] 提交信息符合规范

### 上线前检查
- [ ] 测试环境验证通过
- [ ] 性能测试通过
- [ ] 安全扫描通过
- [ ] 文档已更新

---

> 📧 如有问题请联系: sdlo-support@huawei.com
> 📅 最后更新: 2026-04-07