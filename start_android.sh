#!/bin/bash

echo "🚀 Travel Live 启动脚本"
echo "========================"

# 检查后端服务
echo ""
echo "📡 检查后端服务..."
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✅ 后端服务运行中"
else
    echo "⚠️  后端服务未启动，请先启动后端:"
    echo "   cd /workspace/projects/dev-environment/backend && node server.js"
    exit 1
fi

# 检查 Flutter
echo ""
echo "🔧 检查 Flutter 环境..."
flutter doctor --android-licenses > /dev/null 2>&1 || true

# 获取设备列表
echo ""
echo "📱 可用设备:"
flutter devices

# 运行APP
echo ""
echo "🏃 启动 APP..."
cd /workspace/projects/dev-environment/flutter-app
flutter run
