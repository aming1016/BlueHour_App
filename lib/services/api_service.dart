import 'dart:convert';
import 'package:http/http.dart' as http;

/// API服务类 - 封装所有后端接口调用
class ApiService {
  // 开发环境基础URL（虚拟机）
  static const String baseUrl = 'http://192.168.31.249:3000';

  // 单例模式
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// GET请求封装
  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API GET Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  /// POST请求封装
  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API POST Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  // ==================== 首页模块 ====================

  /// 获取Banner列表
  Future<List<dynamic>> getBanners() async {
    final response = await _get('/api/banners');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 获取关注的主播列表
  Future<List<dynamic>> getFollowedStreamers() async {
    final response = await _get('/api/followed-streamers');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 获取混合内容流
  Future<List<dynamic>> getMixedContent({String filter = 'recommend', int limit = 20}) async {
    final response = await _get('/api/mixed-content?filter=$filter&limit=$limit');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 获取快捷入口配置
  Future<List<dynamic>> getQuickEntries() async {
    final response = await _get('/api/quick-entries');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  // ==================== 直播模块 ====================

  /// 获取直播列表
  Future<List<dynamic>> getStreams() async {
    final response = await _get('/api/streams');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 获取直播间详情
  Future<Map<String, dynamic>?> getStreamDetail(String streamId) async {
    final response = await _get('/api/streams/$streamId');
    if (response['code'] == 0) {
      return response['data'];
    }
    return null;
  }

  // ==================== 评论模块 ====================

  /// 获取评论列表
  Future<List<dynamic>> getComments(String streamId) async {
    final response = await _get('/api/streams/$streamId/comments');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 发送评论
  Future<Map<String, dynamic>?> sendComment(String streamId, String text) async {
    final response = await _post('/api/streams/$streamId/comments', {
      'text': text,
      'userId': 'current_user',
    });
    if (response['code'] == 0) {
      return response['data'];
    }
    return null;
  }

  // ==================== 礼物模块 ====================

  /// 获取礼物列表
  Future<List<dynamic>> getGifts() async {
    final response = await _get('/api/gifts/list');
    if (response['code'] == 0) {
      return response['data'] ?? [];
    }
    return [];
  }

  /// 送礼物
  Future<Map<String, dynamic>?> sendGift(
    String streamId,
    String giftId, {
    int amount = 1,
  }) async {
    final response = await _post('/api/gifts/send', {
      'streamId': streamId,
      'giftId': giftId,
      'amount': amount,
    });
    if (response['code'] == 0) {
      return response['data'];
    }
    return null;
  }

  // ==================== 关注模块 ====================

  /// 关注/取消关注
  Future<bool> toggleFollow(String userId, bool follow) async {
    final response = await _post('/api/follow/$userId', {
      'action': follow ? 'follow' : 'unfollow',
    });
    return response['code'] == 0;
  }

  /// 检查关注状态
  Future<bool> checkFollowStatus(String userId) async {
    final response = await _get('/api/follow/$userId/status');
    if (response['code'] == 0) {
      return response['data']?['following'] ?? false;
    }
    return false;
  }

  // ==================== 钱包模块 ====================

  /// 获取余额
  Future<double> getBalance() async {
    final response = await _get('/api/wallet/balance');
    if (response['code'] == 0) {
      final balance = response['data']?['balance'];
      return balance != null ? balance.toDouble() : 0.0;
    }
    return 0.0;
  }

  /// 健康检查
  Future<bool> healthCheck() async {
    try {
      final response = await _get('/api/health');
      return response['status'] == 'ok';
    } catch (e) {
      return false;
    }
  }

  // ==================== 用户认证模块 ====================

  /// 用户注册
  Future<Map<String, dynamic>> register(String email, String password, String username) async {
    final response = await _post('/api/auth/register', {
      'email': email,
      'password': password,
      'username': username,
    });
    return response;
  }

  /// 用户登录
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    return response;
  }

  /// 获取当前用户信息
  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API GET Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  // ==================== 主播认证模块 ====================

  /// 申请主播认证
  Future<Map<String, dynamic>> applyVerification(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/verification/apply'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API POST Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  /// 获取认证状态
  Future<Map<String, dynamic>> getVerificationStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/verification/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API GET Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  // ==================== 直播管理模块 ====================

  /// 创建直播
  Future<Map<String, dynamic>> createStream({
    required String token,
    required String title,
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/streams'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API POST Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }

  /// 结束直播
  Future<Map<String, dynamic>> endStream({
    required String token,
    required String streamId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/streams/$streamId/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API POST Error: $e');
      return {'code': -1, 'message': e.toString()};
    }
  }
}
