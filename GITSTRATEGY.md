# Git 协作策略

**项目:** PI-PinBall, game/pin-ball  
**版本:** 1.0

---

## 1. 分支策略

### 主分支
- `master` - 生产代码，仅通过 PR 合并
- `develop` - 开发分支

### 工作分支
- `feature/xxx` - 新功能
- `fix/xxx` - Bug 修复
- `ci/xxx` - CI/CD 改进

---

## 2. 提交规范

### 格式
```
<类型>: <简短描述>

[可选正文]

[可选脚注]
```

### 类型
| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | Bug 修复 |
| docs | 文档 |
| style | 代码格式 |
| refactor | 重构 |
| test | 测试 |
| ci | CI/CD |
| chore | 杂项 |

---

## 3. 合并策略

### 核心规则
> **优先使用 `git pull --rebase` 防止冲突**

### 日常开发流程
```bash
# 1. 确保本地 master 最新
git checkout master
git pull --rebase

# 2. 创建工作分支
git checkout -b fix/xxx

# 3. 开发完成后提交
git add .
git commit -m "fix: 问题描述"

# 4. 推送前 rebase master
git fetch origin
git rebase origin/master

# 5. 推送并创建 PR
git push -u origin fix/xxx
```

### 多人协作规则
1. **始终使用 rebase** - 保持线性历史
2. **先拉后推** - 每天开始先 `git pull --rebase`
3. **小步提交** - 频繁提交，避免大批量更改
4. **及时沟通** - 大改动前通知团队成员

---

## 4. 冲突解决

### 冲突处理流程
1. **分析冲突**: `git status`
2. **手动解决**: 编辑冲突文件
3. **标记解决**: `git add <file>`
4. **继续 rebase**: `git rebase --continue`
5. **验证**: 运行测试
6. **强制推送** (如需): `git push --force-with-lease`

### 禁止
- ❌ 直接 `git push --force` (除非紧急)
- ❌ `git merge` (使用 rebase)
- ❌ 在公共分支直接提交

---

## 5. 代码审查

### PR 要求
- 至少 1 人审查
- 所有 CI 检查通过
- 无冲突

### 审查清单
- [ ] 代码功能正确
- [ ] 无明显性能问题
- [ ] 测试通过
- [ ] 文档已更新

---

## 6. 发布流程

```bash
# 1. 更新版本号
npm version 1.0.0

# 2. 打标签
git tag -a v1.0.0 -m "Release 1.0.0"

# 3. 推送标签
git push origin v1.0.0
```

---

## 7. 紧急修复

### Hotfix 流程
```bash
# 从 master 创建 hotfix 分支
git checkout -b hotfix/xxx master

# 修复后合并
git checkout master
git merge --no-ff hotfix/xxx

# 立即推送
git push

# 删除 hotfix 分支
git branch -d hotfix/xxx
```

---

## 8. 常用命令速查

| 操作 | 命令 |
|------|------|
| 拉取并rebase | `git pull --rebase` |
| 创建分支 | `git checkout -b fix/xxx` |
| 暂存 | `git add -A` |
| 提交 | `git commit -m "fix: 描述"` |
| 推送到远程 | `git push -u origin fix/xxx` |
| 查看状态 | `git status` |
| 查看历史 | `git log --oneline --graph` |
| 放弃rebase | `git rebase --abort` |
| 解决冲突后继续 | `git rebase --continue` |
| 强制推送(安全) | `git push --force-with-lease` |

---

*最后更新: 2026-02-20*
