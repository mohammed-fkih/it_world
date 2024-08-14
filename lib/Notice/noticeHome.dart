import 'package:flutter/material.dart';

class NoticeHome extends StatefulWidget {
  const NoticeHome({super.key});

  @override
  State<NoticeHome> createState() => _NoticeHomeState();
}

class _NoticeHomeState extends State<NoticeHome> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("لايوجد إشعارات"),
    );
  }
}
