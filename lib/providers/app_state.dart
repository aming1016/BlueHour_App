import 'package:flutter/material.dart';
import 'services/api_service.dart';

class LiveStream {
  final String id;
  final String username;
  final String location;
  final String viewers;
  final String avatarUrl;
  final bool isLive;
  final String title;

  LiveStream({
    required this.id,
    required this.username,
    required this.location,
    required this.viewers,
    required this.avatarUrl,
    this.isLive = true,
    this.title = '',
  });

  /// 从API数据创建
  factory LiveStream.fromApi(Map<String, dynamic> data) {
    return LiveStream(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      username: data['streamerName'] ?? '',
      location: data['location'] ?? '',
      viewers: data['viewers']?.toString() ?? '0',
      avatarUrl: data['streamerAvatar'] ?? '',
      isLive: data['isLive'] ?? true,
    );
  }
}

class VideoPost {
  final String id;
  final String title;
  final String author;
  final String likes;
  final String time;
  final String thumbnailUrl;

  VideoPost({
    required this.id,
    required this.title,
    required this.author,
    required this.likes,
    required this.time,
    required this.thumbnailUrl,
  });
}

class Comment {
  final String username;
  final String text;
  final String? gift;
  final DateTime timestamp;

  Comment({
    required this.username,
    required this.text,
    this.gift,
    required this.timestamp,
  });

  /// 从API数据创建
  factory Comment.fromApi(Map<String, dynamic> data) {
    return Comment(
      username: data['userName'] ?? '',
      text: data['text'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['time'] ?? 0),
    );
  }
}

class LiveRecord {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String duration;
  final String earnings;

  LiveRecord({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.duration,
    required this.earnings,
  });
}

class AppState extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  // ========== 用户数据 ==========
  String _username = '@tour_guide_li';
  String _bio = '🌍 Traveler · Beijing';
  int _totalLives = 12;
  double _totalEarnings = 456.78;
  int _followers = 1200;
  int _following = 89;
  double _balance = 256.0;

  // ========== API数据 ==========
  List<LiveStream> _liveStreams = [];
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _apiConnected = false;

  // ========== 本地数据（保持mock） ==========
  final Set<String> _followedUsers = {};
  
  final List<VideoPost> _trendingVideos = [
    VideoPost(
      id: '1',
      title: 'Amazing street food in Chengdu!',
      author: '@foodie_traveler',
      likes: '1.2k',
      time: '2h ago',
      thumbnailUrl: '',
    ),
    VideoPost(
      id: '2',
      title: 'Hidden gems of Beijing hutongs',
      author: '@beijing_walker',
      likes: '890',
      time: '4h ago',
      thumbnailUrl: '',
    ),
  ];

  final List<LiveRecord> _liveRecords = [
    LiveRecord(
      id: '1',
      title: 'Forbidden City Tour',
      location: 'Beijing',
      date: DateTime.now().subtract(const Duration(days: 2)),
      duration: '45:30',
      earnings: '\$45.50',
    ),
  ];

  final List<Map<String, dynamic>> _earningsHistory = [
    {
      'type': 'gift',
      'from': 'User123',
      'amount': 5.00,
      'time': DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  // ========== Getters ==========
  String get username => _username;
  String get bio => _bio;
  int get totalLives => _totalLives;
  double get totalEarnings => _totalEarnings;
  int get followers => _followers;
  int get following => _following;
  double get balance => _balance;
  List<LiveStream> get liveStreams => _liveStreams;
  List<VideoPost> get trendingVideos => _trendingVideos;
  List<Comment> get comments => _comments;
  List<LiveRecord> get liveRecords => _liveRecords;
  List<Map<String, dynamic>> get earningsHistory => _earningsHistory;
  Set<String> get followedUsers => _followedUsers;
  bool get isLoading => _isLoading;
  bool get apiConnected => _apiConnected;

  // ========== API方法 ==========

  /// 初始化并检查API连接
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    _apiConnected = await _api.healthCheck();
    
    if (_apiConnected) {
      await Future.wait([
        loadStreams(),
        loadBalance(),
      ]);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// 加载直播列表（API）
  Future<void> loadStreams() async {
    _isLoading = true;
    notifyListeners();
    
    final streams = await _api.getStreams();
    _liveStreams = streams.map((s) => LiveStream.fromApi(s)).toList();
    
    _isLoading = false;
    notifyListeners();
  }

  /// 加载评论（API）
  Future<void> loadComments(String streamId) async {
    _isLoading = true;
    notifyListeners();
    
    final comments = await _api.getComments(streamId);
    _comments = comments.map((c) => Comment.fromApi(c)).toList();
    
    _isLoading = false;
    notifyListeners();
  }

  /// 发送评论（API）
  Future<void> sendComment(String streamId, String text) async {
    final result = await _api.sendComment(streamId, text);
    if (result != null) {
      // 发送成功后刷新评论列表
      await loadComments(streamId);
    }
  }

  /// 送礼物（API）
  Future<bool> sendGift(String streamId, String giftId, double cost) async {
    if (_balance < cost) return false;
    
    final result = await _api.sendGift(streamId, giftId);
    if (result != null) {
      // 更新本地余额
      _balance = result['remainingBalance']?.toDouble() ?? _balance - cost;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 加载余额（API）
  Future<void> loadBalance() async {
    final balance = await _api.getBalance();
    if (balance > 0) {
      _balance = balance;
      notifyListeners();
    }
  }

  /// 关注/取消关注（API）
  Future<void> toggleFollow(String userId) async {
    final isCurrentlyFollowing = _followedUsers.contains(userId);
    final success = await _api.toggleFollow(userId, !isCurrentlyFollowing);
    
    if (success) {
      if (isCurrentlyFollowing) {
        _followedUsers.remove(userId);
        _followers--;
      } else {
        _followedUsers.add(userId);
        _followers++;
      }
      notifyListeners();
    }
  }

  /// 检查关注状态（API）
  Future<bool> checkFollowStatus(String userId) async {
    return await _api.checkFollowStatus(userId);
  }

  // ========== 本地方法 ==========

  /// 是否已关注
  bool isFollowing(String userId) {
    return _followedUsers.contains(userId);
  }

  /// 添加直播记录
  void addLiveRecord({required String title, required String location}) {
    final newRecord = LiveRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      location: location,
      date: DateTime.now(),
      duration: '00:00',
      earnings: '\$0.00',
    );
    _liveRecords.insert(0, newRecord);
    _totalLives++;
    notifyListeners();
  }

  /// 添加本地弹幕（不参与API）
  void addComment(String text, {String? gift}) {
    final newComment = Comment(
      username: 'You',
      text: text,
      gift: gift,
      timestamp: DateTime.now(),
    );
    _comments.add(newComment);
    
    if (gift != null) {
      double amount = 0;
      switch (gift) {
        case 'heart': amount = 1.0; break;
        case 'flower': amount = 5.0; break;
        case 'rocket': amount = 10.0; break;
        case 'diamond': amount = 50.0; break;
        case 'crown': amount = 100.0; break;
      }
      _totalEarnings += amount;
      _earningsHistory.insert(0, {
        'type': 'gift',
        'from': 'You',
        'amount': amount,
        'time': DateTime.now(),
      });
    }
    
    notifyListeners();
  }

  /// 充值
  void recharge(double amount) {
    _balance += amount;
    notifyListeners();
  }

  /// 提现
  bool withdraw(double amount) {
    if (_totalEarnings >= amount) {
      _totalEarnings -= amount;
      _earningsHistory.insert(0, {
        'type': 'withdrawal',
        'amount': -amount,
        'time': DateTime.now(),
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 购买礼物（本地扣款）
  bool buyGift(double cost) {
    if (_balance >= cost) {
      _balance -= cost;
      notifyListeners();
      return true;
    }
    return false;
  }
}