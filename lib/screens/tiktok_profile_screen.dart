import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'wallet_screen.dart';
import 'wallet_screen.dart';

/// 抖音风格个人中心 - 数据看板+作品展示
class TiktokProfileScreen extends StatefulWidget {
  const TiktokProfileScreen({super.key});

  @override
  State<TiktokProfileScreen> createState() => _TiktokProfileScreenState();
}

class _TiktokProfileScreenState extends State<TiktokProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 模拟作品数据
  final List<Map<String, dynamic>> works = [
    {'type': 'live', 'views': '12.5k', 'title': '故宫直播'},
    {'type': 'video', 'views': '8.3k', 'title': '长城行'},
    {'type': 'live', 'views': '5.2k', 'title': '西湖漫步'},
    {'type': 'video', 'views': '3.8k', 'title': '成都美食'},
    {'type': 'live', 'views': '2.1k', 'title': '西安古城'},
    {'type': 'video', 'views': '1.5k', 'title': '杭州夜景'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 顶部背景图
              SliverToBoxAdapter(
                child: _buildHeaderBackground(),
              ),
              
              // 用户信息
              SliverToBoxAdapter(
                child: _buildUserInfo(),
              ),
              
              // 数据统计
              SliverToBoxAdapter(
                child: _buildStats(),
              ),
              
              // 操作按钮
              SliverToBoxAdapter(
                child: _buildActionButtons(),
              ),
              
              // 个人简介
              SliverToBoxAdapter(
                child: _buildBio(),
              ),
              
              // Tab栏
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFFFF6B35),
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.5),
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: '作品 24'),
                      Tab(text: '喜欢 156'),
                      Tab(text: '收藏 32'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildWorksGrid(),
              _buildLikedGrid(),
              _buildSavedGrid(),
            ],
          ),
        ),
      ),
    );
  }

  /// 顶部背景图
  Widget _buildHeaderBackground() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.8),
            const Color(0xFF5856D6).withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 装饰圆点
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // 返回和菜单按钮
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  /// 用户信息
  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // 头像
          Transform.translate(
            offset: const Offset(0, -40),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '👨‍💼',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          
          Transform.translate(
            offset: const Offset(0, -30),
            child: Column(
              children: [
                // 用户名
                const Text(
                  '@导游小王',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // ID
                Text(
                  'ID: 123456789',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 标签
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag('🏅 优质主播'),
                    const SizedBox(width: 8),
                    _buildTag('📍 北京'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white70,
        ),
      ),
    );
  }

  /// 数据统计 + 钱包入口
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('获赞', '12.5万'),
          _buildStatDivider(),
          _buildStatItem('关注', '128'),
          _buildStatDivider(),
          _buildStatItem('粉丝', '5.2万'),
          _buildStatDivider(),
          _buildWalletButton(), // 钱包入口
        ],
      ),
    );
  }

  /// 钱包入口按钮
  Widget _buildWalletButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WalletScreen(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 20,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '钱包',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withOpacity(0.2),
    );
  }

  /// 操作按钮
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // 编辑资料
          Expanded(
            flex: 2,
            child: _buildActionButton(
              '编辑资料',
              isPrimary: false,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          // 钱包入口
          Expanded(
            flex: 2,
            child: _buildActionButton(
              '💰 钱包',
              isPrimary: false,
              onTap: () => _openWallet(),
            ),
          ),
          const SizedBox(width: 12),
          // 开播
          Expanded(
            flex: 3,
            child: _buildActionButton(
              '🎥 开始直播',
              isPrimary: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  /// 打开钱包页面
  void _openWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      ),
    );
  }

  Widget _buildActionButton(String text, {required bool isPrimary, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFFF6B35) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  /// 个人简介
  Widget _buildBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ 专业导游，带你游遍中国大好河山\n🏛️ 故宫、长城、颐和园，带你领略古都魅力\n📸 分享最真实的中国风景',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.link,
                size: 14,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
              Text(
                'https://travel.live/wangdao',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF5AC8FA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 作品网格
  Widget _buildWorksGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: works.length,
      itemBuilder: (context, index) {
        final work = works[index];
        return _buildWorkItem(work);
      },
    );
  }

  Widget _buildWorkItem(Map<String, dynamic> work) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 渐变背景
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2C2C2E),
                  const Color(0xFF1C1C1E),
                ],
              ),
            ),
          ),
          
          // 内容
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  work['type'] == 'live' ? Icons.videocam : Icons.play_circle,
                  size: 32,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  work['title'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // 播放量
          Positioned(
            left: 6,
            bottom: 6,
            child: Row(
              children: [
                Icon(
                  Icons.play_arrow,
                  size: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                Text(
                  work['views'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // 直播标识
          if (work['type'] == 'live')
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(2),
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
        ],
      ),
    );
  }

  /// 喜欢的作品
  Widget _buildLikedGrid() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            '喜欢的作品',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 收藏的作品
  Widget _buildSavedGrid() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            '收藏的直播',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// TabBar Delegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
