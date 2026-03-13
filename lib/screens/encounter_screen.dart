import 'package:flutter/material.dart';

/// 邂逅页面 - 随机发言跑马灯
class EncounterScreen extends StatefulWidget {
  const EncounterScreen({super.key});

  @override
  State<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // 模拟邂逅发言数据
  final List<Map<String, dynamic>> messages = [
    {'id': '1', 'username': '旅行达人', 'avatar': '🧗', 'text': '有人一起去西藏吗？', 'time': '2分钟前'},
    {'id': '2', 'username': '美食探索', 'avatar': '👩‍🍳', 'text': '成都火锅求推荐！', 'time': '5分钟前'},
    {'id': '3', 'username': '摄影师小王', 'avatar': '📷', 'text': '故宫拍照最佳机位分享', 'time': '8分钟前'},
    {'id': '4', 'username': '背包客', 'avatar': '🎒', 'text': '求组队去云南', 'time': '12分钟前'},
    {'id': '5', 'username': '吃货一枚', 'avatar': '🍜', 'text': '西安肉夹馍太好吃了', 'time': '15分钟前'},
    {'id': '6', 'username': '风景控', 'avatar': '🌄', 'text': '黄山日出绝美', 'time': '20分钟前'},
    {'id': '7', 'username': '古镇爱好者', 'avatar': '🏮', 'text': '乌镇夜景超赞', 'time': '25分钟前'},
    {'id': '8', 'username': '海岛控', 'avatar': '🏝️', 'text': '三亚求攻略', 'time': '30分钟前'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showUserProfile(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserProfileModal(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 标题
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    '✨ 邂逅',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Color(0xFFFF6B35)),
                        SizedBox(width: 4),
                        Text(
                          '128 人在线',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 跑马灯区域
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // 多列跑马灯
                      ...List.generate(3, (columnIndex) {
                        return Positioned(
                          top: columnIndex * 120.0,
                          left: 0,
                          right: 0,
                          child: _buildMarqueeColumn(columnIndex),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            
            // 底部发邂逅按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showPostDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('发布邂逅'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarqueeColumn(int columnIndex) {
    // 根据列选择不同的消息子集
    final columnMessages = messages.where((m) {
      final index = messages.indexOf(m);
      return index % 3 == columnIndex;
    }).toList();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final offset = (_animationController.value * 100) % 100;
        final direction = columnIndex % 2 == 0 ? 1 : -1;
        
        return Transform.translate(
          offset: Offset(direction * offset, 0),
          child: Row(
            children: [
              ...columnMessages.map((msg) => _buildMessageCard(msg)),
              ...columnMessages.map((msg) => _buildMessageCard(msg)), // 重复一次实现无缝滚动
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> msg) {
    return GestureDetector(
      onTap: () => _showUserProfile(msg),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2C2C2E),
              const Color(0xFF1C1C1E).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      msg['avatar'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['username'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        msg['time'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              msg['text'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showPostDialog() {
    final textController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '发布邂逅',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLength: 50,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '写下你想说的话...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('邂逅发布成功！'),
                          backgroundColor: Color(0xFF34C759),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('发布'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 用户资料半窗
class UserProfileModal extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 拖动条
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 用户信息
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8F6B)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                user['avatar'],
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '@${user['username']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 发言内容
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${user['text']}"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 统计数据
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('获赞', '1.2万'),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStat('关注', '56'),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStat('粉丝', '3.8k'),
            ],
          ),
          
          const Spacer(),
          
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // 关注按钮
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('已关注 ${user['username']}'),
                          backgroundColor: const Color(0xFF34C759),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('关注'),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 私信按钮
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showChatDialog(context);
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('私信'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
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
        const SizedBox(height: 4),
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

  void _showChatDialog(BuildContext context) {
    final textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(
          '给 ${user['username']} 发私信',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '输入消息...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('消息已发送'),
                    backgroundColor: Color(0xFF34C759),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
            ),
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }
}
