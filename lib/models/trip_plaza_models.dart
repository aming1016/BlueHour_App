/// 行程广场 - 数据模型
/// 用于展示用户的行程计划，支持约伴功能

enum TripType {
  findCompanion, // 找同行
  findLocalGuide, // 找伴游
  askForTips, // 求攻略
}

extension TripTypeExtension on TripType {
  String get label {
    switch (this) {
      case TripType.findCompanion:
        return '找同行';
      case TripType.findLocalGuide:
        return '找伴游';
      case TripType.askForTips:
        return '求攻略';
    }
  }

  String get icon {
    switch (this) {
      case TripType.findCompanion:
        return '👥';
      case TripType.findLocalGuide:
        return '🧭';
      case TripType.askForTips:
        return '💡';
    }
  }
}

class TripCard {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userCountry; // 国旗emoji或代码

  final String destination;
  final DateTime startDate;
  final DateTime? endDate;

  final TripType type;
  final String description;
  final List<String> tags;

  final DateTime createdAt;
  final int viewCount;
  final int likeCount;
  final bool isLiked;

  TripCard({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.userCountry,
    required this.destination,
    required this.startDate,
    this.endDate,
    required this.type,
    required this.description,
    required this.tags,
    required this.createdAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
  });

  // Mock数据 - 用于开发测试
  static List<TripCard> get mockData => [
    TripCard(
      id: '1',
      userId: 'user1',
      userName: '马克',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      userCountry: '🇫🇷',
      destination: '北京',
      startDate: DateTime(2026, 12, 15),
      endDate: DateTime(2026, 12, 20),
      type: TripType.findCompanion,
      description: '一个人想去长城和故宫，想找人一起拍照和探索老北京胡同！',
      tags: ['摄影', '历史', '美食'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      viewCount: 128,
      likeCount: 12,
    ),
    TripCard(
      id: '2',
      userId: 'user2',
      userName: '苏菲',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      userCountry: '🇩🇪',
      destination: '上海',
      startDate: DateTime(2026, 12, 20),
      endDate: DateTime(2026, 12, 25),
      type: TripType.findCompanion,
      description: '春节去上海，想找人一起逛迪士尼和外滩夜景！',
      tags: ['迪士尼', '夜景', '购物'],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      viewCount: 256,
      likeCount: 28,
    ),
    TripCard(
      id: '3',
      userId: 'user3',
      userName: 'Tom',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      userCountry: '🇺🇸',
      destination: '成都',
      startDate: DateTime(2026, 12, 10),
      endDate: DateTime(2026, 12, 15),
      type: TripType.askForTips,
      description: '第一次去成都，求推荐必吃的美食和隐藏景点！',
      tags: ['美食', '熊猫', '火锅'],
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      viewCount: 89,
      likeCount: 5,
    ),
    TripCard(
      id: '4',
      userId: 'user4',
      userName: '惠子',
      userAvatar: 'https://i.pravatar.cc/150?img=9',
      userCountry: '🇯🇵',
      destination: '西安',
      startDate: DateTime(2026, 12, 18),
      endDate: DateTime(2026, 12, 22),
      type: TripType.findLocalGuide,
      description: '对兵马俑很感兴趣，想找个懂历史的本地导游！',
      tags: ['历史', '文化', '导游'],
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      viewCount: 45,
      likeCount: 3,
    ),
  ];

  // 格式化日期显示
  String get formattedDate {
    if (endDate != null) {
      return '${_formatDate(startDate)} - ${_formatDate(endDate!)}';
    }
    return _formatDate(startDate);
  }

  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  // 获取相对时间（如：2小时前）
  String get relativeTime {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }
}

/// 发布行程请求模型
class PostTripRequest {
  final String destination;
  final DateTime startDate;
  final DateTime? endDate;
  final TripType type;
  final String description;
  final List<String> tags;

  PostTripRequest({
    required this.destination,
    required this.startDate,
    this.endDate,
    required this.type,
    required this.description,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
    'destination': destination,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'type': type.name,
    'description': description,
    'tags': tags,
  };
}
