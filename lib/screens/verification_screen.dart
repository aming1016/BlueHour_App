import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isLoading = false;
  bool _isCheckingStatus = true;
  String? _errorMessage;
  Map<String, dynamic>? _verificationStatus;

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _checkVerificationStatus() async {
    final appState = context.read<AppState>();
    if (!appState.isLoggedIn) {
      setState(() {
        _isCheckingStatus = false;
      });
      return;
    }

    final status = await appState.getVerificationStatus();
    if (mounted) {
      setState(() {
        _verificationStatus = status;
        _isCheckingStatus = false;
      });
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final appState = context.read<AppState>();
    final result = await appState.applyVerification({
      'real_name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'location': _cityController.text.trim(),
      'bio': _bioController.text.trim(),
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('申请已提交！'),
            backgroundColor: Colors.green,
          ),
        );
        _checkVerificationStatus();
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('成为主播'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isCheckingStatus
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final status = _verificationStatus?['verification_status'] ?? 'none';
    
    if (status == 'approved' || (_verificationStatus?['is_verified'] ?? false)) {
      return _buildApprovedView();
    }
    
    if (status == 'pending') {
      return _buildPendingView();
    }
    
    return _buildApplicationForm();
  }

  // 已通过
  Widget _buildApprovedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified, size: 80, color: Color(0xFFFF6B35)),
          const SizedBox(height: 16),
          const Text(
            '您已成为主播！',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('现在可以开始直播了'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: 开播
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('开始直播'),
          ),
        ],
      ),
    );
  }

  // 审核中
  Widget _buildPendingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            '审核中',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('请等待审核通过'),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _checkVerificationStatus,
            child: const Text('刷新'),
          ),
        ],
      ),
    );
  }

  // 申请表单（简化版）
  Widget _buildApplicationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '申请成为主播',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '填写简单信息即可申请',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // 姓名
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '姓名 *',
                hintText: '您的姓名或昵称',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入姓名';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 邮箱
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '邮箱 *',
                hintText: '您的联系邮箱',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入邮箱';
                }
                if (!value.contains('@')) {
                  return '邮箱格式不正确';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 城市
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: '所在城市',
                hintText: '您所在的城市（选填）',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // 自我介绍
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '自我介绍',
                hintText: '简单介绍您自己（选填）',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('提交申请', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
