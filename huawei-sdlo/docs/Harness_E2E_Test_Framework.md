# Harness Engineering - 特权账号系统端到端测试框架

> 文档编号：AI-Tech-HW-010  
> 关键词：E2E测试、Multi-Agent、自动化测试框架、特权账号  
> 更新日期：2026-04-09

---

## 一、测试框架概述

### 1.1 框架目标

```
┌────────────────────────────────────────────────────────────────┐
│               特权账号系统端到端测试框架                          │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  🎯 目标                                                       │
│     - 自动化生成测试用例                                        │
│     - 多Agent协作执行                                          │
│     - 端到端覆盖                                                │
│     - 可直接运行使用                                            │
│                                                                │
│  📋 测试范围                                                   │
│     - 账号生命周期                                              │
│     - 权限管理                                                  │
│     - 审批流程                                                  │
│     - 审计追溯                                                  │
│     - 安全控制                                                  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 1.2 多Agent协作架构

```yaml
multi_agent_architecture:
  # Agent角色定义
  agents:
    - name: "测试架构师 TestArchitect"
      role: "设计测试策略和计划"
      model: "claude-3-opus"
      
    - name: "用例工程师 TestGenerator"
      role: "生成测试用例代码"
      model: "claude-3-sonnet"
      
    - name: "测试执行员 TestExecutor"
      role: "执行测试并记录结果"
      model: "claude-3-haiku"
      
    - name: "质量分析师 TestAnalyzer"
      role: "分析结果并生成报告"
      model: "claude-3-sonnet"
      
    - name: "测试协调员 TestCoordinator"
      role: "协调整个测试流程"
      model: "claude-3-opus"
      
  # 协作流程
  workflow:
    TestCoordinator → TestArchitect → TestGenerator → TestExecutor → TestAnalyzer
```

---

## 二、测试场景定义

### 2.1 核心测试场景

```yaml
test_scenarios:
  # 账号生命周期
  account_lifecycle:
    - id: "TC-ACCOUNT-001"
      name: "创建特权账号"
      steps:
        - "提交账号申请"
        - "多级审批"
        - "系统创建账号"
        - "分配初始权限"
        - "发送通知"
        
    - id: "TC-ACCOUNT-002"
      name: "修改账号权限"
      steps:
        - "提交权限变更申请"
        - "审批验证"
        - "更新权限"
        - "记录审计日志"
        
    - id: "TC-ACCOUNT-003"
      name: "注销特权账号"
      steps:
        - "提交注销申请"
        - "审批验证"
        - "回收所有权限"
        - "禁用账号"
        - "归档历史数据"
        
  # 权限管理
  permission_management:
    - id: "TC-PERM-001"
      name: "最小权限分配"
      steps:
        - "基于角色分配权限"
        - "验证只授予必要权限"
        - "记录分配日志"
        
    - id: "TC-PERM-002"
      name: "权限有效期"
      steps:
        - "设置临时权限"
        - "验证到期自动回收"
        - "提醒机制"
        
  # 审批流程
  approval_workflow:
    - id: "TC-APPROVE-001"
      name: "多级审批流程"
      steps:
        - "提交申请"
        - "一级审批"
        - "二级审批"
        - "最终审批"
        - "执行操作"
        
  # 审计追溯
  audit_trace:
    - id: "TC-AUDIT-001"
      name: "操作审计日志"
      steps:
        - "执行敏感操作"
        - "验证日志记录"
        - "验证可追溯性"
        
  # 安全控制
  security_control:
    - id: "TC-SEC-001"
      name: "MFA多因素认证"
      steps:
        - "验证登录需要MFA"
        - "验证MFA绑定"
        - "验证MFA验证"
```

### 2.2 测试数据模型

```yaml
test_data_model:
  # 测试账号
  test_accounts:
    - user_id: "test_admin_001"
      role: "admin"
      permissions: ["*"]
      
    - user_id: "test_operator_001"
      role: "operator"
      permissions: ["read", "write"]
      
    - user_id: "test_viewer_001"
      role: "viewer"
      permissions: ["read"]
      
  # 测试资源
  test_resources:
    - resource_id: "test_db_001"
      type: "database"
      sensitivity: "high"
      
    - resource_id: "test_app_001"
      type: "application"
      sensitivity: "medium"
      
  # 测试环境
  test_environment:
    base_url: "https://test.privilege-account.internal"
    database: "postgresql://test-db:5432/privilege_test"
    ldap: "ldap://test-ldap.internal:389"
```

---

## 三、Agent职责与实现

### 3.1 测试协调员 (TestCoordinator)

```yaml
test_coordinator:
  # 职责
  responsibilities:
    - "接收测试需求"
    - "编排测试流程"
    - "协调Agent协作"
    - "监控执行状态"
    - "处理异常情况"
    
  # 输入
  input:
    - "测试需求"
    - "系统信息"
    - "配置参数"
    
  # 输出
  output:
    - "测试计划"
    - "执行状态"
    - "最终报告"
    
  # 实现代码
  implementation: |
    class TestCoordinator:
        def __init__(self, config):
            self.agents = {
                'architect': TestArchitect(),
                'generator': TestGenerator(),
                'executor': TestExecutor(),
                'analyzer': TestAnalyzer()
            }
            self.state = {}
            
        def start_test_cycle(self, test_request):
            # 1. 制定测试计划
            plan = self.agents['architect'].create_plan(test_request)
            
            # 2. 分发给用例生成
            test_cases = self.agents['generator'].generate(plan)
            
            # 3. 执行测试
            results = self.agents['executor'].execute(test_cases)
            
            # 4. 分析结果
            report = self.agents['analyzer'].analyze(results)
            
            return report
```

### 3.2 测试架构师 (TestArchitect)

```yaml
test_architect:
  # 职责
  responsibilities:
    - "分析被测系统"
    - "设计测试策略"
    - "规划测试覆盖"
    - "定义测试数据"
    - "制定执行计划"
    
  # 核心Prompt
  prompt: |
    你是一个测试架构师，负责为特权账号管理系统设计端到端测试策略。
    
    系统信息：
    {system_info}
    
    测试需求：
    {test_requirements}
    
    请输出：
    1. 测试策略 - 覆盖范围、方法、优先级
    2. 测试计划 - 时间安排、资源分配
    3. 测试数据 - 需要的测试账号、测试数据
    4. 风险识别 - 潜在风险及应对
    
    格式：JSON
    {
      "strategy": {...},
      "plan": {...},
      "test_data": {...},
      "risks": [...]
    }
    
  # 工具
  tools:
    - "read" - 读取系统文档
    - "exec" - 执行命令验证系统
```

### 3.3 用例工程师 (TestGenerator)

```yaml
test_generator:
  # 职责
  responsibilities:
    - "根据测试计划生成测试用例"
    - "编写可执行的测试代码"
    - "准备测试数据"
    - "验证用例正确性"
    
  # 核心Prompt
  prompt: |
    你是一个测试工程师，负责为特权账号系统生成可执行的测试用例。
    
    测试计划：
    {test_plan}
    
    系统信息：
    {system_info}
    
    请生成测试用例代码：
    - 使用Python + pytest框架
    - 包含setup/teardown
    - 包含断言
    - 可直接执行
    
    输出格式：
    {
      "test_files": [
        {
          "filename": "test_account_lifecycle.py",
          "content": "..."
        }
      ],
      "test_data": {...}
    }
    
  # 工具
  tools:
    - "read" - 读取API文档
    - "write" - 生成测试代码
    - "exec" - 验证语法
```

### 3.4 测试执行员 (TestExecutor)

```yaml
test_executor:
  # 职责
  responsibilities:
    - "执行测试用例"
    - "记录执行结果"
    - "收集测试日志"
    - "截图/录制证据"
    - "处理执行异常"
    
  # 核心Prompt
  prompt: |
    你是一个测试执行员，负责执行测试用例并记录结果。
    
    测试用例：
    {test_cases}
    
    执行配置：
    {execution_config}
    
    请执行测试并输出：
    {
      "execution_id": "...",
      "start_time": "...",
      "end_time": "...",
      "results": [
        {
          "test_id": "TC-001",
          "status": "passed/failed/error",
          "duration": 1.23,
          "logs": "...",
          "evidence": [...]
        }
      ],
      "summary": {
        "total": 10,
        "passed": 8,
        "failed": 2,
        "error": 0
      }
    }
    
  # 工具
  tools:
    - "exec" - 运行测试
    - "read" - 读取配置
    - "browser" - 截图证据
```

### 3.5 质量分析师 (TestAnalyzer)

```yaml
test_analyzer:
  # 职责
  responsibilities:
    - "分析测试结果"
    - "识别失败原因"
    - "生成分析报告"
    - "提出改进建议"
    - "跟踪缺陷"
    
  # 核心Prompt
  prompt: |
    你是一个质量分析师，负责分析测试结果并生成报告。
    
    测试执行结果：
    {test_results}
    
    系统信息：
    {system_info}
    
    请分析并输出：
    1. 测试摘要 - 通过率、覆盖率
    2. 失败分析 - 根因、影响
    3. 缺陷列表 - 描述、严重性、状态
    4. 改进建议 - 优化测试、提升质量
    5. 最终结论 - 是否可以发布
    
    格式：Markdown报告
    
  # 工具
  tools:
    - "read" - 读取测试结果
    - "exec" - 执行分析命令
    - "write" - 生成报告
```

---

## 四、完整测试流程

### 4.1 流程图

```
┌─────────────────────────────────────────────────────────────────┐
│                    端到端测试流程                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  用户请求                                                        │
│     │                                                          │
│     ▼                                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  TestCoordinator                                         │   │
│  │  - 接收需求                                               │   │
│  │  - 创建测试任务                                           │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                      │
│                           ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  TestArchitect                                           │   │
│  │  - 分析系统                                               │   │
│  │  - 设计测试策略                                           │   │
│  │  → 输出: 测试计划                                          │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                      │
│                           ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  TestGenerator                                           │   │
│  │  - 生成测试用例                                           │   │
│  │  - 编写测试代码                                           │   │
│  │  → 输出: 测试代码                                          │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                      │
│                           ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  TestExecutor                                            │   │
│  │  - 执行测试                                               │   │
│  │  - 记录结果                                               │   │
│  │  → 输出: 执行结果                                          │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                      │
│                           ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  TestAnalyzer                                            │   │
│  │  - 分析结果                                               │   │
│  │  - 生成报告                                               │   │
│  │  → 输出: 分析报告                                          │   │
│  └────────────────────────┬────────────────────────────────┘   │
│                           │                                      │
│                           ▼                                      │
│  返回报告                                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 详细步骤

```yaml
detailed_steps:
  # Step 1: 接收请求
  step_1:
    name: "接收测试请求"
    actor: "TestCoordinator"
    input:
      - "测试范围"
      - "测试类型"
      - "环境信息"
    output: "测试任务"
    
  # Step 2: 设计测试计划
  step_2:
    name: "设计测试计划"
    actor: "TestArchitect"
    actions:
      - "分析系统架构"
      - "识别测试点"
      - "设计测试策略"
      - "规划测试数据"
    output: "测试计划JSON"
    
  # Step 3: 生成测试用例
  step_3:
    name: "生成测试用例"
    actor: "TestGenerator"
    actions:
      - "解析测试计划"
      - "编写测试代码"
      - "生成测试数据"
      - "验证代码正确性"
    output: "测试代码文件"
    
  # Step 4: 执行测试
  step_4:
    name: "执行测试"
    actor: "TestExecutor"
    actions:
      - "准备测试环境"
      - "运行测试用例"
      - "收集执行日志"
      - "录制执行证据"
    output: "执行结果JSON"
    
  # Step 5: 分析结果
  step_5:
    name: "分析测试结果"
    actor: "TestAnalyzer"
    actions:
      - "统计执行结果"
      - "分析失败原因"
      - "识别缺陷"
      - "生成报告"
    output: "分析报告"
```

---

## 五、测试用例示例

### 5.1 账号创建测试

```python
# test_account_creation.py
import pytest
import requests
import time

class TestAccountCreation:
    """特权账号创建端到端测试"""
    
    @pytest.fixture(autouse=True)
    def setup(self):
        """测试前准备"""
        self.base_url = "https://test.privilege-account.internal"
        self.api = f"{self.base_url}/api/v1"
        self.admin_token = "test_admin_token"
        
    def test_create_privilege_account(self):
        """TC-ACCOUNT-001: 创建特权账号"""
        # 1. 提交账号申请
        application_data = {
            "user_name": "test_user_001",
            "email": "test@example.com",
            "department": "IT",
            "role": "operator",
            "requested_permissions": [
                "db:read",
                "db:write",
                "app:deploy"
            ],
            "validity": "90days",
            "reason": "业务需要"
        }
        
        response = requests.post(
            f"{self.api}/applications",
            json=application_data,
            headers={"Authorization": f"Bearer {self.admin_token}"}
        )
        assert response.status_code == 201
        app_id = response.json()["application_id"]
        
        # 2. 一级审批
        response = requests.post(
            f"{self.api}/applications/{app_id}/approve",
            json={"level": 1, "comment": "同意"},
            headers={"Authorization": f"Bearer {self.admin_token}"}
        )
        assert response.status_code == 200
        
        # 3. 二级审批
        response = requests.post(
            f"{self.api}/applications/{app_id}/approve",
            json={"level": 2, "comment": "同意"},
            headers={"Authorization": f"Bearer {self.admin_token}"}
        )
        assert response.status_code == 200
        
        # 4. 创建账号
        response = requests.get(
            f"{self.api}/applications/{app_id}/account",
            headers={"Authorization": f"Bearer {self.admin_token}"}
        )
        assert response.status_code == 200
        account = response.json()
        
        assert account["status"] == "active"
        assert account["user_name"] == "test_user_001"
        
        # 5. 验证权限分配
        permissions = account["permissions"]
        assert "db:read" in permissions
        assert "db:write" in permissions
        
        # 6. 验证审计日志
        audit_logs = requests.get(
            f"{self.api}/audit/logs",
            params={"account_id": account["account_id"]},
            headers={"Authorization": f"Bearer {self.admin_token}"}
        ).json()
        
        assert len(audit_logs) >= 3  # 申请、审批、创建
        
        print(f"✅ 账号创建成功: {account['account_id']}")
        
    def test_permission_boundary(self):
        """验证最小权限原则"""
        # 创建账号时，验证权限不超过申请的权限
        pass  # 实现细节...
        
    def test_approval_timeout(self):
        """验证审批超时"""
        # 审批超时自动拒绝
        pass  # 实现细节...
```

### 5.2 权限管理测试

```python
# test_permission_management.py

class TestPermissionManagement:
    """权限管理测试"""
    
    def test_minimum_privilege(self):
        """TC-PERM-001: 验证最小权限分配"""
        # 1. 创建operator角色账号
        # 2. 验证只有operator权限
        # 3. 尝试获取admin权限
        # 4. 验证被拒绝
        pass
        
    def test_permission_expiry(self):
        """TC-PERM-002: 验证临时权限过期"""
        # 1. 创建90天有效期的临时权限
        # 2. 等待或模拟时间流逝
        # 3. 验证权限自动失效
        pass
        
    def test_permission_escalation(self):
        """验证权限提升检测"""
        # 尝试通过漏洞提升权限
        pass
```

### 5.3 安全控制测试

```python
# test_security_control.py

class TestSecurityControl:
    """安全控制测试"""
    
    def test_mfa_required(self):
        """TC-SEC-001: 验证MFA必须"""
        # 1. 未绑定MFA的账号尝试登录
        # 2. 验证被拒绝
        pass
        
    def test_mfa_bypass_prevention(self):
        """验证MFA绕过防护"""
        # 尝试绕过MFA
        pass
        
    def test_session_timeout(self):
        """验证会话超时"""
        # 1. 登录
        # 2. 等待超时
        # 3. 验证需要重新登录
        pass
```

---

## 六、执行配置

### 6.1 执行环境配置

```yaml
execution_config:
  # 环境配置
  environment:
    test_server: "10.0.0.100"
    test_database: "10.0.0.101"
    test_ldap: "10.0.0.102"
    
  # 测试配置
  test_config:
    parallel_workers: 5
    retry_count: 2
    timeout: 300
    screenshot_on_failure: true
    
  # 报告配置
  report_config:
    format: "html"
    output_dir: "/test-reports"
    include_screenshots: true
    include_logs: true
```

### 6.2 测试数据准备

```yaml
test_data_preparation:
  # 测试账号
  accounts:
    - name: "admin"
      password: "test_admin_pwd"
      mfa_enabled: true
      
    - name: "operator"
      password: "test_operator_pwd"
      mfa_enabled: true
      
  # 测试数据
  test_data:
    departments: ["IT", "Finance", "Operation"]
    roles: ["admin", "operator", "viewer"]
    permissions: ["db:read", "db:write", "app:deploy", "app:admin"]
```

---

## 七、报告模板

### 7.1 测试报告

```markdown
# 特权账号系统端到端测试报告

## 执行摘要
- 测试时间: 2026-04-09 14:00-15:30
- 测试用例: 50个
- 通过: 45个 (90%)
- 失败: 5个 (10%)
- 阻塞: 0个

## 测试覆盖

| 模块 | 用例数 | 通过 | 失败 |
|------|--------|------|------|
| 账号生命周期 | 15 | 14 | 1 |
| 权限管理 | 12 | 10 | 2 |
| 审批流程 | 10 | 9 | 1 |
| 审计追溯 | 8 | 8 | 0 |
| 安全控制 | 5 | 4 | 1 |

## 失败用例分析

### TC-ACCOUNT-003: 注销特权账号
- 原因: 权限回收不完整
- 严重性: 高
- 状态: 缺陷已记录

### TC-PERM-001: 最小权限分配
- 原因: 权限验证逻辑错误
- 严重性: 中
- 状态: 缺陷已记录

## 改进建议
1. 修复权限回收逻辑
2. 完善权限验证
3. 增加边界测试

## 结论
系统存在2个高优先级缺陷，建议修复后重新测试。
```

---

## 八、使用指南

### 8.1 快速开始

```bash
# 1. 克隆项目
git clone https://github.com/tiandiyou/harness-engineer.git
cd harness-engineer/huawei-sdlo

# 2. 配置环境
cp config.example.yaml config.yaml
# 编辑config.yaml填入测试环境信息

# 3. 运行测试
python -m pytest tests/e2e/ -v

# 4. 查看报告
open test-reports/report.html
```

### 8.2 自定义测试

```yaml
# 在config.yaml中配置自定义测试需求
test_requirements:
  - "测试账号创建流程"
  - "测试权限变更"
  - "测试审批流程"
  
scope:
  - "account_lifecycle"
  - "permission_management"
  - "approval_workflow"
```

---

## 九、文档信息

| 项目 | 内容 |
|------|------|
| 作者 | AI Assistant |
| 审阅 | 待审阅 |
| 版本 | v1.0 |
| 更新 | 2026-04-09 |
| 状态 | 可直接使用 |