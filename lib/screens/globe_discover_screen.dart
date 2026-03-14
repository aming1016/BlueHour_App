import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 冒泡留言数据
class BubbleMessage {
  final String avatar;
  final String nickname;
  final String message;
  final double x; // 屏幕X坐标
  final double y; // 屏幕Y坐标
  final String id;
  
  BubbleMessage({
    required this.avatar,
    required this.nickname,
    required this.message,
    required this.x,
    required this.y,
    required this.id,
  });
}

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
  bool _isDragging = false;
  Timer? _resumeTimer;
  
  // 缓存大陆 widgets，避免每帧重建
  late final List<Widget> _continents;
  
  // 冒泡留言相关
  final List<BubbleMessage> _bubbles = [];
  double _lastRotation = 0.0;
  static const double _rotationThreshold = 0.5;
  
  // 地球仪中心位置和半径
  final double _globeRadius = 140;
  
  // 模拟用户数据
  final List<Map<String, String>> _mockUsers = [
    {'avatar': '👨‍🦱', 'nickname': '旅行达人', 'msg': '故宫太美了！'},
    {'avatar': '👩‍🦰', 'nickname': '小王', 'msg': '成都火锅绝了'},
    {'avatar': '🧑‍🦲', 'nickname': '摄影师', 'msg': '西湖日落超赞'},
    {'avatar': '👱‍♀️', 'nickname': '美食家', 'msg': '西安肉夹馍好吃'},
    {'avatar': '👨‍🦳', 'nickname': '背包客', 'msg': '长城打卡成功'},
    {'avatar': '👩‍🦳', 'nickname': '文艺青年', 'msg': '丽江古城很浪漫'},
    {'avatar': '🧑‍🦱', 'nickname': '探险家', 'msg': '九寨沟风景如画'},
    {'avatar': '👱‍♂️', 'nickname': '吃货', 'msg': '广州早茶必吃'},
  ];

  @override
  void initState() {
    super.initState();
    _continents = _buildContinents2D();
    
    // 延迟初始化冒泡（等布局完成后）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateBubbles();
    });
    
    _autoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(_onAnimationUpdate);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isDragging) {
        _autoRotationController.repeat();
      }
    });
  }
  
  void _onAnimationUpdate() {
    if (!mounted || _isDragging) return;
    final newRotation = _autoRotationController.value * 2 * math.pi;
    _checkRotationAndUpdateBubbles(newRotation);
    setState(() {
      _currentRotation = newRotation;
    });
  }
  
  void _checkRotationAndUpdateBubbles(double newRotation) {
    final rotationDelta = (newRotation - _lastRotation).abs();
    if (rotationDelta > _rotationThreshold) {
      _lastRotation = newRotation;
      _generateBubbles();
    }
  }
  
  void _generateBubbles() {
    final random = math.Random();
    final newBubbles = <BubbleMessage>[];
    
    // 获取地球仪在屏幕中的位置
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final size = renderBox.size;
    final globeCenterX = size.width / 2;
    final globeCenterY = size.height * 0.35; // 地球仪中心在屏幕35%位置
    
    final bubbleCount = 3 + random.nextInt(3);
    
    for (int i = 0; i < bubbleCount; i++) {
      final user = _mockUsers[random.nextInt(_mockUsers.length)];
      
      // 在地球周围生成位置（但不覆盖地球中心）
      double x = 0;
      double y = 0;
      bool validPosition = false;
      int attempts = 0;
      
      while (!validPosition && attempts < 50) {
        final angle = random.nextDouble() * 2 * math.pi;
        final distance = _globeRadius + 20 + random.nextDouble() * 80;
        
        x = globeCenterX + math.cos(angle) * distance;
        y = globeCenterY + math.sin(angle) * distance;
        
        // 确保在屏幕范围内且不太靠边
        if (x > 60 && x < size.width - 60 && y > 100 && y < size.height - 100) {
          validPosition = true;
        }
        attempts++;
      }
      
      if (validPosition) {
        newBubbles.add(BubbleMessage(
          avatar: user['avatar']!,
          nickname: user['nickname']!,
          message: user['msg']!,
          x: x,
          y: y,
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
        ));
      }
    }
    
    setState(() {
      _bubbles.clear();
      _bubbles.addAll(newBubbles);
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
    final newRotation = _startRotation + dx * 0.005;
    _checkRotationAndUpdateBubbles(newRotation);
    setState(() {
      _currentRotation = newRotation;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    _resumeTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && !_isDragging) {
        _autoRotationController.forward(from: _currentRotation / (2 * math.pi));
        _autoRotationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 主内容列
            Column(
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

                // 地球仪 - 向上移动，使用 Padding 调整位置
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                                      children: _continents,
                                    ),
                                  ),
                                ),

                                // 球型光晕效果
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
              ],
            ),
            
            // 冒泡留言层 - 在地球仪外面，不随地球转动
            ..._buildBubbleWidgets(),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildBubbleWidgets() {
    return _bubbles.map((bubble) {
      return Positioned(
        left: bubble.x - 60,
        top: bubble.y - 25,
        child: BubbleWidget(
          key: ValueKey(bubble.id),
          avatar: bubble.avatar,
          nickname: bubble.nickname,
          message: bubble.message,
        ),
      );
    }).toList();
  }

  List<Widget> _buildContinents2D() {
    return [
      Positioned(top: 50, right: 30, child: _buildContinentWidget(90, 70, const Color(0xFF2E7D32))),
      Positioned(top: 60, left: 70, child: _buildContinentWidget(50, 40, const Color(0xFF388E3C))),
      Positioned(top: 100, left: 80, child: _buildContinentWidget(55, 85, const Color(0xFF2E7D32))),
      Positioned(top: 40, left: 20, child: _buildContinentWidget(80, 60, const Color(0xFF388E3C))),
      Positioned(bottom: 50, left: 60, child: _buildContinentWidget(50, 80, const Color(0xFF2E7D32))),
      Positioned(bottom: 70, right: 50, child: _buildContinentWidget(60, 45, const Color(0xFF388E3C))),
      Positioned(bottom: 0, left: 90, child: _buildContinentWidget(100, 40, const Color(0xFFFFFFFF).withOpacity(0.8))),
      Positioned(top: 20, left: 60, child: _buildContinentWidget(35, 25, const Color(0xFFFFFFFF).withOpacity(0.7))),
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
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8),
          ],
        ),
      ),
    );
  }
}

/// 冒泡留言组件 - 带入场动画
class BubbleWidget extends StatefulWidget {
  final String avatar;
  final String nickname;
  final String message;
  
  const BubbleWidget({
    super.key,
    required this.avatar,
    required this.nickname,
    required this.message,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    Future.delayed(Duration(milliseconds: math.Random().nextInt(300)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.avatar,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.nickname,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A90D9),
                    ),
                  ),
                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
