import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 后端服务器地址（虚拟机部署）
  static const String baseUrl = 'http://192.168.124.9:3000';
  
  final http.Client _client = http.Client();
  
  /// 健康检查
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/health'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
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
}
