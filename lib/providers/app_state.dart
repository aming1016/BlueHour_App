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
  final String thumbnail;

  LiveStream({
    required this.id,
    required this.username,
    required this.location,
    required this.viewers,
    required this.avatarUrl,
    this.isLive = true,
    this.title = '',
    this.thumbnail = '',
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
      thumbnail: data['thumbnail'] ?? '',
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

/// Banner 数据模型
class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String? actionType; // 'web', 'live', 'task'
  final String? actionUrl;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.actionType,
    this.actionUrl,
  });
}

/// 快捷入口数据模型
class QuickEntry {
  final String id;
  final String icon;
  final String label;
  final String? filter;

  QuickEntry({
    required this.id,
    required this.icon,
    required this.label,
    this.filter,
  });
}

/// 混合内容项类型
enum ContentType { live, replay, video }

/// 混合内容流数据模型
class MixedContent {
  final String id;
  final ContentType type;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String? viewers;
  final String? duration;
  final String? likes;
  final bool isLive;
  final String? location;

  MixedContent({
    required this.id,
    required this.type,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.viewers,
    this.duration,
    this.likes,
    this.isLive = false,
    this.location,
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
  
  // ========== 用户认证数据 ==========
  String? _token;
  String? _currentUserId;
  bool _isLoggedIn = false;
  
  // ========== 用户数据 ==========
  String _username = '@tour_guide_li';
  String _bio = '🌍 Traveler · Beijing';
  int _totalLives = 12;
  double _totalEarnings = 456.78;
  int _followers = 1200;
  int _following = 89;
  double _balance = 256.0;

  // ========== API数据 ==========
  List<LiveStream> _liveStreams = [
    // 默认模拟数据，API连接成功后会替换
    LiveStream(
      id: '1',
      title: '🏛️ 故宫深度游',
      username: '@北京导游小李',
      location: '北京 · 故宫',
      viewers: '1.2k',
      avatarUrl: '',
      isLive: true,
    ),
    LiveStream(
      id: '2',
      title: '🐼 熊猫基地实况',
      username: '@成都吃货王',
      location: '成都 · 大熊猫基地',
      viewers: '856',
      avatarUrl: '',
      isLive: true,
    ),
    LiveStream(
      id: '3',
      title: '🌃 外滩夜景',
      username: '@上海夜行者',
      location: '上海 · 外滩',
      viewers: '2.3k',
      avatarUrl: '',
      isLive: true,
    ),
    LiveStream(
      id: '4',
      title: '🍜 西安回民街美食',
      username: '@西安美食家',
      location: '西安 · 回民街',
      viewers: '634',
      avatarUrl: '',
      isLive: true,
    ),
  ];
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

  // ========== P0: 首页新数据（从API获取）==========
  
  /// Banner 轮播数据
  List<BannerItem> _banners = [];

  /// 快捷入口
  List<QuickEntry> _quickEntries = [];

  /// 关注的主播列表
  List<Map<String, dynamic>> _followedStreamers = [];

  /// 混合内容流（直播+回放+视频）
  List<MixedContent> _mixedContent = [];

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
  
  // P0: 首页新数据 getter
  List<BannerItem> get banners => _banners;
  List<QuickEntry> get quickEntries => _quickEntries;
  List<Map<String, dynamic>> get followedStreamers => _followedStreamers;
  List<MixedContent> get mixedContent => _mixedContent;

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
        loadHomepageData(), // 加载首页数据
      ]);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// 加载首页所有数据
  Future<void> loadHomepageData() async {
    await Future.wait([
      loadBanners(),
      loadQuickEntries(),
      loadFollowedStreamers(),
      loadMixedContent(),
    ]);
  }

  /// 加载Banner数据
  Future<void> loadBanners() async {
    final data = await _api.getBanners();
    _banners = data.map((b) => BannerItem(
      id: b['id'] ?? '',
      imageUrl: b['imageUrl'] ?? '',
      title: b['title'] ?? '',
      actionType: b['actionType'],
      actionUrl: b['actionUrl'],
    )).toList();
    notifyListeners();
  }

  /// 加载快捷入口
  Future<void> loadQuickEntries() async {
    final data = await _api.getQuickEntries();
    _quickEntries = data.map((e) => QuickEntry(
      id: e['id'] ?? '',
      icon: e['icon'] ?? '',
      label: e['label'] ?? '',
      filter: e['filter'],
    )).toList();
    notifyListeners();
  }

  /// 加载关注的主播列表
  Future<void> loadFollowedStreamers() async {
    final data = await _api.getFollowedStreamers();
    _followedStreamers = data.map((s) => {
      'id': s['id'] ?? '',
      'username': s['username'] ?? '',
      'avatar': s['avatar'] ?? '',
      'isLive': s['isLive'] ?? false,
      'title': s['title'] ?? '',
      'viewers': s['viewers'] ?? '0',
      'streamId': s['streamId'] ?? '',
    }).toList();
    notifyListeners();
  }

  /// 加载混合内容流
  Future<void> loadMixedContent({String filter = 'recommend'}) async {
    final data = await _api.getMixedContent(filter: filter);
    _mixedContent = data.map((c) {
      ContentType type;
      switch (c['type']) {
        case 'live':
          type = ContentType.live;
          break;
        case 'replay':
          type = ContentType.replay;
          break;
        case 'video':
        default:
          type = ContentType.video;
          break;
      }
      
      return MixedContent(
        id: c['id'] ?? '',
        type: type,
        title: c['title'] ?? '',
        author: c['author'] ?? '',
        thumbnailUrl: c['thumbnailUrl'] ?? '',
        viewers: c['viewers'],
        duration: c['duration'],
        likes: c['likes'],
        isLive: c['isLive'] ?? false,
        location: c['location'],
      );
    }).toList();
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
    if (balance != null && balance > 0) {
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

  // ========== 用户认证方法 ==========

  /// 是否已登录
  bool get isLoggedIn => _isLoggedIn;

  /// 当前用户token
  String? get token => _token;

  /// 当前用户ID
  String? get currentUserId => _currentUserId;

  /// 用户注册
  Future<Map<String, dynamic>> register(String email, String password, String username) async {
    try {
      final response = await _api.register(email, password, username);
      
      if (response != null && response['code'] == 0) {
        final data = response['data'];
        _token = data['token'];
        _currentUserId = data['user']['id'];
        _isLoggedIn = true;
        
        // 更新用户信息
        final user = data['user'];
        _username = user['username'] ?? username;
        
        notifyListeners();
        return {'success': true, 'message': '注册成功'};
      } else {
        return {'success': false, 'message': response?['message'] ?? '注册失败'};
      }
    } catch (e) {
      return {'success': false, 'message': '网络错误：$e'};
    }
  }

  /// 用户登录
  Future<bool> login(String email, String password) async {
    try {
      final response = await _api.login(email, password);
      
      if (response != null && response['code'] == 0) {
        final data = response['data'];
        _token = data['token'];
        _currentUserId = data['user']['id'];
        _isLoggedIn = true;
        
        // 更新用户信息
        final user = data['user'];
        _username = user['username'] ?? '';
        _followers = user['followers_count'] ?? 0;
        _following = user['following_count'] ?? 0;
        _totalLives = user['total_lives'] ?? 0;
        _totalEarnings = user['total_earnings']?.toDouble() ?? 0.0;
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('登录错误: $e');
      return false;
    }
  }

  /// 用户登出
  Future<void> logout() async {
    _token = null;
    _currentUserId = null;
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
  }

  /// 获取当前用户信息
  Future<void> fetchCurrentUser() async {
    if (_token == null) return;
    
    try {
      final response = await _api.getCurrentUser(_token!);
      if (response != null && response['code'] == 0) {
        final user = response['data'];
        _username = user['username'] ?? '';
        _followers = user['followers_count'] ?? 0;
        _following = user['following_count'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      print('获取用户信息失败: $e');
    }
  }

  // ========== 主播认证方法 ==========

  /// 申请主播认证
  Future<Map<String, dynamic>> applyVerification(Map<String, dynamic> data) async {
    if (_token == null) {
      return {'success': false, 'message': '请先登录'};
    }
    
    try {
      final response = await _api.applyVerification(_token!, data);
      
      if (response != null && response['code'] == 0) {
        return {'success': true, 'message': '申请已提交'};
      } else {
        return {'success': false, 'message': response?['message'] ?? '申请失败'};
      }
    } catch (e) {
      return {'success': false, 'message': '网络错误：$e'};
    }
  }

  /// 获取认证状态
  Future<Map<String, dynamic>> getVerificationStatus() async {
    if (_token == null) {
      return {'verification_status': 'none'};
    }

    try {
      final response = await _api.getVerificationStatus(_token!);
      if (response != null && response['code'] == 0) {
        return response['data'] ?? {'verification_status': 'none'};
      }
      return {'verification_status': 'none'};
    } catch (e) {
      print('获取认证状态失败: $e');
      return {'verification_status': 'none'};
    }
  }

  // ========== 直播方法 ==========

  /// 创建直播间
  Future<Map<String, dynamic>> createStream({
    required String title,
    String? location,
    String? category,
  }) async {
    if (_token == null) {
      return {'success': false, 'message': '请先登录'};
    }

    try {
      final response = await _api.createStream(
        _token!,
        title: title,
        location: location,
        category: category,
      );

      if (response != null && response['code'] == 0) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        return {
          'success': false,
          'message': response?['message'] ?? '创建失败',
        };
      }
    } catch (e) {
      return {'success': false, 'message': '网络错误：$e'};
    }
  }

  /// 结束直播
  Future<Map<String, dynamic>> endStream(String streamId) async {
    if (_token == null) {
      return {'success': false, 'message': '请先登录'};
    }

    try {
      final response = await _api.endStream(_token!, streamId);

      if (response != null && response['code'] == 0) {
        return {'success': true, 'data': response['data']};
      } else {
        return {
          'success': false,
          'message': response?['message'] ?? '结束失败',
        };
      }
    } catch (e) {
      return {'success': false, 'message': '网络错误：$e'};
    }
  }
}