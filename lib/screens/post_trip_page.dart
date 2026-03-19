/// 发布行程 - 页面
/// 用户可以发布自己的行程计划

import 'package:flutter/material.dart';
import '../models/trip_plaza_models.dart';

class PostTripPage extends StatefulWidget {
  const PostTripPage({Key? key}) : super(key: key);

  @override
  State<PostTripPage> createState() => _PostTripPageState();
}

class _PostTripPageState extends State<PostTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  // 表单数据
  String _destination = '';
  DateTime? _startDate;
  DateTime? _endDate;
  TripType _selectedType = TripType.findCompanion;
  final List<String> _selectedTags = [];

  // 可选标签
  final List<String> _availableTags = [
    '摄影', '美食', '历史', '户外', '购物',
    '夜生活', '文化', '亲子', '冒险', '休闲',
    '穷游', '奢华', '独自旅行', '情侣', '朋友',
  ];

  // 热门目的地
  final List<String> _popularDestinations = [
    '北京', '上海', '西安', '成都', '杭州',
    '桂林', '丽江', '三亚', '广州', '深圳',
  ];

  bool get _isValid {
    return _destination.isNotEmpty &&
           _startDate != null &&
           _descriptionController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布行程'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isValid ? _submit : null,
            child: Text(
              '发布',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isValid ? Colors.white : Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 行程类型选择
            _buildSectionTitle('行程类型'),
            _buildTypeSelector(),
            const SizedBox(height: 24),

            // 目的地
            _buildSectionTitle('目的地 *'),
            _buildDestinationInput(),
            const SizedBox(height: 8),
            _buildPopularDestinations(),
            const SizedBox(height: 24),

            // 时间选择
            _buildSectionTitle('出行时间 *'),
            _buildDateSelector(),
            const SizedBox(height: 24),

            // 行程描述
            _buildSectionTitle('行程描述 *'),
            _buildDescriptionInput(),
            const SizedBox(height: 24),

            // 标签选择
            _buildSectionTitle('添加标签'),
            _buildTagSelector(),
            const SizedBox(height: 32),

            // 发布按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '发布行程',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: TripType.values.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => setState(() => _selectedType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                      : Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Text(
                      type.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDestinationInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: '输入目的地，如：北京、上海...',
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      onChanged: (value) => setState(() => _destination = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入目的地';
        }
        return null;
      },
    );
  }

  Widget _buildPopularDestinations() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _popularDestinations.map((city) {
        return ActionChip(
          label: Text(city),
          onPressed: () => setState(() => _destination = city),
          backgroundColor: _destination == city
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          side: _destination == city
              ? BorderSide(color: Theme.of(context).primaryColor)
              : BorderSide.none,
        );
      }).toList(),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        // 开始日期
        Expanded(
          child: InkWell(
            onTap: () => _pickDate(isStart: true),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '开始日期',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _startDate != null
                        ? '${_startDate!.year}/${_startDate!.month}/${_startDate!.day}'
                        : '选择日期',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _startDate != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.arrow_forward, color: Colors.grey),
        ),
        // 结束日期
        Expanded(
          child: InkWell(
            onTap: _startDate != null ? () => _pickDate(isStart: false) : null,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '结束日期（可选）',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _endDate != null
                        ? '${_endDate!.year}/${_endDate!.month}/${_endDate!.day}'
                        : '选择日期',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _endDate != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1))),
      firstDate: isStart ? now : (_startDate ?? now),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // 如果结束日期早于开始日期，清除结束日期
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      maxLength: 500,
      decoration: InputDecoration(
        hintText: '描述你的行程计划、想找什么样的人同行、有什么特别想去的地方...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入行程描述';
        }
        if (value.length < 10) {
          return '描述至少10个字';
        }
        return null;
      },
    );
  }

  Widget _buildTagSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _availableTags.map((tag) {
        final isSelected = _selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTags.add(tag);
              } else {
                _selectedTags.remove(tag);
              }
            });
          },
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 显示加载
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // TODO: 调用API发布行程
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context); // 关闭加载
      Navigator.pop(context, true); // 返回上一页，带成功标记

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('行程发布成功！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
