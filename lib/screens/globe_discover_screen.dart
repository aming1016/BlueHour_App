import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 冒泡留言数据
class BubbleMessage {
  final String avatar;
  final String nickname;
  final String message;
  final double angle; // 在地球上的角度位置
  final double distance; // 距离地球中心的距离
  final String id;
  
  BubbleMessage({
    required this.avatar,
    required this.nickname,
    required this.message,
    required this.angle,
    required this.distance,
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
  bool _isManualRotating = false;
  bool _isDragging = false;
  Timer? _resumeTimer;
  
  // 缓存大陆 widgets，避免每帧重建
  late final List<Widget> _continents;
  
  // 冒泡留言相关
  final List<BubbleMessage> _bubbles = [];
  double _lastRotation = 0.0;
  static const double _rotationThreshold = 0.5; // 旋转超过这个值就更新冒泡
  
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
    // 预创建大陆 widgets
    _continents = _buildContinents2D();
    
    // 初始化冒泡
    _generateBubbles();
    
    _autoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
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
    final newRotation = _autoRotationController.value * 2 * 3.14159;
    _checkRotationAndUpdateBubbles(newRotation);
    setState(() {
      _currentRotation = newRotation;
    });
  }
  
  /// 检查旋转角度，超过阈值时更新冒泡
  void _checkRotationAndUpdateBubbles(double newRotation) {
    final rotationDelta = (newRotation - _lastRotation).abs();
    if (rotationDelta > _rotationThreshold) {
      _lastRotation = newRotation;
      _generateBubbles();
    }
  }
  
  /// 生成新的冒泡留言
  void _generateBubbles() {
    final random = math.Random();
    final newBubbles = <BubbleMessage>[];
    
    // 随机生成3-5个冒泡
    final bubbleCount = 3 + random.nextInt(3);
    
    for (int i = 0; i < bubbleCount; i++) {
      final user = _mockUsers[random.nextInt(_mockUsers.length)];
      // 在地球表面随机位置（考虑3D球面效果）
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = 0.6 + random.nextDouble() * 0.25; // 距离中心60%-85%
      
      newBubbles.add(BubbleMessage(
        avatar: user['avatar']!,
        nickname: user['nickname']!,
        message: user['msg']!,
        angle: angle,
        distance: distance,
        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
      ));
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
                            
                            // 冒泡留言层
                            ..._buildBubbleWidgets(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部留白（保持布局平衡）
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  /// 构建冒泡留言 widgets
  List<Widget> _buildBubbleWidgets() {
    return _bubbles.map((bubble) {
      // 计算冒泡位置（考虑当前旋转角度）
      final adjustedAngle = bubble.angle - _currentRotation;
      final x = 140 + math.cos(adjustedAngle) * bubble.distance * 140;
      final y = 140 + math.sin(adjustedAngle) * bubble.distance * 140;
      
      // 判断是否在地球背面（简单判断：根据角度和旋转）
      final isVisible = math.cos(adjustedAngle) > -0.3;
      
      if (!isVisible) return const SizedBox.shrink();
      
      return Positioned(
        left: x - 60,
        top: y - 25,
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
    
    // 延迟启动动画，产生错落感
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
            // 头像
            Text(
              widget.avatar,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 6),
            // 昵称和留言
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
