import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatList.dart';
import 'package:it_world/Chat/groups/ListGroups.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<ChatHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الدردشات'),
            Tab(text: 'المجموعات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChatsList(),
          ListGroupe(),
        ],
      ),
    );
  }
}
