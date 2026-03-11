import 'package:flutter/material.dart';

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
  // 用户数据
  String _username = '@tour_guide_li';
  String _bio = '🌍 Traveler · Beijing';
  int _totalLives = 12;
  double _totalEarnings = 456.78;
  int _followers = 1200;
  int _following = 89;
  double _balance = 256.0;

  // 关注列表
  final Set<String> _followedUsers = {};

  // 直播列表（模拟数据）
  final List<LiveStream> _liveStreams = [
    LiveStream(
      id: '1',
      username: '@tour_guide_li',
      location: '北京',
      viewers: '1.2k',
      avatarUrl: '',
      title: 'Walk around Forbidden City',
    ),
    LiveStream(
      id: '2',
      username: '@sichuan_foodie',
      location: '成都',
      viewers: '890',
      avatarUrl: '',
      title: 'Spicy food tour!',
    ),
    LiveStream(
      id: '3',
      username: '@xi_an_walker',
      location: '西安',
      viewers: '567',
      avatarUrl: '',
      title: 'Terracotta Warriors tour',
    ),
    LiveStream(
      id: '4',
      username: '@hangzhou_views',
      location: '杭州',
      viewers: '432',
      avatarUrl: '',
      title: 'West Lake sunset',
    ),
  ];

  // 短视频列表（模拟数据）
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
    VideoPost(
      id: '3',
      title: 'Shanghai night life tour',
      author: '@night_owl',
      likes: '756',
      time: '5h ago',
      thumbnailUrl: '',
    ),
    VideoPost(
      id: '4',
      title: 'Temple visit in Xi\'an',
      author: '@history_buff',
      likes: '643',
      time: '6h ago',
      thumbnailUrl: '',
    ),
  ];

  // 弹幕列表
  final List<Comment> _comments = [
    Comment(username: 'User123', text: 'Amazing!', timestamp: DateTime.now()),
    Comment(username: 'User456', text: 'Where is this?', timestamp: DateTime.now()),
    Comment(username: 'User789', text: 'Sent a ❤️', gift: 'heart', timestamp: DateTime.now()),
    Comment(username: 'Traveler_X', text: 'Beautiful view!', timestamp: DateTime.now()),
    Comment(username: 'Foodie_99', text: '🚀🚀🚀', gift: 'rocket', timestamp: DateTime.now()),
  ];

  // 直播记录
  final List<LiveRecord> _liveRecords = [
    LiveRecord(
      id: '1',
      title: 'Forbidden City Tour',
      location: 'Beijing',
      date: DateTime.now().subtract(const Duration(days: 2)),
      duration: '45:30',
      earnings: '\$45.50',
    ),
    LiveRecord(
      id: '2',
      title: 'Hutong Food Walk',
      location: 'Beijing',
      date: DateTime.now().subtract(const Duration(days: 5)),
      duration: '32:15',
      earnings: '\$32.20',
    ),
    LiveRecord(
      id: '3',
      title: 'Night Market Tour',
      location: 'Shanghai',
      date: DateTime.now().subtract(const Duration(days: 7)),
      duration: '28:45',
      earnings: '\$28.50',
    ),
  ];

  // 收益记录
  final List<Map<String, dynamic>> _earningsHistory = [
    {
      'type': 'gift',
      'from': 'User123',
      'amount': 5.00,
      'time': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'type': 'gift',
      'from': 'User456',
      'amount': 2.50,
      'time': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'type': 'gift',
      'from': 'Traveler_X',
      'amount': 10.00,
      'time': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'type': 'withdrawal',
      'amount': -100.00,
      'time': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  // Getters
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

  // 是否已关注
  bool isFollowing(String userId) {
    return _followedUsers.contains(userId);
  }

  // 关注/取消关注
  void toggleFollow(String userId) {
    if (_followedUsers.contains(userId)) {
      _followedUsers.remove(userId);
      _followers--;
    } else {
      _followedUsers.add(userId);
      _followers++;
    }
    notifyListeners();
  }

  // 添加直播记录
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

  // 发送弹幕
  void addComment(String text, {String? gift}) {
    final newComment = Comment(
      username: 'You',
      text: text,
      gift: gift,
      timestamp: DateTime.now(),
    );
    _comments.add(newComment);
    
    // 如果有礼物，增加收益
    if (gift != null) {
      double amount = 0;
      switch (gift) {
        case 'heart':
          amount = 1.0;
          break;
        case 'flower':
          amount = 5.0;
          break;
        case 'rocket':
          amount = 10.0;
          break;
        case 'diamond':
          amount = 50.0;
          break;
        case 'crown':
          amount = 100.0;
          break;
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

  // 充值
  void recharge(double amount) {
    _balance += amount;
    notifyListeners();
  }

  // 提现
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

  // 购买礼物
  bool buyGift(double cost) {
    if (_balance >= cost) {
      _balance -= cost;
      notifyListeners();
      return true;
    }
    return false;
  }
}