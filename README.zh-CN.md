# SaaS Auth Shield

[English](./README.md)

为 SaaS 应用添加带有 **防滥用注册能力** 的认证方案。

SaaS Auth Shield 是一个 Agent Skill，适合那些不满足于“只有登录注册”的项目。它帮助 agent 在实现认证的同时，加上更实用的防滥用能力，例如：设备指纹、同设备账号数量限制、注册/登录事件日志，以及对已有认证系统的迁移支持。

## 为什么做这个 skill

很多 SaaS 认证模板通常只做到：
- 邮箱密码登录
- OAuth 登录
- 忘记密码
- session 管理

这些足够让用户登录进去，但往往不足以减缓下面这些问题：
- 重复注册
- 同设备批量养号
- 免费额度被刷
- 邀请/返利机制被薅
- 低成本的大量注册尝试

这个 skill 关注的正是很多模板缺的那一层：**SaaS 场景下的防滥用注册能力**。

## 它和普通 auth skill 的区别

- **认证 + 防滥用一起做** —— 不只是生成登录/注册页面
- **支持设备指纹** —— 可选开源方案或 FingerprintJS Pro
- **支持同设备账号上限** —— 规则简单、可审计、可解释
- **适合改造老项目** —— 不只适用于新项目
- **适合独立开发者** —— 优先用实用规则，而不是复杂黑盒风控

## 适合什么项目

当你需要下面这些能力时，这个 skill 很合适：
- 邮箱密码登录和/或 Google OAuth
- 注册防滥用
- 把设备指纹作为风险信号
- 限制同一设备可注册的账号数
- 记录注册/登录事件日志
- 从已有认证系统迁移，例如 NextAuth、Clerk、Supabase Auth、Firebase

它尤其适合：
- 独立开发者
- 小型 SaaS 团队
- 有免费额度、积分、邀请奖励、养号风险的产品

## 默认会包含什么

除非用户明确要求做更小的版本，否则这个 skill 会把相关能力按“完整链路”一起带上。

### 如果启用 email + password
默认会包含：
- user / session / account 持久化
- 邮箱验证
- 忘记密码与重置密码流程
- 需要邮件发送时的配置，例如 Resend

### 如果启用 Google OAuth
默认会包含：
- provider 配置
- callback 和 session 处理
- account 持久化与基础用户资料存储

### 如果启用 fingerprinting
默认会包含：
- 注册时采集设备指纹
- 同设备注册数量限制
- 注册/登录事件日志

### 数据库默认策略
- 如果项目已有合适数据库，优先复用并扩展。
- 如果没有合适数据库，默认使用 PostgreSQL。
- 推荐默认组合是 **Supabase PostgreSQL + Drizzle ORM**。

## 示例提示词

- `Add auth to my Next.js SaaS, but stop users from mass-registering accounts.`
- `Retrofit Better Auth into this app and add fingerprint-based signup limits.`
- `We have free credits and need basic signup abuse protection.`
- `Migrate from NextAuth without rewriting the whole app, then add per-device account limits.`

## 它的工作方式

这个 skill 会尽量把决策流程保持简单：

1. 先决定指纹方案
   - 开源方案
   - FingerprintJS Pro
   - 不启用 fingerprinting
2. 再决定登录方式
   - email+password
   - Google OAuth
   - 两者都要
3. 再决定项目路径
   - 新项目
   - 已有 auth 的项目
   - 没有 auth 的已有项目

然后采用一套轻量但完整的策略：
- **基础认证层** —— Better Auth、session、邮箱验证、OAuth
- **防滥用层** —— fingerprinting、同设备限制、IP/设备日志
- **可观察性层** —— 审计日志、拒绝原因、可调节阈值

## 目录结构

```text
saas-auth-shield/
├── SKILL.md
├── README.md
├── README.zh-CN.md
├── INSTALLATION.md
├── FILE_MANIFEST.md
├── template.md
├── examples/
│   └── example-output.md
├── references/
│   ├── env-setup.md
│   ├── fingerprint-options.md
│   └── retrofit-guide.md
└── scripts/
    ├── detect-project.sh
    └── validate-skill.sh
```

## 关键文件说明

### `SKILL.md`
导航型主文件，包含：
- skill 的定位与边界
- 需要澄清的问题
- 决策路径
- 默认实现策略
- 指向更详细参考文档的入口

### `references/env-setup.md`
在生成或检查 env 变量、provider 配置时使用。

### `references/fingerprint-options.md`
在决定用开源指纹、FingerprintJS Pro 还是不启用 fingerprinting 时使用。

### `references/retrofit-guide.md`
在迁移或替换已有认证系统时使用。

### `examples/example-output.md`
需要一个更具体的输出模式时使用。

### `template.md`
在实现前或迁移前，用来整理最小决策信息。

## 辅助脚本

### `scripts/detect-project.sh`
用于检测：
- 当前 auth 系统
- 数据库 / ORM
- auth 路由是否存在
- user/auth schema 线索
- 前端/UI 技术栈
- 邮件和 fingerprinting 依赖

```bash
bash scripts/detect-project.sh
```

### `scripts/validate-skill.sh`
用于校验结构，并确认 `SKILL.md` 是否正确引用了参考文件。

```bash
bash scripts/validate-skill.sh
```

## 安装

完整安装说明见 [INSTALLATION.md](./INSTALLATION.md)。

快速开始：

```bash
git clone https://github.com/Rui-Huang-dotcom/saas-auth-shield.git
cp -r saas-auth-shield ~/.claude/skills/saas-auth-shield/
```

如果你使用 Codex 或其他类似环境，请复制到对应的 skills 目录。

## 定位说明

这个 skill **不是**一个完整的风控平台。

它的目标是：
- 提高滥用注册的成本
- 给 SaaS 项目提供实用的防滥用默认方案
- 保持方案足够容易理解和维护，适合独立开发者和小团队

它**不是**为了保证：
- 完美防欺诈
- 精确识别唯一真人
- 企业级行为风控建模

## 发布前检查

在发布或分享之前：

1. 运行 `bash scripts/validate-skill.sh`
2. 确认 `SKILL.md` 与当前结构一致
3. 打包时包含 `references/` 和 `examples/`

## License

MIT —— 可用于个人和商业用途。
