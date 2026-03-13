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
  Timer? _resumeTimer;

  @override
  void initState() {
    super.initState();
    _autoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _autoRotationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _startDragX = details.globalPosition.dx;
    // 记录当前总旋转角度（手动+自动）
    _startRotation = _currentRotation;
    _isManualRotating = true;
    _resumeTimer?.cancel();
    _autoRotationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - _startDragX;
    setState(() {
      // 基于起始角度加上拖动的增量
      _currentRotation = _startRotation + dx * 0.005;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _isManualRotating = false;
    // 2秒后恢复自动旋转
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (!_isManualRotating && mounted) {
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

            // 旋转地球仪（2D球型）
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: AnimatedBuilder(
                    animation: _autoRotationController,
                    builder: (context, child) {
                      final autoAngle = _autoRotationController.value * 2 * 3.14159;
                      // 手动操作时只使用手动角度，自动时使用自动角度
                      final angle = _isManualRotating ? _currentRotation : autoAngle;
                      return Transform.rotate(
                        angle: angle,
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
                                    children: _buildContinents2D(),
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
                      );
                    },
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
    // 2D大陆形状（简化版圆形/椭圆）
    return [
      // 亚洲
      Positioned(
        top: 50,
        right: 30,
        child: _continent2D(90, 70, const Color(0xFF2E7D32)),
      ),
      // 欧洲
      Positioned(
        top: 60,
        left: 70,
        child: _continent2D(50, 40, const Color(0xFF388E3C)),
      ),
      // 非洲
      Positioned(
        top: 100,
        left: 80,
        child: _continent2D(55, 85, const Color(0xFF2E7D32)),
      ),
      // 北美
      Positioned(
        top: 40,
        left: 20,
        child: _continent2D(80, 60, const Color(0xFF388E3C)),
      ),
      // 南美
      Positioned(
        bottom: 50,
        left: 60,
        child: _continent2D(50, 80, const Color(0xFF2E7D32)),
      ),
      // 澳洲
      Positioned(
        bottom: 70,
        right: 50,
        child: _continent2D(60, 45, const Color(0xFF388E3C)),
      ),
      // 南极（底部）
      Positioned(
        bottom: 0,
        left: 90,
        child: _continent2D(100, 40, const Color(0xFFFFFFFF).withOpacity(0.8)),
      ),
      // 格陵兰
      Positioned(
        top: 20,
        left: 60,
        child: _continent2D(35, 25, const Color(0xFFFFFFFF).withOpacity(0.7)),
      ),
    ];
  }

  Widget _continent2D(double width, double height, Color color) {
    return Container(
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
    );
  }
}
