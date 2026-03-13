import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'live_room_screen.dart';

/// 抖音风格首页 - 全屏沉浸式直播流
/// 上下滑动切换直播间，双击点赞，右侧交互按钮
class TiktokHomeScreen extends StatefulWidget {
  const TiktokHomeScreen({super.key});

  @override
  State<TiktokHomeScreen> createState() => _TiktokHomeScreenState();
}

class _TiktokHomeScreenState extends State<TiktokHomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLiked = false;
  
  // 模拟直播数据
  final List<Map<String, dynamic>> liveStreams = [
    {
      'id': '1',
      'title': '🏛️ 北京故宫直播',
      'streamer': '导游小王',
      'avatar': '👨‍💼',
      'viewers': '12.5k',
      'location': '北京·故宫',
      'isLive': true,
      'color': const Color(0xFFFF6B35),
    },
    {
      'id': '2',
      'title': '🐼 成都熊猫基地',
      'streamer': '熊猫守护者',
      'avatar': '🐼',
      'viewers': '8.3k',
      'location': '成都·大熊猫基地',
      'isLive': true,
      'color': const Color(0xFF34C759),
    },
    {
      'id': '3',
      'title': '🌸 杭州西湖漫步',
      'streamer': '江南导游',
      'avatar': '👩‍🦰',
      'viewers': '5.2k',
      'location': '杭州·西湖',
      'isLive': true,
      'color': const Color(0xFF5856D6),
    },
    {
      'id': '4',
      'title': '🏺 西安古城墙',
      'streamer': '历史达人',
      'avatar': '🧔',
      'viewers': '3.8k',
      'location': '西安·古城墙',
      'isLive': true,
      'color': const Color(0xFFFF9500),
    },
  ];

  void _onDoubleTap() {
    setState(() {
      _isLiked = true;
    });
    // 显示爱心动画
    _showLikeAnimation();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  void _showLikeAnimation() {
    // 爱心动画逻辑
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 全屏直播流 - PageView上下滑动
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: liveStreams.length,
            itemBuilder: (context, index) {
              return _buildLivePage(liveStreams[index]);
            },
          ),
          
          // 右侧交互按钮列
          Positioned(
            right: 8,
            bottom: 100,
            child: _buildRightActionButtons(),
          ),
          
          // 底部信息区
          Positioned(
            left: 16,
            right: 80,
            bottom: 100,
            child: _buildBottomInfo(),
          ),
        ],
      ),
    );
  }

  /// 单个直播页面
  Widget _buildLivePage(Map<String, dynamic> stream) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 背景渐变（模拟直播画面）
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  stream['color'].withOpacity(0.8),
                  stream['color'].withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          
          // 中央加载图标（模拟视频加载）
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '正在直播: ${stream['title']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // 双击爱心动画
          if (_isLiked && _currentIndex == liveStreams.indexOf(stream))
            Center(
              child: AnimatedOpacity(
                opacity: _isLiked ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(
                  Icons.favorite,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 顶部导航栏
  Widget _buildTopNavigation() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 关注 / 推荐 切换
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildTabButton('关注', false),
                  _buildTabButton('推荐', true),
                  _buildTabButton('同城', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  /// 右侧交互按钮列
  Widget _buildRightActionButtons() {
    final stream = liveStreams[_currentIndex];
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主播头像
        _buildAvatarButton(stream['avatar'], stream['isLive']),
        const SizedBox(height: 20),
        
        // 点赞
        _buildActionButton(
          Icons.favorite,
          '12.5k',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        
        // 评论
        _buildActionButton(
          Icons.chat_bubble,
          '3.2k',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        
        // 分享
        _buildActionButton(
          Icons.share,
          '分享',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        
        // 礼物
        _buildActionButton(
          Icons.card_giftcard,
          '礼物',
          onTap: () {},
          isGift: true,
        ),
      ],
    );
  }

  Widget _buildAvatarButton(String emoji, bool isLive) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        if (isLive)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap, bool isGift = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGift ? const Color(0xFFFF6B35) : Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 底部信息区
  Widget _buildBottomInfo() {
    final stream = liveStreams[_currentIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主播信息
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '直播中',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '@${stream['streamer']}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '+ 关注',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 标题
        Text(
          stream['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // 位置
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              stream['location'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.visibility,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              '${stream['viewers']} 观看',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 弹幕滚动效果（简化版）
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '🔥 主播带你游故宫，快来看看！',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  /// 底部导航栏
  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, '首页', true),
              _buildNavItem(Icons.explore, '发现', false),
              _buildPlusButton(),
              _buildNavItem(Icons.chat, '消息', false),
              _buildNavItem(Icons.person, '我', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildPlusButton() {
    return Container(
      width: 44,
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
