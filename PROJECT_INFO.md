# 项目信息汇总文档

> 项目名称：Travel Live（跨境旅行直播APP）
> 创建时间：2026-03-05
> 整理人：小可（OpenClaw）

---

## 🔐 GitHub 账户信息

### 账户基本信息
- **GitHub用户名**: `aming1016`
- **邮箱**: lm18303618179@163.com

### Personal Access Token
```
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
```

⚠️ **安全提醒**：此Token具有仓库读写权限，请妥善保管，不要泄露给第三方。

---

## 📁 GitHub 仓库列表

### 仓库1：travel-app-expo（早期版本）
- **仓库地址**: https://github.com/aming1016/travel-app-expo
- **用途**: HTML原型预览
- **状态**: 已归档，不再更新
- **包含内容**:
  - index.html（网页版原型）

### 仓库2：BlueHour_App（当前主仓库）⭐
- **仓库地址**: https://github.com/aming1016/BlueHour_App
- **用途**: Flutter功能完整原型（V1.0）
- **状态**: 活跃开发中
- **包含内容**:
  - Flutter项目完整代码
  - Provider状态管理
  - 5个功能页面
  - 技术文档
  - README说明

---

## 📂 本地工作区文件

### 文档类（Markdown）
| 文件路径 | 说明 |
|---------|------|
| `/workspace/projects/travel-app/PRD-需求池.md` | 产品需求文档（含V1.0/V1.2） |
| `/workspace/projects/travel-app/UI-高保真原型-V1.0.md` | UI设计规范（像素级） |
| `/workspace/projects/travel-app/UI-原型设计-V1.0.md` | 原型设计文档（旧版） |

### Flutter项目代码
| 文件路径 | 说明 |
|---------|------|
| `/workspace/projects/travel-app/flutter_prototype/` | Flutter完整项目 |
| `/workspace/projects/travel-app/flutter_prototype/lib/main.dart` | 应用入口 |
| `/workspace/projects/travel-app/flutter_prototype/lib/providers/app_state.dart` | 状态管理 |
| `/workspace/projects/travel-app/flutter_prototype/lib/screens/` | 页面代码 |
| `/workspace/projects/travel-app/flutter_prototype/TECHNICAL_GUIDE.md` | 技术文档 |

### 飞书在线文档
| 文档名称 | 链接 | 说明 |
|---------|------|------|
| 产品需求池 | https://feishu.cn/docx/SOAudPq0oo62fSxNyuccBaajn5d | 完整功能需求 |
| 运营策略方案 | https://feishu.cn/docx/SWGmd3UAiobOyCxz0LKch9PZnNb | 创作者招募策略 |
| 原型设计文档 | https://feishu.cn/docx/QSYxdsvHNoDCItxwW34cAjvtnvg | UI原型设计 |
| 文档中心 | https://feishu.cn/docx/S5DPdNddVoKZsHxePmbcCFjyn1b | 汇总索引 |

---

## 🎯 项目版本信息

### V1.0（当前已完成）
- **阶段**: Phase 1 内容平台期
- **核心功能**:
  - 直播观看 + 弹幕系统
  - 礼物系统（含余额扣减）
  - 关注/取消关注
  - 开播流程
  - 个人中心 + 钱包
- **技术栈**: Flutter + Provider
- **状态**: 功能完整，使用模拟数据

### V1.2（规划中）
- **阶段**: Phase 2 服务延伸期
- **规划功能**:
  - 服务详情页
  - 预订流程（日历选择）
  - 订单管理
  - 聊天升级
- **状态**: 需求已设计，待开发

---

## 🚀 快速开始指南

### 运行Flutter项目

```bash
# 1. 克隆仓库
git clone https://github.com/aming1016/BlueHour_App.git
cd BlueHour_App

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run
```

### 查看HTML原型

```bash
# 直接在浏览器打开
open prototype_preview.html
```

---

## 📞 沟通记录

### 关键决策
1. **取消角色区分**: 游客和主播统一身份
2. **90%分成模式**: 主播获得礼物收入的90%
3. **分阶段实施**: V1.0内容平台 → V1.2服务延伸
4. **技术选型**: Flutter + Provider

### 待办事项
- [ ] 联系导游资源，招募首批主播
- [ ] 开通TikTok账号运营
- [ ] 接入真实直播SDK（Agora）
- [ ] 后端API开发

---

## ⚠️ 重要提醒

1. **GitHub Token安全**
   - Token: `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`
   - 有效期：建议定期更换
   - 权限：仓库读写

2. **代码备份**
   - 本地工作区：`/workspace/projects/travel-app/`
   - GitHub仓库：`BlueHour_App`
   - 建议定期push到GitHub备份

3. **文档同步**
   - 飞书文档为主
   - 本地Markdown备份
   - GitHub仓库README

---

## 🔧 常用命令

### Git操作
```bash
# 提交代码
git add -A
git commit -m "描述"
git push origin master

# 使用Token推送
git push https://TOKEN@github.com/aming1016/BlueHour_App.git master
```

### Flutter操作
```bash
# 运行应用
flutter run

# 构建APK
flutter build apk

# 构建iOS
flutter build ios
```

---

*文档更新时间：2026-03-05*
*下次更新：项目有重要变更时*