/// 行程广场 - API 服务
/// 处理行程相关的网络请求

import '../models/trip_plaza_models.dart';

class TripPlazaService {
  static final TripPlazaService _instance = TripPlazaService._internal();
  factory TripPlazaService() => _instance;
  TripPlazaService._internal();

  // TODO: 替换为真实的API基础URL
  static const String _baseUrl = 'https://api.example.com';

  /// 获取行程列表
  /// 
  /// [type] - 行程类型筛选
  /// [destination] - 目的地筛选
  /// [page] - 页码
  /// [pageSize] - 每页数量
  Future<List<TripCard>> getTrips({
    TripType? type,
    String? destination,
    int page = 1,
    int pageSize = 20,
  }) async {
    // TODO: 实现真实API调用
    // final queryParams = <String, String>{
    //   'page': page.toString(),
    //   'pageSize': pageSize.toString(),
    // };
    // if (type != null) queryParams['type'] = type.name;
    // if (destination != null) queryParams['destination'] = destination;
    // 
    // final response = await http.get(
    //   Uri.parse('$_baseUrl/api/trips').replace(queryParameters: queryParams),
    // );
    // return _parseTrips(response.body);

    // Mock数据
    await Future.delayed(const Duration(milliseconds: 500));
    return TripCard.mockData;
  }

  /// 获取行程详情
  Future<TripCard> getTripDetail(String tripId) async {
    // TODO: 实现真实API调用
    // final response = await http.get(Uri.parse('$_baseUrl/api/trips/$tripId'));
    // return _parseTrip(response.body);

    await Future.delayed(const Duration(milliseconds: 300));
    return TripCard.mockData.firstWhere((t) => t.id == tripId);
  }

  /// 发布行程
  Future<TripCard> postTrip(PostTripRequest request) async {
    // TODO: 实现真实API调用
    // final response = await http.post(
    //   Uri.parse('$_baseUrl/api/trips'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(request.toJson()),
    // );
    // return _parseTrip(response.body);

    await Future.delayed(const Duration(milliseconds: 800));
    return TripCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'currentUser',
      userName: '我',
      userAvatar: 'https://i.pravatar.cc/150?img=12',
      userCountry: '🇨🇳',
      destination: request.destination,
      startDate: request.startDate,
      endDate: request.endDate,
      type: request.type,
      description: request.description,
      tags: request.tags,
      createdAt: DateTime.now(),
    );
  }

  /// 删除行程
  Future<void> deleteTrip(String tripId) async {
    // TODO: 实现真实API调用
    // await http.delete(Uri.parse('$_baseUrl/api/trips/$tripId'));
    
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 点赞行程
  Future<void> likeTrip(String tripId) async {
    // TODO: 实现真实API调用
    // await http.post(Uri.parse('$_baseUrl/api/trips/$tripId/like'));

    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// 取消点赞
  Future<void> unlikeTrip(String tripId) async {
    // TODO: 实现真实API调用
    // await http.delete(Uri.parse('$_baseUrl/api/trips/$tripId/like'));

    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// 获取我的行程列表
  Future<List<TripCard>> getMyTrips() async {
    // TODO: 实现真实API调用
    // final response = await http.get(Uri.parse('$_baseUrl/api/trips/my'));
    // return _parseTrips(response.body);

    await Future.delayed(const Duration(milliseconds: 300));
    return TripCard.mockData.take(2).toList();
  }

  /// 发送约伴请求
  Future<void> sendJoinRequest({
    required String tripId,
    required String message,
  }) async {
    // TODO: 实现真实API调用
    // await http.post(
    //   Uri.parse('$_baseUrl/api/trips/$tripId/request'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'message': message}),
    // );

    await Future.delayed(const Duration(milliseconds: 500));
  }

  // /// 解析行程列表（辅助方法）
  // List<TripCard> _parseTrips(String jsonString) {
  //   final data = jsonDecode(jsonString);
  //   return (data['data'] as List)
  //       .map((item) => TripCard.fromJson(item))
  //       .toList();
  // }
  //
  // /// 解析单个行程（辅助方法）
  // TripCard _parseTrip(String jsonString) {
  //   final data = jsonDecode(jsonString);
  //   return TripCard.fromJson(data['data']);
  // }
}
