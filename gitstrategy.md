# Git 工作策略

**版本:** 1.0  
**日期:** 2026-02-20  
**目的:** 多人协作开发规范

---

## 📋 基本原则

1. **始终使用 Rebase** - 避免 merge commits，保持线性历史
2. **先拉后推** - 每次推送前先 pull --rebase
3. **小步提交** - 频繁提交，保持提交原子性
4. **写好提交信息** - 清晰描述改动内容

---

## 🔧 每日开发流程

### 开始新任务
```bash
# 1. 确保本地干净
git status

# 2. 拉取最新代码 (使用 rebase)
git pull --rebase origin master

# 3. 开始开发
git checkout -b feature/your-feature
```

### 提交代码
```bash
# 1. 查看修改
git status
git diff

# 2. 添加修改
git add <files>

# 3. 提交 (使用 conventional commits)
git commit -m "feat: 添加新功能"

# 4. 推送前先 rebase
git pull --rebase origin master

# 5. 推送
git push origin master
```

### 冲突处理
```bash
# 1. 解决冲突后
git add <resolved-files>

# 2. 继续 rebase
git rebase --continue

# 3. 如果想放弃
git rebase --abort
```

---

## 📝 提交信息规范

### 格式
```
<type>: <subject>

[optional body]
```

### 类型 (Type)
| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档更新 |
| `style` | 代码格式 |
| `refactor` | 重构 |
| `test` | 测试相关 |
| `chore` | 构建/工具 |

### 示例
```
feat: 添加角色倍率系统

- 实现 CharacterSystem.gd
- 集成到 GameManager
- 添加 5 个角色配置

Closes #123
```

---

## 🚫 禁止事项

1. ❌ 禁止 `git merge` (会产生 merge commit)
2. ❌ 禁止 `git push --force` (除非紧急情况)
3. ❌ 禁止直接 push 到 master (使用 rebase)
4. ❌ 禁止提交大文件 (使用 .gitignore)

---

## 🔄 分支策略

```
origin/master (主分支)
    │
    ├── feature/<功能名> (功能分支)
    ├── fix/<bug名> (修复分支)
    └── docs/<文档名> (文档分支)
```

### 分支命名
- 功能: `feature/角色系统`
- 修复: `fix/音效崩溃`
- 文档: `docs/更新readme`

---

## ✅ 代码审查

1. 提交前 self-review `git diff`
2. 描述清楚改动内容
3. 关联 issue (#123)

---

*遵守此策略，保持代码仓库整洁*
