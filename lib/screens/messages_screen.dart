import 'package:flutter/material.dart';

/// 消息记录页面 - 消息列表 + Run Into
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 模拟消息列表数据
  final List<Map<String, dynamic>> messageList = [
    {
      'id': '1',
      'name': '导游小王',
      'avatar': '👨‍💼',
      'lastMessage': '明天故宫见！',
      'time': '14:30',
      'unread': 2,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': '旅行达人',
      'avatar': '🧗',
      'lastMessage': '西安攻略发你了',
      'time': '12:15',
      'unread': 0,
      'isOnline': false,
    },
    {
      'id': '3',
      'name': '美食探索',
      'avatar': '👩‍🍳',
      'lastMessage': '成都火锅推荐！',
      'time': '昨天',
      'unread': 1,
      'isOnline': true,
    },
    {
      'id': '4',
      'name': '摄影师小李',
      'avatar': '📷',
      'lastMessage': '照片修好了',
      'time': '昨天',
      'unread': 0,
      'isOnline': false,
    },
    {
      'id': '5',
      'name': '背包客阿明',
      'avatar': '🎒',
      'lastMessage': '组队去云南吗？',
      'time': '周一',
      'unread': 0,
      'isOnline': true,
    },
  ];

  // Run Into 留言数据
  final List<Map<String, dynamic>> runIntoMessages = [
    {'id': '1', 'name': '小明', 'avatar': '👦', 'text': '有人一起去北京吗？', 'time': '2分钟前'},
    {'id': '2', 'name': '小红', 'avatar': '👧', 'text': '成都火锅求推荐！', 'time': '5分钟前'},
    {'id': '3', 'name': '旅行者', 'avatar': '🧳', 'text': '求西安攻略', 'time': '8分钟前'},
    {'id': '4', 'name': '摄影师', 'avatar': '📷', 'text': '分享西湖美景', 'time': '12分钟前'},
    {'id': '5', 'name': '吃货', 'avatar': '🍜', 'text': '西安肉夹馍太好吃了', 'time': '15分钟前'},
    {'id': '6', 'name': '风景控', 'avatar': '🌄', 'text': '黄山日出绝美', 'time': '20分钟前'},
    {'id': '7', 'name': '古镇爱好者', 'avatar': '🏮', 'text': '乌镇夜景超赞', 'time': '25分钟前'},
    {'id': '8', 'name': '海岛控', 'avatar': '🏝️', 'text': '三亚求攻略', 'time': '30分钟前'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        child: Column(
          children: [
            // 顶部标题栏
            _buildHeader(),
            
            // Tab 栏
            _buildTabBar(),
            
            // Tab 内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMessageList(),
                  _buildRunIntoTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部标题栏
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '消息',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 栏
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFFF6B35),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message, size: 18),
                const SizedBox(width: 6),
                const Text('消息'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_run, size: 18),
                SizedBox(width: 6),
                Text('Run Into'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 消息列表
  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        final msg = messageList[index];
        return _buildMessageItem(msg);
      },
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(user: msg),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 头像
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      msg['avatar'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                if (msg['isOnline'])
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        msg['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        msg['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          msg['lastMessage'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (msg['unread'] > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${msg['unread']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Run Into 标签页
  Widget _buildRunIntoTab() {
    return Column(
      children: [
        // 说明文字
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '💫 在这里邂逅志同道合的旅行者\n点击留言查看对方资料并开始聊天',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        
        // 跑马灯区域
        Expanded(
          child: _buildMarqueeArea(),
        ),
        
        // 底部发留言按钮
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                _showPostDialog();
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('留下你的足迹'),
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
    );
  }

  /// 跑马灯区域
  Widget _buildMarqueeArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // 多行跑马灯
          ...List.generate(4, (index) {
            return Positioned(
              top: index * 90.0,
              left: 0,
              right: 0,
              child: _buildMarqueeRow(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMarqueeRow(int rowIndex) {
    // 为每行分配不同的消息
    final rowMessages = runIntoMessages
        .where((m) => runIntoMessages.indexOf(m) % 4 == rowIndex)
        .toList();

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: -200),
      duration: Duration(seconds: 15 + rowIndex * 3),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: Row(
            children: [
              ...rowMessages.map((msg) => _buildRunIntoCard(msg)),
              ...rowMessages.map((msg) => _buildRunIntoCard(msg)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRunIntoCard(Map<String, dynamic> msg) {
    return GestureDetector(
      onTap: () {
        _showUserProfile(msg);
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2C2C2E),
              const Color(0xFF1C1C1E),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      msg['avatar'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    msg['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              msg['text'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              msg['time'],
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserProfile(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserProfileSheet(user: user),
    );
  }

  void _showPostDialog() {
    final textController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.35,
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
                '留下你的足迹',
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
                  hintText: '写下你想说的话，让有缘人看到...',
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
                          content: Text('留言发布成功！'),
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
class UserProfileSheet extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
          
          // 头像
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
            '@${user['name']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 留言内容
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
                          content: Text('已关注 ${user['name']}'),
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
                
                // 聊天按钮
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(user: user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('去聊天'),
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
}

/// 聊天页面
class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // 添加欢迎消息
    _messages.add({
      'isMe': false,
      'text': '你好，我是${widget.user['name']}，很高兴认识你！',
      'time': '刚刚',
    });
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'isMe': true,
          'text': _textController.text,
          'time': '刚刚',
        });
      });
      _textController.clear();
      
      // 模拟对方回复
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'isMe': false,
              'text': '收到！我们一起聊聊旅行计划吧 😊',
              'time': '刚刚',
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.user['avatar'],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '在线',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF34C759),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          
          // 输入框
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '输入消息...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFF6B35)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isMe = msg['isMe'];
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF6B35) : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          msg['text'],
          style: TextStyle(
            color: isMe ? Colors.white : Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
