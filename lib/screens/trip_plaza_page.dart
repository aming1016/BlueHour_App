/// 行程广场 - 主页面
/// 展示所有用户的行程计划，支持筛选和搜索

import 'package:flutter/material.dart';
import '../models/trip_plaza_models.dart';
import '../widgets/trip_card_widget.dart';
import 'post_trip_page.dart';

class TripPlazaPage extends StatefulWidget {
  const TripPlazaPage({Key? key}) : super(key: key);

  @override
  State<TripPlazaPage> createState() => _TripPlazaPageState();
}

class _TripPlazaPageState extends State<TripPlazaPage> {
  // 当前选中的筛选类型
  TripType? _selectedType;
  // 搜索关键词
  String _searchQuery = '';
  // 是否正在加载
  bool _isLoading = false;
  // 行程列表
  List<TripCard> _trips = [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  // 加载行程数据
  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    
    // TODO: 替换为真实API调用
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _trips = TripCard.mockData;
      _isLoading = false;
    });
  }

  // 筛选后的行程列表
  List<TripCard> get _filteredTrips {
    return _trips.where((trip) {
      // 类型筛选
      if (_selectedType != null && trip.type != _selectedType) {
        return false;
      }
      // 搜索筛选
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return trip.destination.toLowerCase().contains(query) ||
               trip.description.toLowerCase().contains(query) ||
               trip.tags.any((tag) => tag.toLowerCase().contains(query));
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行程广场'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 跳转到消息中心
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          
          // 类型筛选
          _buildTypeFilter(),
          
          // 行程列表
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTrips,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTrips.isEmpty
                      ? EmptyTripState(onRefresh: _loadTrips)
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: _filteredTrips.length,
                          itemBuilder: (context, index) {
                            final trip = _filteredTrips[index];
                            return TripCardWidget(
                              trip: trip,
                              onTap: () => _onTripTap(trip),
                              onMessageTap: () => _onMessageTap(trip),
                              onJoinTap: () => _onJoinTap(trip),
                              onLikeTap: () => _onLikeTap(trip),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onPostTrip,
        icon: const Icon(Icons.add),
        label: const Text('发布行程'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: '搜索目的地、标签...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip('全部', null),
            const SizedBox(width: 8),
            _buildFilterChip(TripType.findCompanion.label, TripType.findCompanion),
            const SizedBox(width: 8),
            _buildFilterChip(TripType.findLocalGuide.label, TripType.findLocalGuide),
            const SizedBox(width: 8),
            _buildFilterChip(TripType.askForTips.label, TripType.askForTips),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, TripType? type) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedType = selected ? type : null);
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  // 点击行程卡片
  void _onTripTap(TripCard trip) {
    // TODO: 跳转到行程详情页
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('行程详情'),
        content: Text('${trip.userName} 的 ${trip.destination} 行程'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  // 点击私信
  void _onMessageTap(TripCard trip) {
    // TODO: 跳转到聊天页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('给 ${trip.userName} 发送私信')),
    );
  }

  // 点击约同行
  void _onJoinTap(TripCard trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('约 ${trip.userName} 同行'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目的地: ${trip.destination}'),
            Text('时间: ${trip.formattedDate}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: '写下你的约伴留言...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('约伴请求已发送！')),
              );
            },
            child: const Text('发送请求'),
          ),
        ],
      ),
    );
  }

  // 点击点赞
  void _onLikeTap(TripCard trip) {
    // TODO: 调用API点赞
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已点赞 ${trip.userName} 的行程')),
    );
  }

  // 发布行程
  void _onPostTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostTripPage()),
    );
    
    if (result == true) {
      // 发布成功，刷新列表
      _loadTrips();
    }
  }
}
