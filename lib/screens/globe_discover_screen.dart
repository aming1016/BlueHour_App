import 'package:flutter/material.dart';

/// 地球仪发现页面 - 旋转地球仪
class GlobeDiscoverScreen extends StatefulWidget {
  const GlobeDiscoverScreen({super.key});

  @override
  State<GlobeDiscoverScreen> createState() => _GlobeDiscoverScreenState();
}

class _GlobeDiscoverScreenState extends State<GlobeDiscoverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _autoRotationController;
  double _manualRotationX = 0.0;
  double _manualRotationY = 0.0;
  double _startX = 0.0;
  double _startY = 0.0;

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
    _autoRotationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _startX = _manualRotationX;
    _startY = _manualRotationY;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _manualRotationX = _startX + details.delta.dx * 0.01;
      _manualRotationY = _startY + details.delta.dy * 0.01;
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: const Text(
                  '探索',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // 旋转地球仪
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  child: AnimatedBuilder(
                    animation: _autoRotationController,
                    builder: (context, child) {
                      final autoAngle = _autoRotationController.value * 2 * 3.14159;
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateY(autoAngle + _manualRotationX)
                          ..rotateX(_manualRotationY),
                        alignment: Alignment.center,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0xFF4A90D9),
                                Color(0xFF1E3A5F),
                              ],
                              center: Alignment(-0.3, -0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A90D9).withOpacity(0.5),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 地球纹理
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
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
                              ),

                              // 大陆轮廓
                              ..._buildContinents(),

                              // 光晕效果
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                    center: const Alignment(-0.3, -0.3),
                                    radius: 0.6,
                                  ),
                                ),
                              ),

                              // 中心文字
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '🌍',
                                    style: TextStyle(fontSize: 60),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '探索世界',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '拖动地球旋转',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
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
              child: Text(
                '自动旋转中，可手动拖动',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContinents() {
    return [
      Positioned(top: 60, right: 50, child: _continent(80, 60)),
      Positioned(top: 70, left: 80, child: _continent(50, 40)),
      Positioned(top: 110, left: 90, child: _continent(50, 70)),
      Positioned(top: 50, left: 40, child: _continent(70, 50)),
      Positioned(bottom: 60, left: 70, child: _continent(45, 70)),
      Positioned(bottom: 80, right: 70, child: _continent(50, 40)),
    ];
  }

  Widget _continent(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
