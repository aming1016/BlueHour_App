import 'package:flutter/material.dart';

class LiveCard extends StatelessWidget {
  final String username;
  final String location;
  final String viewers;

  const LiveCard({
    super.key,
    required this.username,
    required this.location,
    required this.viewers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 36, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            username,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 10, color: Color(0xFF6B7280)),
              const SizedBox(width: 2),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.visibility, size: 10, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 2),
              Text(
                viewers,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}