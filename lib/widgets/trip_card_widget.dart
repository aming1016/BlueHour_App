/// 行程广场 - 卡片组件
/// 展示单个行程信息的卡片

import 'package:flutter/material.dart';
import '../models/trip_plaza_models.dart';

class TripCardWidget extends StatelessWidget {
  final TripCard trip;
  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onJoinTap;
  final VoidCallback? onLikeTap;

  const TripCardWidget({
    Key? key,
    required this.trip,
    this.onTap,
    this.onMessageTap,
    this.onJoinTap,
    this.onLikeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：用户信息 + 类型标签
              _buildHeader(),
              const SizedBox(height: 12),

              // 目的地和时间
              _buildDestinationInfo(),
              const SizedBox(height: 8),

              // 描述
              Text(
                trip.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // 标签
              _buildTags(),
              const SizedBox(height: 12),

              // 底部：统计 + 操作按钮
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 头像
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(trip.userAvatar),
        ),
        const SizedBox(width: 12),

        // 用户信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    trip.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(trip.userCountry, style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                trip.relativeTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // 类型标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(trip.type.icon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                trip.type.label,
                style: TextStyle(
                  fontSize: 12,
                  color: _getTypeColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationInfo() {
    return Row(
      children: [
        Icon(Icons.location_on, size: 18, color: Colors.red[400]),
        const SizedBox(width: 4),
        Text(
          trip.destination,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          trip.formattedDate,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: trip.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // 浏览数
        Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          '${trip.viewCount}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 16),

        // 点赞
        InkWell(
          onTap: onLikeTap,
          child: Row(
            children: [
              Icon(
                trip.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: trip.isLiked ? Colors.red : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                '${trip.likeCount}',
                style: TextStyle(
                  fontSize: 12,
                  color: trip.isLiked ? Colors.red : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // 操作按钮
        OutlinedButton.icon(
          onPressed: onMessageTap,
          icon: const Icon(Icons.message_outlined, size: 16),
          label: const Text('私信', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[400]!),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onJoinTap,
          icon: const Icon(Icons.person_add_outlined, size: 16),
          label: const Text('约同行', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor() {
    switch (trip.type) {
      case TripType.findCompanion:
        return Colors.blue;
      case TripType.findLocalGuide:
        return Colors.orange;
      case TripType.askForTips:
        return Colors.green;
    }
  }
}

/// 空状态组件
class EmptyTripState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const EmptyTripState({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '暂无行程',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '成为第一个发布行程的人吧！',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          if (onRefresh != null)
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('刷新'),
            ),
        ],
      ),
    );
  }
}
