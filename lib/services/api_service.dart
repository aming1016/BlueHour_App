import 'dart:convert';
import 'package:http/http.dart' as http;

/// API服务类 - 封装所有后端接口调用
class ApiService {
  // 开发环境基础URL
  static const String baseUrl = 'http://localhost:80';
  
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
}