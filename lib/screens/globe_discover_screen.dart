import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 国家数据
class CountryData {
  final String code; // 国家代码
  final String name; // 国家名称
  final String emoji; // 国旗emoji
  final Color color; // 地图颜色
  final List<Offset> points; // 简化地图点坐标
  
  CountryData({
    required this.code,
    required this.name,
    required this.emoji,
    required this.color,
    required this.points,
  });
}

/// 冒泡留言数据
class BubbleMessage {
  final String avatar;
  final String nickname;
  final String message;
  final double x;
  final double y;
  final String countryCode;
  final String id;
  
  BubbleMessage({
    required this.avatar,
    required this.nickname,
    required this.message,
    required this.x,
    required this.y,
    required this.countryCode,
    required this.id,
  });
}

/// 地图发现页面 - 世界地图
class GlobeDiscoverScreen extends StatefulWidget {
  const GlobeDiscoverScreen({super.key});

  @override
  State<GlobeDiscoverScreen> createState() => _GlobeDiscoverScreenState();
}

class _GlobeDiscoverScreenState extends State<GlobeDiscoverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _bubbleTimer;
  
  // 当前选中的国家/视图
  String _selectedView = 'CN'; // 'CN'=中国, 'WORLD'=全球, 'US'=美国, 'JP'=日本等
  
  // 冒泡留言
  final List<BubbleMessage> _bubbles = [];
  
  // 模拟用户数据
  final List<Map<String, String>> _mockUsers = [
    {'avatar': '👨‍🦱', 'nickname': '旅行达人', 'msg': '故宫太美了！', 'country': 'CN'},
    {'avatar': '👩‍🦰', 'nickname': '小王', 'msg': '成都火锅绝了', 'country': 'CN'},
    {'avatar': '🧑‍🦲', 'nickname': '摄影师', 'msg': '西湖日落超赞', 'country': 'CN'},
    {'avatar': '👱‍♀️', 'nickname': '美食家', 'msg': '西安肉夹馍好吃', 'country': 'CN'},
    {'avatar': '👨‍🦳', 'nickname': '背包客', 'msg': '长城打卡成功', 'country': 'CN'},
    {'avatar': '👩‍🦳', 'nickname': '文艺青年', 'msg': '丽江古城很浪漫', 'country': 'CN'},
    {'avatar': '🧑‍🦱', 'nickname': '探险家', 'msg': '九寨沟风景如画', 'country': 'CN'},
    {'avatar': '👱‍♂️', 'nickname': '吃货', 'msg': '广州早茶必吃', 'country': 'CN'},
    {'avatar': '👨‍💼', 'nickname': 'Tom', 'msg': 'NYC is amazing!', 'country': 'US'},
    {'avatar': '👩‍💻', 'nickname': 'Yuki', 'msg': '東京タワー最高！', 'country': 'JP'},
    {'avatar': '🧑‍🎨', 'nickname': 'Pierre', 'msg': 'Paris est magnifique', 'country': 'FR'},
    {'avatar': '👨‍🍳', 'nickname': 'Mario', 'msg': 'Pizza in Roma!', 'country': 'IT'},
  ];
  
  // 国家列表
  final List<Map<String, dynamic>> _countries = [
    {'code': 'CN', 'name': '中国', 'emoji': '🇨🇳'},
    {'code': 'US', 'name': '美国', 'emoji': '🇺🇸'},
    {'code': 'JP', 'name': '日本', 'emoji': '🇯🇵'},
    {'code': 'FR', 'name': '法国', 'emoji': '🇫🇷'},
    {'code': 'IT', 'name': '意大利', 'emoji': '🇮🇹'},
    {'code': 'WORLD', 'name': '全球', 'emoji': '🌍'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // 延迟生成冒泡
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _generateBubbles();
    });
    
    // 定时刷新冒泡
    _bubbleTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted) _generateBubbles();
    });
  }
  
  void _generateBubbles() {
    final random = math.Random();
    final newBubbles = <BubbleMessage>[];
    
    // 筛选当前视图的用户
    List<Map<String, String>> filteredUsers;
    if (_selectedView == 'WORLD') {
      filteredUsers = _mockUsers;
    } else {
      filteredUsers = _mockUsers.where((u) => u['country'] == _selectedView).toList();
    }
    
    if (filteredUsers.isEmpty) {
      filteredUsers = _mockUsers.where((u) => u['country'] == 'CN').toList();
    }
    
    final bubbleCount = math.min(4, filteredUsers.length);
    
    for (int i = 0; i < bubbleCount; i++) {
      final user = filteredUsers[random.nextInt(filteredUsers.length)];
      
      // 在地图区域内随机位置
      final x = 40.0 + random.nextDouble() * 200;
      final y = 40.0 + random.nextDouble() * 160;
      
      newBubbles.add(BubbleMessage(
        avatar: user['avatar']!,
        nickname: user['nickname']!,
        message: user['msg']!,
        x: x,
        y: y,
        countryCode: user['country']!,
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
    _bubbleTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题 + 筛选器
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    '探索',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // 国家筛选下拉
                  _buildCountrySelector(),
                ],
              ),
            ),

            // 地图区域 - 向上移动
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF1A3A5C),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // 渐变背景
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF1A3A5C),
                                const Color(0xFF0D2137),
                              ],
                            ),
                          ),
                        ),
                        
                        // 地图大陆
                        CustomPaint(
                          size: Size.infinite,
                          painter: _MapBackgroundPainter(selectedView: _selectedView),
                        ),
                        
                        // 网格线和高亮边框
                        CustomPaint(
                          size: Size.infinite,
                          painter: _MapOutlinePainter(selectedView: _selectedView),
                        ),
                        
                        // 冒泡留言
                        ..._buildBubbleWidgets(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部统计信息
            _buildBottomStats(),
          ],
        ),
      ),
    );
  }
  
  /// 国家选择器
  Widget _buildCountrySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: PopupMenuButton<String>(
        initialValue: _selectedView,
        onSelected: (value) {
          setState(() {
            _selectedView = value;
          });
          _generateBubbles();
        },
        itemBuilder: (context) {
          return _countries.map((country) {
            return PopupMenuItem<String>(
              value: country['code'],
              child: Row(
                children: [
                  Text(country['emoji'], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    country['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _countries.firstWhere((c) => c['code'] == _selectedView)['emoji'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 4),
            Text(
              _countries.firstWhere((c) => c['code'] == _selectedView)['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建冒泡
  List<Widget> _buildBubbleWidgets() {
    return _bubbles.map((bubble) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        left: bubble.x,
        top: bubble.y,
        child: BubbleWidget(
          key: ValueKey(bubble.id),
          avatar: bubble.avatar,
          nickname: bubble.nickname,
          message: bubble.message,
          countryCode: bubble.countryCode,
        ),
      );
    }).toList();
  }
  
  /// 底部统计
  Widget _buildBottomStats() {
    final onlineCount = 128 + math.Random().nextInt(500);
    final streamCount = 12 + math.Random().nextInt(30);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('👥', '在线用户', '$onlineCount'),
          _buildStatItem('📹', '直播中', '$streamCount'),
          _buildStatItem('🌟', '热门地点', '${_selectedView == 'WORLD' ? '全球' : _countries.firstWhere((c) => c['code'] == _selectedView)['name']}'),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

/// 地图背景绘制器
class _MapBackgroundPainter extends CustomPainter {
  final String selectedView;
  
  _MapBackgroundPainter({required this.selectedView});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A5A8C).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // 绘制简化的大陆形状
    if (selectedView == 'CN' || selectedView == 'WORLD') {
      _drawChina(canvas, size, paint);
    }
    if (selectedView == 'US' || selectedView == 'WORLD') {
      _drawUSA(canvas, size, paint);
    }
    if (selectedView == 'JP' || selectedView == 'WORLD') {
      _drawJapan(canvas, size, paint);
    }
    if (selectedView == 'WORLD') {
      _drawEurope(canvas, size, paint);
      _drawAustralia(canvas, size, paint);
    }
  }
  
  void _drawChina(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    // 简化的中国轮廓（公鸡形状）
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.45;
    final scale = selectedView == 'CN' ? 1.2 : 0.6;
    
    path.moveTo(centerX - 60 * scale, centerY - 80 * scale);
    path.lineTo(centerX + 40 * scale, centerY - 90 * scale);
    path.lineTo(centerX + 80 * scale, centerY - 40 * scale);
    path.lineTo(centerX + 70 * scale, centerY + 20 * scale);
    path.lineTo(centerX + 50 * scale, centerY + 60 * scale);
    path.lineTo(centerX - 20 * scale, centerY + 50 * scale);
    path.lineTo(centerX - 70 * scale, centerY + 10 * scale);
    path.lineTo(centerX - 80 * scale, centerY - 40 * scale);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawUSA(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final centerX = size.width * (selectedView == 'US' ? 0.5 : 0.2);
    final centerY = size.height * (selectedView == 'US' ? 0.5 : 0.3);
    final scale = selectedView == 'US' ? 1.0 : 0.4;
    
    path.moveTo(centerX - 50 * scale, centerY - 40 * scale);
    path.lineTo(centerX + 50 * scale, centerY - 45 * scale);
    path.lineTo(centerX + 60 * scale, centerY + 10 * scale);
    path.lineTo(centerX + 40 * scale, centerY + 50 * scale);
    path.lineTo(centerX - 40 * scale, centerY + 45 * scale);
    path.lineTo(centerX - 60 * scale, centerY);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawJapan(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width * (selectedView == 'JP' ? 0.5 : 0.75);
    final centerY = size.height * (selectedView == 'JP' ? 0.5 : 0.35);
    final scale = selectedView == 'JP' ? 1.0 : 0.3;
    
    // 日本列岛简化
    canvas.drawCircle(Offset(centerX, centerY - 30 * scale), 15 * scale, paint);
    canvas.drawCircle(Offset(centerX + 10 * scale, centerY), 20 * scale, paint);
    canvas.drawCircle(Offset(centerX - 5 * scale, centerY + 35 * scale), 18 * scale, paint);
  }
  
  void _drawEurope(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.25;
    
    canvas.drawCircle(Offset(centerX, centerY), 30, paint);
    canvas.drawCircle(Offset(centerX - 40, centerY + 10), 20, paint);
    canvas.drawCircle(Offset(centerX + 35, centerY - 5), 18, paint);
  }
  
  void _drawAustralia(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width * 0.75;
    final centerY = size.height * 0.75;
    
    canvas.drawCircle(Offset(centerX, centerY), 35, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 地图轮廓绘制器
class _MapOutlinePainter extends CustomPainter {
  final String selectedView;
  
  _MapOutlinePainter({required this.selectedView});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A9AD4).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // 绘制网格线
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // 横向网格
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    // 纵向网格
    for (int i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    
    // 根据视图绘制边框高亮
    if (selectedView != 'WORLD') {
      final borderPaint = Paint()
        ..color = const Color(0xFFFF6B35).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(18)),
        borderPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter) => true;
}

/// 冒泡留言组件
class BubbleWidget extends StatefulWidget {
  final String avatar;
  final String nickname;
  final String message;
  final String countryCode;
  
  const BubbleWidget({
    super.key,
    required this.avatar,
    required this.nickname,
    required this.message,
    required this.countryCode,
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
      duration: const Duration(milliseconds: 500),
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
    
    _controller.forward();
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
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.avatar, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Column(
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
          ],
        ),
      ),
    );
  }
}
