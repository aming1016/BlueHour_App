import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 后端服务器地址（虚拟机部署）
  static const String baseUrl = 'http://192.168.124.9:3000';
  
  final http.Client _client = http.Client();
  
  /// 健康检查
  Future<bool> healthCheck() async {
    print('🌐 健康检查: $baseUrl/api/health');
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/health'),
      ).timeout(const Duration(seconds: 5));
      print('📡 健康检查状态: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ 健康检查失败: $e');
      return false;
    }
  }
  
  /// 获取直播列表
  Future<List<Map<String, dynamic>>> getStreams() async {
    print('🌐 请求API: $baseUrl/api/streams');
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/streams'),
      ).timeout(const Duration(seconds: 10));
      
      print('📡 响应状态码: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final streams = List<Map<String, dynamic>>.from(data['data'] ?? []);
        print('✅ 获取到 ${streams.length} 条直播数据');
        return streams;
      }
      print('❌ 响应异常: ${response.body}');
      return [];
    } catch (e) {
      print('❌ 请求失败: $e');
      return [];
    }
  }
  
  /// 获取直播间详情
  Future<Map<String, dynamic>?> getStreamDetail(String streamId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/streams/$streamId'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 获取评论列表
  Future<List<Map<String, dynamic>>> getComments(String streamId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/streams/$streamId/comments'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  /// 发送评论
  Future<Map<String, dynamic>?> sendComment(String streamId, String text) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/streams/$streamId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 获取礼物列表
  Future<List<Map<String, dynamic>>> getGifts() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/gifts/list'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  /// 送礼物
  Future<Map<String, dynamic>?> sendGift(String streamId, String giftId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/gifts/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'streamId': streamId,
          'giftId': giftId,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 关注/取关用户
  Future<bool> followUser(String userId, bool follow) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/follow/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'follow': follow}),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// 获取钱包余额
  Future<double?> getBalance() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/wallet/balance'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']?['balance']?.toDouble();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 切换关注状态
  Future<bool> toggleFollow(String userId, bool follow) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/follow/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'follow': follow}),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// 检查关注状态
  Future<bool> checkFollowStatus(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/follow/$userId/status'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFollowing'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // ==================== 用户认证模块 ====================
  
  /// 用户注册
  Future<Map<String, dynamic>?> register(String email, String password, String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 注册失败: $e');
      return null;
    }
  }
  
  /// 用户登录
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 登录失败: $e');
      return null;
    }
  }
  
  /// 获取当前用户信息
  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 更新用户信息
  Future<Map<String, dynamic>?> updateProfile(String token, Map<String, dynamic> updates) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updates),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // ==================== 主播认证模块 ====================

  /// 申请主播认证
  Future<Map<String, dynamic>?> applyVerification(String token, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/users/verification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 申请认证失败: $e');
      return null;
    }
  }

  /// 获取认证状态
  Future<Map<String, dynamic>?> getVerificationStatus(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/users/verification/status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 获取认证状态失败: $e');
      return null;
    }
  }

  // ==================== 直播模块 ====================

  /// 创建直播间
  Future<Map<String, dynamic>?> createStream(String token, {
    required String title,
    String? location,
    String? category,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/streams/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'category': category,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 创建直播间失败: $e');
      return null;
    }
  }

  /// 结束直播
  Future<Map<String, dynamic>?> endStream(String token, String streamId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/streams/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'stream_id': streamId,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 结束直播失败: $e');
      return null;
    }
  }

  /// 获取直播间信息
  Future<Map<String, dynamic>?> getStreamInfo(String streamId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/streams/$streamId/info'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 获取直播间信息失败: $e');
      return null;
    }
  }
  
  // ==================== 用户认证模块（V1.2新增）====================
  
  /// 用户注册
  Future<Map<String, dynamic>?> register(String email, String password, String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 注册失败: $e');
      return null;
    }
  }
  
  /// 用户登录
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 登录失败: $e');
      return null;
    }
  }
  
  /// 获取当前用户信息
  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// 申请主播认证
  Future<Map<String, dynamic>?> applyVerification(String token, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/users/verification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 申请认证失败: $e');
      return null;
    }
  }
  
  /// 获取认证状态
  Future<Map<String, dynamic>?> getVerificationStatus(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/users/verification/status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 获取认证状态失败: $e');
      return null;
    }
  }
  
  /// 创建直播间
  Future<Map<String, dynamic>?> createStream(String token, {
    required String title,
    String? location,
    String? category,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/streams/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'category': category,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 创建直播间失败: $e');
      return null;
    }
  }
  
  /// 结束直播
  Future<Map<String, dynamic>?> endStream(String token, String streamId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/streams/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'stream_id': streamId,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ 结束直播失败: $e');
      return null;
    }
  }
}
