import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.124.9:3000/api';
  final http.Client _client = http.Client();

  // ========== 健康检查 ==========
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ========== 首页接口 ==========
  Future<List<Map<String, dynamic>>> getBanners() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/banners'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取Banner失败: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getQuickEntries() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/quick-entries'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取快捷入口失败: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getFollowedStreamers() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/followed-streamers'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取关注主播失败: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getMixedContent({String? filter}) async {
    try {
      final uri = Uri.parse('$baseUrl/mixed-content').replace(
        queryParameters: filter != null ? {'filter': filter} : null,
      );
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取混合内容失败: $e');
    }
    return [];
  }

  // ========== 直播接口 ==========
  Future<List<Map<String, dynamic>>> getStreams() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/streams'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取直播列表失败: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getComments(String streamId) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/streams/$streamId/comments'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取评论失败: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> sendComment(String streamId, String text) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/streams/$streamId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('发送评论失败: $e');
    }
    return null;
  }

  // ========== 礼物接口 ==========
  Future<List<Map<String, dynamic>>> getGifts() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/gifts/list'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      print('获取礼物列表失败: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> sendGift(String streamId, String giftId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/gifts/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'streamId': streamId, 'giftId': giftId}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('发送礼物失败: $e');
    }
    return null;
  }

  // ========== 关注接口 ==========
  Future<bool> toggleFollow(String userId, bool isFollowing) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/follow/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': isFollowing ? 'unfollow' : 'follow'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('关注操作失败: $e');
      return false;
    }
  }

  Future<bool> checkFollowStatus(String userId) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/follow/$userId/status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']?['following'] ?? false;
      }
    } catch (e) {
      print('检查关注状态失败: $e');
    }
    return false;
  }

  // ========== 钱包接口 ==========
  Future<double?> getBalance() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/wallet/balance'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data']?['balance'] ?? 0.0).toDouble();
      }
    } catch (e) {
      print('获取余额失败: $e');
    }
    return null;
  }

  // ========== 用户认证接口 ==========
  Future<Map<String, dynamic>?> register(String email, String password, String username) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'username': username}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('注册失败: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('登录失败: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('获取用户信息失败: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> applyVerification(String token, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users/verification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('申请认证失败: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getVerificationStatus(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users/verification/status'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('获取认证状态失败: $e');
    }
    return null;
  }

  // ========== 直播间管理接口 ==========
  // 使用命名参数匹配app_state.dart的调用方式
  Future<Map<String, dynamic>?> createStream(String token, {String? title, String? location, String? category}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/streams/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'category': category,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('创建直播间失败: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> endStream(String token, String streamId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/streams/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'streamId': streamId}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('结束直播失败: $e');
    }
    return null;
  }

  void dispose() {
    _client.close();
  }
}
