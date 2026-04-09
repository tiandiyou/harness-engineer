# Harness Engineering 安全实践 - AI Agent安全防护

> 文档编号：AI-Tech-HW-003  
> 关键词：Security、Agent Safety、Prompt Injection、Access Control、Audit  
> 更新日期：2026-04-09

---

## 一、AI Agent安全概述

### 1.1 安全威胁分类

```
AI Agent面临的安全威胁：
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  🔴 高危威胁                                                    │
│  ├── Prompt Injection - 恶意指令注入                           │
│  ├── Tool Abuse - 工具滥用                                     │
│  ├── Data Exfiltration - 数据窃取                             │
│  └── Privilege Escalation - 权限提升                           │
│                                                                │
│  🟠 中危威胁                                                    │
│  ├── Context Pollution - 上下文污染                           │
│  ├── Resource Exhaustion - 资源耗尽                            │
│  ├── Denial of Service - 拒绝服务                              │
│  └── Unauthorized Access - 未授权访问                          │
│                                                                │
│  🟡 低危威胁                                                    │
│  ├── Information Disclosure - 信息泄露                       │
│  ├── Unexpected Behavior - 异常行为                            │
│  └── Output Manipulation - 输出操纵                           │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 1.2 安全架构

```yaml
security_architecture:
  # 防护层次
  layers:
    - "input_validation"
    - "output_filtering"
    - "access_control"
    - "audit_logging"
    - "rate_limiting"
    
  # 核心原则
  principles:
    - "最小权限"
    - "纵深防御"
    - "零信任"
    - "持续验证"
```

---

## 二、输入安全 - Prompt Injection防护

### 2.1 注入类型

| 类型 | 描述 | 示例 |
|------|------|------|
| 直接注入 | 直接覆盖系统Prompt | "忽略之前的指令..." |
| 间接注入 | 通过外部数据注入 | 恶意文档内容 |
| 角色扮演 | 诱导Agent扮演其他角色 | "你是一个法官..." |
| 上下文污染 | 扭曲对话上下文 | 伪造历史信息 |
| 工具注入 | 通过工具输出注入 | 恶意文件内容 |

### 2.2 防护机制

```yaml
input_protection:
  # Prompt验证
  prompt_validation:
    rules:
      - "检测指令覆盖模式"
      - "检测角色扮演请求"
      - "检测编码绕过"
      - "检测上下文操纵"
      
    patterns:
      override:
        - "ignore.*instructions"
        - "disregard.*rules"
        - "new.*instructions"
        
      role_play:
        - "you are.*now"
        - "act as.*"
        - "pretend to be"
        
  # 清理
  sanitization:
    enabled: true
    methods:
      - "移除可疑模式"
      - "转义特殊字符"
      - "限制长度"
      
  # 隔离
  isolation:
    user_input: "sandboxed"
    external_data: "validated"
```

### 2.3 实践示例

```python
# Prompt注入检测示例
import re

class PromptInjectionDetector:
    def __init__(self):
        self.override_patterns = [
            r"ignore\s+(all\s+)?(previous|prior|above)\s+instructions",
            r"disregard\s+(all\s+)?(previous|prior|your)\s+(rules?|instructions?)",
            r"new\s+instructions?",
            r"system\s*:\s*",
            r"override\s+",
        ]
        
        self.role_play_patterns = [
            r"you\s+are\s+(\w+\s+){0,3}now",
            r"act\s+as\s+",
            r"pretend\s+(you\s+)?(to\s+)?be",
            r"roleplay\s+",
        ]
        
    def detect(self, text: str) -> dict:
        score = 0
        reasons = []
        
        for pattern in self.override_patterns:
            if re.search(pattern, text, re.IGNORECASE):
                score += 50
                reasons.append(f"Override pattern: {pattern}")
                
        for pattern in self.role_play_patterns:
            if re.search(pattern, text, re.IGNORECASE):
                score += 30
                reasons.append(f"Role play pattern: {pattern}")
                
        return {
            "score": score,
            "risk": "high" if score > 50 else "medium" if score > 20 else "low",
            "reasons": reasons
        }
```

---

## 三、工具安全 - Tool Abuse防护

### 3.1 工具分类与风险

| 类别 | 工具示例 | 风险 |
|------|----------|------|
| 文件操作 | read, write, edit | 文件泄漏, 恶意写入 |
| 命令执行 | exec, process | 命令注入, 权限提升 |
| 网络访问 | browser, web_fetch | 数据外泄, SSRF |
| 消息发送 | message | 钓鱼攻击, 垃圾信息 |
| 系统操作 | nodes, camera | 物理设备控制 |

### 3.2 工具权限控制

```yaml
tool_permissions:
  # 权限级别
  levels:
    - name: "read_only"
      tools: ["read", "web_fetch", "browser"]
      
    - name: "execution_limited"
      tools: ["exec"]
      constraints:
        timeout: 30
        allowed_commands: ["git", "ls", "cat", "grep"]
        
    - name: "full_access"
      tools: ["write", "edit", "message", "nodes"]
      
  # 动态权限
  dynamic:
    enabled: true
    factors:
      - "user_trust_level"
      - "task_type"
      - "context_risk"
      
  # 审计
  audit:
    all_calls: true
    log_level: "detailed"
    retention: "1y"
```

### 3.3 命令执行控制

```yaml
command_control:
  # 白名单
  whitelist:
    enabled: true
    commands:
      - "git"
      - "ls"
      - "cat"
      - "grep"
      - "find"
      - "head"
      - "tail"
      
  # 禁止模式
  blacklist:
    patterns:
      - ".*&&.*rm.*"
      - ".*\|\|.*del.*"
      - ".*wget.*\|.*sh"
      - ".*curl.*\|.*sh"
      
  # 资源限制
  limits:
    max_execution_time: 30
    max_output_size: "1MB"
    max_concurrent: 5
    
  # 沙箱
  sandbox:
    enabled: true
    type: "gvisor"
    network: "none"
    filesystem: "read_only"
```

---

## 四、输出安全 - Output Filtering

### 4.1 输出风险

```
AI Agent输出可能包含：
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  🔴 敏感数据                                                    │
│     - 密码/密钥                                                 │
│     - 个人隐私信息                                              │
│     - 业务敏感数据                                              │
│                                                                │
│  🔴 有害内容                                                    │
│     - 恶意代码                                                  │
│     - 钓鱼内容                                                  │
│     - 歧视性内容                                                │
│                                                                │
│  🟠 误导信息                                                    │
│     - 错误的技术建议                                            │
│     - 不安全的配置                                              │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 4.2 过滤机制

```yaml
output_filtering:
  # 敏感信息检测
  sensitive_data:
    patterns:
      - name: "password"
        regex: "(password|passwd|pwd)\\s*[=:]\\s*\\S+"
        
      - name: "api_key"
        regex: "(api[_-]?key|apikey)\\s*[=:]\\s*[a-zA-Z0-9]{20,}"
        
      - name: "private_key"
        regex: "-----BEGIN\\s+(RSA\\s+)?PRIVATE\\s+KEY-----"
        
      - name: "token"
        regex: "(bearer\\s+|token\\s*=\\s*)[a-zA-Z0-9_-]{20,}"
        
    action: "mask"
    
  # 有害内容检测
  harmful_content:
    categories:
      - "malware"
      - "phishing"
      - "exploit"
      - "discrimination"
      
    action: "block"
    
  # 输出验证
  validation:
    - "格式检查"
    - "类型检查"
    - "大小检查"
```

---

## 五、访问控制 - Access Control

### 5.1 认证机制

```yaml
authentication:
  # 用户认证
  user_auth:
    methods:
      - "OAuth 2.0"
      - "API Key"
      - "JWT"
      
    mfa: true
    
  # Agent认证
  agent_auth:
    methods:
      - "mTLS"
      - "API Key"
      
    identity: "unique_agent_id"
    
  # 会话管理
  session:
    timeout: "30min"
    refresh: "enabled"
    max_concurrent: "5"
```

### 5.2 授权模型

```yaml
authorization:
  # 基于角色的访问控制 (RBAC)
  rbac:
    roles:
      - name: "admin"
        permissions: ["*"]
        
      - name: "developer"
        permissions:
          - "read"
          - "write:own"
          - "exec:limited"
          
      - name: "viewer"
        permissions:
          - "read"
          
  # 基于属性的访问控制 (ABAC)
  abac:
    conditions:
      - "time within working hours"
      - "location in allowed network"
      - "device compliance verified"
      
  # 最小权限
  least_privilege:
    default: "deny"
    explicit_grant: true
    periodic_review: "quarterly"
```

### 5.3 资源隔离

```yaml
isolation:
  # 任务隔离
  task_isolation:
    method: "git_worktree"
    branch_per_task: true
    
  # 数据隔离
  data_isolation:
    storage: "separate"
    encryption: "per_tenant"
    backup: "isolated"
    
  # 网络隔离
  network_isolation:
    type: "vpc"
    firewall: "strict"
    outbound: "whitelist"
```

---

## 六、审计与追溯

### 6.1 审计事件

```yaml
audit_events:
  # 需要记录的事件
  events:
    - "authentication"
    - "authorization"
    - "tool_invocation"
    - "data_access"
    - "configuration_change"
    - "admin_action"
    
  # 事件字段
  fields:
    - "timestamp"
    - "user_id"
    - "agent_id"
    - "action"
    - "resource"
    - "result"
    - "ip_address"
    - "metadata"
    
  # 存储
  storage:
    backend: "elasticsearch"
    retention: "3y"
    encryption: "enabled"
```

### 6.2 日志示例

```json
{
  "timestamp": "2026-04-09T10:30:00Z",
  "event_type": "tool_invocation",
  "actor": {
    "type": "agent",
    "id": "agent-001",
    "user": "user-123"
  },
  "action": {
    "tool": "exec",
    "command": "git push origin main",
    "args": {}
  },
  "resource": {
    "type": "repository",
    "id": "repo-456"
  },
  "result": {
    "status": "success",
    "duration_ms": 1500
  },
  "security": {
    "risk_score": 0,
    "blocked": false
  }
}
```

### 6.3 追溯能力

```yaml
traceability:
  # 追踪ID
  trace_id:
    format: "uuid"
    propagation: "automatic"
    
  # 关联分析
  correlation:
    - "user → agent → action"
    - "action → resource → result"
    - "session → task → subtask"
    
  # 合规报告
  reporting:
    - "access_report"
    - "activity_report"
    - "security_report"
    - "compliance_report"
```

---

## 七、安全监控与响应

### 7.1 监控指标

```yaml
security_metrics:
  # 威胁检测
  threat_detection:
    - "prompt_injection_attempts"
    - "tool_abuse_attempts"
    - "authentication_failures"
    - "authorization_violations"
    
  # 行为异常
  behavioral_anomaly:
    - "unusual_tool_usage"
    - "abnormal_data_access"
    - "unexpected_api_calls"
    - "resource_spikes"
    
  # 合规指标
  compliance:
    - "policy_violations"
    - "control_failures"
    - "audit_gaps"
```

### 7.2 响应机制

```yaml
incident_response:
  # 响应级别
  levels:
    - name: "low"
      action: "log_and_notify"
      
    - name: "medium"
      action: "block_and_alert"
      
    - name: "high"
      action: "terminate_and_isolate"
      
    - name: "critical"
      action: "emergency_response"
      
  # 自动响应
  automation:
    - "自动阻断恶意请求"
    - "自动隔离受攻击Agent"
    - "自动通知安全团队"
    - "自动收集证据"
```

### 7.3 恢复流程

```yaml
recovery:
  # 步骤
  steps:
    - "确认攻击已停止"
    - "评估影响范围"
    - "清理恶意代码"
    - "恢复服务"
    - "更新防护措施"
    - "复盘总结"
    
  # 恢复时间目标
  rto:
    critical: "1h"
    high: "4h"
    medium: "24h"
    low: "7d"
```

---

## 八、安全最佳实践

### 8.1 开发安全

```yaml
development_security:
  # 安全编码
  secure_coding:
    - "输入验证"
    - "输出编码"
    - "安全配置"
    - "错误处理"
    
  # 安全测试
  security_testing:
    - "静态分析"
    - "动态测试"
    - "渗透测试"
    - "模糊测试"
    
  # 依赖管理
  dependency:
    - "定期扫描漏洞"
    - "及时更新"
    - "最小化依赖"
```

### 8.2 运营安全

```yaml
operations_security:
  # 监控
  monitoring:
    - "实时告警"
    - "日志分析"
    - "异常检测"
    - "威胁情报"
    
  # 响应
  response:
    - "预案制定"
    - "定期演练"
    - "快速止损"
    - "事后分析"
    
  # 改进
  improvement:
    - "持续学习"
    - "规则更新"
    - "配置优化"
```

### 8.3 检查清单

```
安全实施检查清单：
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ✅ 输入验证 - 检测和阻止恶意输入                                │
│  ✅ 输出过滤 - 防止敏感信息泄露                                 │
│  ✅ 工具控制 - 限制工具使用范围                                  │
│  ✅ 访问控制 - 最小权限原则                                      │
│  ✅ 审计日志 - 完整记录所有操作                                  │
│  ✅ 监控告警 - 实时检测异常                                      │
│  ✅ 响应机制 - 快速处置安全事件                                  │
│  ✅ 定期审查 - 持续优化安全策略                                  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 九、合规要求

### 9.1 相关标准

| 标准 | 要求 | 对应措施 |
|------|------|----------|
| ISO 27001 | 信息安全管理 | 访问控制、审计 |
| SOC 2 | 服务可信 | 安全监控、响应 |
| GDPR | 数据保护 | 隐私保护、访问控制 |
| PCI DSS | 支付卡安全 | 加密、审计 |
| 等保2.0 | 等级保护 | 主机安全、应用安全 |

### 9.2 合规审计

```yaml
compliance_audit:
  # 审计范围
  scope:
    - "身份鉴别"
    - "访问控制"
    - "安全审计"
    - "资源控制"
    - "数据安全"
    
  # 审计频率
  frequency:
    internal: "quarterly"
    external: "annual"
    
  # 审计报告
  reports:
    - "差距分析"
    - "整改计划"
    - "合规证明"
```

---

## 十、文档信息

| 项目 | 内容 |
|------|------|
| 作者 | AI Assistant |
| 审阅 | 待审阅 |
| 版本 | v1.0 |
| 更新 | 2026-04-09 |
| 状态 | 草稿 |