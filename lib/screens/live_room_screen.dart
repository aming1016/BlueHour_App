import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class LiveRoomScreen extends StatefulWidget {
  final String streamId;

  const LiveRoomScreen({
    super.key,
    required this.streamId,
  });

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _showGiftPanel = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentController.text.isNotEmpty) {
      context.read<AppState>().addComment(_commentController.text);
      _commentController.clear();
      // 滚动到底部
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendGift(String giftType, double cost) {
    if (context.read<AppState>().buyGift(cost)) {
      context.read<AppState>().addComment('Sent a $giftType', gift: giftType);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gift sent! -\$$cost'),
          backgroundColor: const Color(0xFF34C759),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient balance!'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = context.watch<AppState>().liveStreams.firstWhere(
      (s) => s.id == widget.streamId,
      orElse: () => context.watch<AppState>().liveStreams.first,
    );
    final isFollowing = context.watch<AppState>().isFollowing(stream.id);
    final comments = context.watch<AppState>().comments;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Background (placeholder)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: Icon(
                Icons.videocam,
                size: 100,
                color: Colors.white24,
              ),
            ),
          ),

          // Top Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          stream.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.share, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Gradient Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Host Info Card (Left Bottom)
          Positioned(
            left: 16,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stream.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              Text(
                                ' 4.9 (128 reviews)',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${stream.location} · ${stream.title}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: Colors.white70, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${stream.viewers} watching',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppState>().toggleFollow(stream.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing 
                          ? Colors.white.withOpacity(0.3)
                          : const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : '+ Follow',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Comments Section (Right)
          Positioned(
            right: 16,
            bottom: 200,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[comments.length - 1 - index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${comment.username}: ',
                            style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: comment.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Say something...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _sendComment(),
                            ),
                          ),
                          GestureDetector(
                            onTap: _sendComment,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.send, color: Colors.white, size: 20),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showGiftPanel = !_showGiftPanel;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _showGiftPanel 
                            ? const Color(0xFFFF6B35)
                            : Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.card_giftcard, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      context.read<AppState>().addComment('❤️', gift: 'heart');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Gift Panel
          if (_showGiftPanel)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Send Gift',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showGiftPanel = false;
                              });
                            },
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildGiftItem('❤️', '1', Colors.red, 'heart', 1.0),
                          _buildGiftItem('🌹', '5', Colors.pink, 'flower', 5.0),
                          _buildGiftItem('🚀', '10', Colors.orange, 'rocket', 10.0),
                          _buildGiftItem('💎', '50', Colors.blue, 'diamond', 50.0),
                          _buildGiftItem('👑', '100', Colors.amber, 'crown', 100.0),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              return Row(
                                children: [
                                  const Text('Balance: '),
                                  Text(
                                    '${appState.balance.toInt()} 💎',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              // 显示充值对话框
                              _showRechargeDialog();
                            },
                            child: const Text('Recharge'),
                          ),
                        ],
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

  Widget _buildGiftItem(String emoji, String price, Color color, String type, double cost) {
    return GestureDetector(
      onTap: () => _sendGift(type, cost),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(
            '$price coins',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRechargeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recharge'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select amount:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [100, 500, 1000, 5000].map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AppState>().recharge(amount.toDouble());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recharged $amount 💎'),
                        backgroundColor: const Color(0xFF34C759),
                      ),
                    );
                  },
                  child: Text('$amount 💎'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}