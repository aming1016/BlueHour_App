import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_screen.dart';
import 'verification_screen.dart';
import 'go_live_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Me',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.settings_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // 头像
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: appState.isLoggedIn 
                                ? const Color(0xFFFF6B35) 
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person, 
                            size: 48, 
                            color: appState.isLoggedIn ? Colors.white : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 用户名
                        Text(
                          appState.isLoggedIn 
                              ? '@${appState.username}' 
                              : '未登录',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.isLoggedIn 
                              ? '🌍 Traveler · Beijing' 
                              : '登录后查看更多功能',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                        
                        // 登录/登出按钮
                        const SizedBox(height: 16),
                        if (!appState.isLoggedIn)
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                '登录 / 注册',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () async {
                              await appState.logout();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已登出')),
                                );
                              }
                            },
                            child: const Text(
                              '退出登录',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard(
                              appState.isLoggedIn ? appState.totalLives.toString() : '-', 
                              'Lives'
                            ),
                            _buildStatCard(
                              appState.isLoggedIn ? '\$${appState.totalEarnings.toStringAsFixed(0)}' : '-', 
                              'Earned'
                            ),
                            _buildStatCard(
                              appState.isLoggedIn ? '${(appState.followers / 1000).toStringAsFixed(1)}k' : '-', 
                              'Followers'
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildMenuItem(Icons.live_tv, 'My Lives', ''),
                        const Divider(height: 1),
                        _buildMenuItem(Icons.account_balance_wallet, 'Wallet', 
                          appState.isLoggedIn ? '\$${appState.balance.toStringAsFixed(0)}' : ''
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(Icons.favorite_outline, 'Liked Videos', ''),
                        const Divider(height: 1),
                        _buildMenuItem(Icons.people_outline, 'Following', 
                          appState.isLoggedIn ? appState.following.toString() : ''
                        ),
                        const Divider(height: 1),
                        // 主播认证/开播入口
                        if (!appState.isLoggedIn)
                          _buildMenuItem(
                            Icons.verified_user_outlined, 
                            '主播认证', 
                            '未登录',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          )
                        else
                          _buildMenuItem(
                            Icons.live_tv, 
                            '开始直播', 
                            '',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const GoLiveSettingsScreen(),
                                ),
                              );
                            },
                          ),
                        const Divider(height: 1),
                        _buildMenuItem(Icons.settings_outlined, 'Settings', ''),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 109,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A1A2E)),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
        ],
      ),
      onTap: onTap,
    );
  }
}
