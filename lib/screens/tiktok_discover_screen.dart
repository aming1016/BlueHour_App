import 'package:flutter/material.dart';

/// 抖音风格发现页 - 搜索+热门+分类
class TiktokDiscoverScreen extends StatefulWidget {
  const TiktokDiscoverScreen({super.key});

  @override
  State<TiktokDiscoverScreen> createState() => _TiktokDiscoverScreenState();
}

class _TiktokDiscoverScreenState extends State<TiktokDiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // 热门话题
  final List<Map<String, dynamic>> trendingTopics = [
    {'tag': '#故宫直播', 'views': '1256.3万', 'rank': 1},
    {'tag': '#成都美食', 'views': '892.5万', 'rank': 2},
    {'tag': '#长城徒步', 'views': '567.2万', 'rank': 3},
    {'tag': '#西湖美景', 'views': '423.8万', 'rank': 4},
    {'tag': '#西安古城', 'views': '312.6万', 'rank': 5},
    {'tag': '#熊猫基地', 'views': '298.4万', 'rank': 6},
  ];
  
  // 推荐主播
  final List<Map<String, dynamic>> recommendedStreamers = [
    {'name': '导游小王', 'avatar': '👨‍💼', 'fans': '5.2万', 'isLive': true},
    {'name': '美食探店', 'avatar': '👩‍🍳', 'fans': '3.8万', 'isLive': true},
    {'name': '旅行达人', 'avatar': '🧗', 'fans': '2.1万', 'isLive': false},
    {'name': '历史讲解员', 'avatar': '👨‍🏫', 'fans': '1.5万', 'isLive': true},
  ];
  
  // 热门城市
  final List<Map<String, dynamic>> hotCities = [
    {'name': '北京', 'image': '🏛️', 'liveCount': '128'},
    {'name': '成都', 'image': '🐼', 'liveCount': '89'},
    {'name': '西安', 'image': '🏺', 'liveCount': '56'},
    {'name': '杭州', 'image': '🌸', 'liveCount': '43'},
    {'name': '上海', 'image': '🏙️', 'liveCount': '67'},
    {'name': '广州', 'image': '🥟', 'liveCount': '52'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 搜索栏
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            
            // 热门话题轮播
            SliverToBoxAdapter(
              child: _buildTrendingTopics(),
            ),
            
            // 热门城市
            SliverToBoxAdapter(
              child: _buildHotCities(),
            ),
            
            // 推荐主播
            SliverToBoxAdapter(
              child: _buildRecommendedStreamers(),
            ),
            
            // 热门直播标题
            SliverToBoxAdapter(
              child: _buildSectionTitle('🔥 热门直播'),
            ),
            
            // 热门直播网格
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildLiveCard(index);
                  },
                  childCount: 6,
                ),
              ),
            ),
            
            // 底部留白
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: '搜索主播、城市、话题...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 扫码按钮
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.qr_code_scanner,
              size: 20,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 热门话题
  Widget _buildTrendingTopics() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: trendingTopics.length,
        itemBuilder: (context, index) {
          final topic = trendingTopics[index];
          return _buildTopicCard(topic);
        },
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    final isTop3 = topic['rank'] <= 3;
    
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isTop3
              ? [
                  const Color(0xFFFF6B35).withOpacity(0.8),
                  const Color(0xFFFF8F6B).withOpacity(0.6),
                ]
              : [
                  const Color(0xFF2C2C2E),
                  const Color(0xFF1C1C1E),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 话题标签
                Text(
                  topic['tag'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const Spacer(),
                
                // 播放量
                Row(
                  children: [
                    Icon(
                      Icons.whatshot,
                      size: 14,
                      color: isTop3 ? Colors.white : const Color(0xFFFF6B35),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      topic['views'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 排名标识
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isTop3 ? Colors.white : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${topic['rank']}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isTop3 ? const Color(0xFFFF6B35) : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 热门城市
  Widget _buildHotCities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🏙️ 热门城市'),
        
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hotCities.length,
            itemBuilder: (context, index) {
              final city = hotCities[index];
              return _buildCityCard(city);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityCard(Map<String, dynamic> city) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 城市图标
          Text(
            city['image'],
            style: const TextStyle(fontSize: 32),
          ),
          
          const SizedBox(height: 8),
          
          // 城市名
          Text(
            city['name'],
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // 直播数
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${city['liveCount']} 直播',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFFFF6B35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 推荐主播
  Widget _buildRecommendedStreamers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🌟 推荐主播'),
        
        Container(
          height: 110,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedStreamers.length,
            itemBuilder: (context, index) {
              final streamer = recommendedStreamers[index];
              return _buildStreamerCard(streamer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStreamerCard(Map<String, dynamic> streamer) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          // 头像
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  shape: BoxShape.circle,
                  border: streamer['isLive']
                      ? Border.all(color: const Color(0xFFFF3B30), width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    streamer['avatar'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              
              if (streamer['isLive'])
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
          
          // 名字
          Text(
            streamer['name'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          
          // 粉丝数
          Text(
            '${streamer['fans']}粉丝',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 区块标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            '查看更多 >',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 直播卡片
  Widget _buildLiveCard(int index) {
    final titles = ['故宫直播', '长城行', '西湖漫步', '成都美食', '西安古城', '杭州夜景'];
    final streamers = ['导游小王', '旅行达人', '江南导游', '美食探店', '历史达人', '夜拍摄影'];
    final viewers = ['12.5k', '8.3k', '5.2k', '3.8k', '2.1k', '1.5k'];
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF6B35).withOpacity(0.6),
                    const Color(0xFF5856D6).withOpacity(0.4),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.videocam,
                      size: 32,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  
                  // 直播标识
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // 观看数
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            viewers[index],
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
          ),
          
          // 信息区
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[index],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    streamers[index],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
