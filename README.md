# Travel Live - Flutter Prototype V1.0

跨境旅行直播APP的Flutter功能完整原型

## ✨ 功能亮点

- ✅ **完整的首页** - 直播列表、短视频、城市筛选
- ✅ **可交互直播间** - 实时弹幕、送礼物、关注主播
- ✅ **开播流程** - 设置信息、模拟开播、记录保存
- ✅ **状态管理** - Provider全局状态，数据实时同步
- ✅ **模拟数据** - 无需后端，直接体验完整流程

## 🎮 快速体验

### 在线预览
GitHub Pages: https://aming1016.github.io/travel-app-expo/ （HTML原型版）

### 本地运行Flutter版（推荐）

```bash
# 克隆仓库
git clone https://github.com/aming1016/travel-app-expo.git
cd travel-app-expo

# 安装Flutter依赖
flutter pub get

# 运行应用
flutter run
```

## 📱 功能演示

### 观看直播
1. 首页点击任意直播卡片
2. 进入直播间，可看到弹幕滚动
3. 点击礼物按钮选择礼物
4. 发送弹幕或礼物

### 开播
1. 点击底部中央的橙色+按钮
2. 输入标题和位置
3. 点击START LIVE
4. 开播成功，自动添加到个人记录

### 查看收益
1. 点击底部Wallet图标
2. 查看总收益和明细
3. 点击Withdraw可模拟提现

## 📁 项目结构

```
flutter_prototype/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── providers/
│   │   └── app_state.dart           # 状态管理
│   ├── screens/
│   │   ├── home_screen.dart         # 首页
│   │   ├── live_room_screen.dart    # 直播间
│   │   ├── discover_screen.dart     # 发现页
│   │   ├── profile_screen.dart      # 个人中心
│   │   └── wallet_screen.dart       # 钱包
│   └── widgets/
│       ├── live_card.dart           # 直播卡片
│       └── video_card.dart          # 视频卡片
├── prototype_preview.html           # 网页版原型（可直接打开）
├── README.md                        # 本文件
└── TECHNICAL_GUIDE.md               # 技术文档
```

## 🎨 设计规范

- **主色**: #FF6B35 (活力橙)
- **画布**: 375×812px (iPhone 14)
- **字体**: Inter / 系统默认
- **圆角**: 12px / 16px / 9999px

## 🔧 技术栈

- Flutter 3.0+
- Dart 3.0+
- Provider (状态管理)

## 📖 详细文档

- [技术文档](TECHNICAL_GUIDE.md) - 架构说明、API文档、开发指南

## 🚀 下一步

1. 接入真实直播SDK（Agora）
2. 连接后端API
3. 添加用户登录/注册
4. 接入支付系统
5. 开发V1.2的服务预订功能

## 🤝 贡献

欢迎提交Issue和PR！

## 📝 License

MIT License

---

**Created by OpenClaw**
**Version: V1.0 (2026-03-05)**