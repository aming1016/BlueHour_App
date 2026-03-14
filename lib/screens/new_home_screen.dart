import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'live_room_screen.dart';

/// P0 优化版首页 - 高留存设计
/// 新增: Banner轮播 + 快捷入口 + 关注主播 + 混合内容流
class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  String _selectedFilter = 'recommend';
  Timer? _bannerTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    // Banner自动轮播 - 延迟3秒后开始
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || _isUserInteracting) return;
      
      final banners = context.read<AppState>().banners;
      if (banners.isEmpty) return;
      
      final nextPage = (_currentBanner + 1) % banners.length;
      
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onUserInteraction() {
    // 用户交互时暂停自动轮播3秒
    _isUserInteracting = true;
    _bannerTimer?.cancel();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _isUserInteracting = false;
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<AppState>().loadStreams();
          },
          child: CustomScrollView(
            slivers: [
              // 顶部 Header
              SliverToBoxAdapter(child: _buildHeader()),
              
              // Banner 轮播
              SliverToBoxAdapter(child: _buildBanner()),
              
              // 快捷入口
              SliverToBoxAdapter(child: _buildQuickEntries()),
              
              // 关注的主播
              SliverToBoxAdapter(child: _buildFollowedStreamers()),
              
              // 混合内容流标题
              SliverToBoxAdapter(child: _buildContentHeader()),
              
              // 混合内容流 (Grid)
              _buildMixedContentGrid(),
              
              // 底部留白
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 顶部 Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8F6B)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Travel Live',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const Spacer(),
          
          // 搜索
          _buildIconButton(Icons.search_rounded, onTap: () {
            // TODO: 搜索功能
          }),
          
          const SizedBox(width: 8),
          
          // 消息
          _buildIconButton(
            Icons.notifications_outlined,
            badge: true,
            onTap: () {
              // TODO: 消息中心
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool badge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          ),
          if (badge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Banner 轮播 - 优化版
  Widget _buildBanner() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final banners = appState.banners;
        if (banners.isEmpty) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 140,
          child: Stack(
            children: [
              // 轮播页面
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _onUserInteraction();
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (index) {
                    setState(() => _currentBanner = index);
                  },
                  physics: const BouncingScrollPhysics(),
                  viewportFraction: 0.92,
                  padEnds: true,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _handleBannerTap(banner),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 背景渐变（始终存在）
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFF6B35).withOpacity(0.95),
                                      const Color(0xFFFF8F6B).withOpacity(0.95),
                                    ],
                                  ),
                                ),
                              ),
                              // 背景图（如果有）- 使用 RepaintBoundary 优化
                              if (banner.imageUrl.isNotEmpty)
                                RepaintBoundary(
                                  child: Image.network(
                                    banner.imageUrl,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                  ),
                                ),
                              // 渐变遮罩
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // 文字内容
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      banner.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        '查看详情 →',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFFF6B35),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 指示器
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: index == _currentBanner ? 20 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == _currentBanner
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleBannerTap(BannerItem banner) {
    switch (banner.actionType) {
      case 'live':
        // TODO: 跳转到指定直播间
        break;
      case 'task':
        // TODO: 跳转到任务页面
        break;
      case 'web':
        // TODO: 打开网页
        break;
    }
  }

  /// 快捷入口
  Widget _buildQuickEntries() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final entries = appState.quickEntries;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: entries.map((entry) => _buildQuickEntryItem(entry)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildQuickEntryItem(QuickEntry entry) {
    final isSelected = _selectedFilter == entry.filter;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedFilter = entry.filter ?? 'recommend');
        // TODO: 根据筛选条件刷新内容
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              entry.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 关注的主播
  Widget _buildFollowedStreamers() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final streamers = appState.followedStreamers;
        final liveStreamers = streamers.where((s) => s['isLive'] == true).toList();
        
        if (streamers.isEmpty) return const SizedBox();
        
        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      '关注的主播',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const Spacer(),
                    if (liveStreamers.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${liveStreamers.length} 人在播',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFFF6B35),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 横向列表
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: streamers.length,
                  itemBuilder: (context, index) {
                    final streamer = streamers[index];
                    return _buildStreamerItem(streamer);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreamerItem(Map<String, dynamic> streamer) {
    final isLive = streamer['isLive'] == true;
    
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          // 头像
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLive ? const Color(0xFFFF3B30) : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Icon(
                      Icons.person,
                      size: 28,
                      color: Color(0xFFCCCCCC),
                    ),
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
          ),
          
          const SizedBox(height: 6),
          
          // 用户名
          Text(
            streamer['username'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 内容区标题
  Widget _buildContentHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            '推荐内容',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          // 内容类型筛选
          _buildContentFilter('全部', true),
          const SizedBox(width: 8),
          _buildContentFilter('直播', false),
          const SizedBox(width: 8),
          _buildContentFilter('视频', false),
        ],
      ),
    );
  }

  Widget _buildContentFilter(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  /// 混合内容流 (Grid)
  Widget _buildMixedContentGrid() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final contents = appState.mixedContent;
        
        return SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final content = contents[index];
                return _buildMixedContentCard(content);
              },
              childCount: contents.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMixedContentCard(MixedContent content) {
    return GestureDetector(
      onTap: () {
        if (content.type == ContentType.live) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveRoomScreen(streamId: content.id),
            ),
          );
        } else {
          // TODO: 跳转到视频/回放详情
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      color: const Color(0xFFE5E5E5),
                      child: content.thumbnailUrl.isNotEmpty
                          ? Image.network(
                              content.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image,
                                color: Color(0xFFCCCCCC),
                              ),
                            )
                          : const Icon(
                              Icons.image,
                              color: Color(0xFFCCCCCC),
                            ),
                    ),
                  ),
                  
                  // 类型标签
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildTypeBadge(content.type),
                  ),
                  
                  // 观看数/时长
                  if (content.viewers != null || content.duration != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (content.type == ContentType.live) ...[
                              const Icon(
                                Icons.visibility,
                                size: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 2),
                            ],
                            Text(
                              content.viewers ?? content.duration ?? '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // 信息区
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // 作者 + 点赞
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            content.author,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (content.likes != null) ...[
                          const Icon(
                            Icons.favorite,
                            size: 12,
                            color: Color(0xFFFF6B35),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            content.likes!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(ContentType type) {
    String label;
    Color color;
    
    switch (type) {
      case ContentType.live:
        label = '直播中';
        color = const Color(0xFFFF3B30);
        break;
      case ContentType.replay:
        label = '回放';
        color = const Color(0xFF6B7280);
        break;
      case ContentType.video:
        label = '短视频';
        color = const Color(0xFF2196F3);
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
