import 'dart:async';
import 'package:flutter/material.dart';

/// 地球仪发现页面 - 2D地球旋转
class GlobeDiscoverScreen extends StatefulWidget {
  const GlobeDiscoverScreen({super.key});

  @override
  State<GlobeDiscoverScreen> createState() => _GlobeDiscoverScreenState();
}

class _GlobeDiscoverScreenState extends State<GlobeDiscoverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _autoRotationController;
  double _currentRotation = 0.0;
  double _startRotation = 0.0;
  double _startDragX = 0.0;
  bool _isManualRotating = false;
  bool _isDragging = false;
  Timer? _resumeTimer;
  
  // 缓存大陆 widgets，避免每帧重建
  late final List<Widget> _continents;

  @override
  void initState() {
    super.initState();
    // 预创建大陆 widgets
    _continents = _buildContinents2D();
    
    _autoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // 减慢自动旋转速度
    )..addListener(_onAnimationUpdate);
    
    // 延迟启动自动旋转
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isManualRotating) {
        _autoRotationController.repeat();
      }
    });
  }
  
  void _onAnimationUpdate() {
    if (!mounted || _isManualRotating || _isDragging) return;
    setState(() {
      _currentRotation = _autoRotationController.value * 2 * 3.14159;
    });
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _autoRotationController.removeListener(_onAnimationUpdate);
    _autoRotationController.dispose();
    super.dispose();
  }

  double _startDragY = 0.0;

  void _onPanStart(DragStartDetails details) {
    _startDragX = details.globalPosition.dx;
    _startDragY = details.globalPosition.dy;
    _startRotation = _currentRotation;
    _isDragging = true;
    _resumeTimer?.cancel();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - _startDragX;
    final dy = details.globalPosition.dy - _startDragY;
    setState(() {
      // 优化：只响应水平拖动，更流畅
      _currentRotation = _startRotation + dx * 0.005;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    // 1.5秒后恢复自动旋转
    _resumeTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && !_isDragging) {
        _autoRotationController.forward(from: _currentRotation / (2 * 3.14159));
        _autoRotationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '探索',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 旋转地球仪（2D球型）- 优化版
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: RepaintBoundary(
                    child: Transform.rotate(
                      angle: _currentRotation,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0xFF4A90D9),
                              Color(0xFF1E3A5F),
                            ],
                            center: Alignment(-0.3, -0.3),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 地球圆形剪切
                            ClipOval(
                              child: Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF4A90D9).withOpacity(0.8),
                                      const Color(0xFF2E7D32).withOpacity(0.6),
                                      const Color(0xFF1E3A5F).withOpacity(0.9),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: _continents, // 使用缓存的大陆
                                ),
                              ),
                            ),

                            // 球型光晕效果（让看起来是3D球型）
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.15),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                  center: const Alignment(-0.3, -0.3),
                                  radius: 0.8,
                                ),
                              ),
                            ),

                            // 边框光晕
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4A90D9).withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 底部提示
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '🌍',
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '拖动地球旋转探索',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContinents2D() {
    // 2D大陆形状（简化版圆形/椭圆）- 预创建避免重建
    return [
      // 亚洲
      Positioned(
        top: 50,
        right: 30,
        child: _buildContinentWidget(90, 70, const Color(0xFF2E7D32)),
      ),
      // 欧洲
      Positioned(
        top: 60,
        left: 70,
        child: _buildContinentWidget(50, 40, const Color(0xFF388E3C)),
      ),
      // 非洲
      Positioned(
        top: 100,
        left: 80,
        child: _buildContinentWidget(55, 85, const Color(0xFF2E7D32)),
      ),
      // 北美
      Positioned(
        top: 40,
        left: 20,
        child: _buildContinentWidget(80, 60, const Color(0xFF388E3C)),
      ),
      // 南美
      Positioned(
        bottom: 50,
        left: 60,
        child: _buildContinentWidget(50, 80, const Color(0xFF2E7D32)),
      ),
      // 澳洲
      Positioned(
        bottom: 70,
        right: 50,
        child: _buildContinentWidget(60, 45, const Color(0xFF388E3C)),
      ),
      // 南极（底部）
      Positioned(
        bottom: 0,
        left: 90,
        child: _buildContinentWidget(100, 40, const Color(0xFFFFFFFF).withOpacity(0.8)),
      ),
      // 格陵兰
      Positioned(
        top: 20,
        left: 60,
        child: _buildContinentWidget(35, 25, const Color(0xFFFFFFFF).withOpacity(0.7)),
      ),
    ];
  }
  
  Widget _buildContinentWidget(double width, double height, Color color) {
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }

}
