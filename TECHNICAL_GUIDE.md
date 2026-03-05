# Travel Live - Flutter 功能原型 V1.0

> 状态：功能完整的可运行原型（使用模拟数据）
> 版本：V1.0（Phase 1 内容平台期）
> 技术栈：Flutter + Provider

---

## ✅ 已实现功能

### 核心功能
- [x] **首页** - 直播列表、短视频瀑布流、城市标签筛选
- [x] **直播间** - 弹幕系统、礼物系统（含余额扣除）、关注功能
- [x] **开播流程** - 设置标题/位置、模拟开播、添加到直播记录
- [x] **发现页** - 城市网格、热门话题
- [x] **个人中心** - 用户数据、直播记录、功能菜单
- [x] **钱包** - 收益展示、充值、提现模拟

### 交互功能
- [x] 实时弹幕滚动
- [x] 礼物发送（扣减余额）
- [x] 关注/取消关注（切换状态）
- [x] 充值对话框
- [x] 开播成功提示
- [x] 底部Tab导航

---

## 🚀 如何运行

### 环境要求
```
Flutter SDK 3.0+
Dart 3.0+
Android Studio / VS Code
```

### 运行步骤

```bash
# 1. 进入项目目录
cd flutter_prototype

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run

# 或指定设备
flutter run -d ios          # iOS模拟器
flutter run -d android      # Android模拟器
flutter run -d chrome       # 网页版
```

---

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口 + 底部导航
├── providers/
│   └── app_state.dart           # 全局状态管理（Provider）
├── screens/
│   ├── home_screen.dart         # 首页
│   ├── live_room_screen.dart    # 直播间
│   ├── discover_screen.dart     # 发现页
│   ├── profile_screen.dart      # 个人中心
│   └── wallet_screen.dart       # 钱包页
└── widgets/
    ├── live_card.dart           # 直播卡片组件
    └── video_card.dart          # 视频卡片组件

assets/
└── fonts/                       # Inter字体（可选）
```

---

## 🎮 功能演示

### 1. 观看直播流程
```
首页 → 点击直播卡片 → 进入直播间
                    ↓
            可发送弹幕
            可点击关注
            可送礼物（扣余额）
            可查看弹幕
```

### 2. 开播流程
```
点击底部+按钮 → 输入标题/位置 → START LIVE
                                      ↓
                           显示开播成功
                           添加到个人直播记录
```

### 3. 送礼物流程
```
直播间 → 点击礼物按钮 → 选择礼物 → 发送
                              ↓
                    检查余额 → 扣款 → 显示弹幕
                    余额不足 → 提示充值
```

### 4. 充值流程
```
直播间礼物面板 → 点击Recharge → 选择金额 → 充值成功
或
钱包页 → 点击充值 → 选择金额 → 充值成功
```

---

## 💾 数据模型

### 模拟数据说明
所有数据都是本地模拟的，重启应用会重置：

- **直播列表** - 4个预置直播
- **短视频** - 4个预置视频
- **用户数据** - 初始余额256，收益$456
- **弹幕** - 预置5条，可实时添加
- **直播记录** - 开播后自动添加

### 状态管理（Provider）
```dart
AppState 管理以下状态：
- 用户信息（用户名、余额、收益等）
- 直播列表
- 短视频列表
- 弹幕列表
- 关注列表
- 直播记录
- 收益记录
```

---

## 🎨 UI设计规范

### 颜色系统
```dart
主色：#FF6B35 (活力橙)
背景：#FFFFFF / #F5F5F7
文字：#1A1A2E / #6B7280 / #9CA3AF
成功：#34C759
错误：#FF3B30
```

### 尺寸规范
```dart
画布：375×812px (iPhone 14标准)
圆角：12px (卡片), 16px (按钮), 9999px (圆形)
间距：8px基线 (8, 16, 24, 32...)
```

---

## 🔧 代码说明

### 关键文件说明

**main.dart**
- 应用入口
- 配置Provider
- 底部导航栏（含中央开播按钮）

**app_state.dart**
- 所有业务逻辑
- 数据管理
- 状态变更通知

**live_room_screen.dart**
- 最复杂的页面
- 弹幕滚动
- 礼物面板
- 关注功能

### Provider使用示例
```dart
// 读取数据
context.read<AppState>().balance

// 监听变化（自动刷新UI）
context.watch<AppState>().comments

// 调用方法
context.read<AppState>().addComment('Hello')
context.read<AppState>().toggleFollow('userId')
```

---

## 📱 下一步开发建议

### 接入真实服务
1. **直播SDK** - 接入Agora/腾讯云直播
2. **后端API** - 替换模拟数据为真实接口
3. **用户系统** - 登录/注册/鉴权
4. **支付系统** - 接入Stripe/PayPal
5. **推送服务** - 开播提醒、消息通知

### V1.2功能开发
1. 服务详情页
2. 预订流程（日历选择）
3. 订单管理
4. 聊天升级（服务咨询）

---

## ❓ 常见问题

**Q: 为什么弹幕不会自动滚动到底部？**
A: 弹幕列表默认不自动滚动，新消息会在底部显示。如果需要自动滚动，可以修改ListView的controller。

**Q: 余额充值后重启会重置吗？**
A: 会的，因为数据都存在内存里。接入真实后端后就不会了。

**Q: 能在真机上运行吗？**
A: 可以，连接真机后运行 `flutter run -d 设备ID`

**Q: 怎么打包成APK/IPA？**
A: 
```bash
# Android APK
flutter build apk

# iOS（需要Mac+开发者账号）
flutter build ios
```

---

## 📝 更新记录

### 2026-03-05
- 初始化项目
- 完成V1.0所有功能
- 添加Provider状态管理
- 实现完整的交互流程

---

*Created by OpenClaw*
*Version: V1.0*