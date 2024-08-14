import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/profile/showProfile.dart';

class ServiceElement extends StatefulWidget {
  const ServiceElement({super.key, required this.service, required this.index});
  final List<Map<String, dynamic>> service;
  final int index;
  @override
  State<ServiceElement> createState() => _ServiceElementState();
}

String formatPostDate(Timestamp dateTime) {
    DateTime dateTimeObject = dateTime.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTimeObject);
    if (difference.inSeconds < 60) {
      return "الآن";
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعة';
    } else {
      final formattedDate =
          '${dateTimeObject.day}-${dateTimeObject.month}-${dateTimeObject.year}';
      return formattedDate;
    }
  }

class _ServiceElementState extends State<ServiceElement> {
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic> userpup = {};
  var timestamp;
  Future<void> getUersData() async {
    users = await FireBase().fetchAllDataFromFirebase('users');
    if (mounted) {
      setState(() {
        userpup = users.firstWhere(
            (element) =>
                element['id'] == widget.service[widget.index]['userId'],
            orElse: () => {});
      });
    }
  }

  @override
  void initState() {
    getUersData();
    super.initState();
  }

  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ListTile(
            title: Text(
              widget.service[widget.index]['ServiceName'] ?? "",
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: ListTile(
              onTap: (){
                Navigator.push(
                        context,
                        DialogRoute(
                            context: context,
                            builder: (context) => ShowProfile(
                                  userId: userpup['id'],
                                )));
              },
              title: Text(' ${userpup['name'] ?? " "}'),
              leading: userpup['imageUrl'] != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(userpup['imageUrl'] ?? ""))
                  : CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.blueGrey[600],
                      ),
                    ),
              trailing: IconButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          email: userpup['email']??'',
                          name: userpup['name']??"",
                          image: userpup['imageUrl'] ?? ''),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.message,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      maxLines: isExpanded ? 2 : 50,
                      ' ${widget.service[widget.index]['serviceDesc']}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'عرض المزيد' : 'عرض أقل',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                ' الشركة/المؤسسة الطالبة الخدمة : ${widget.service[widget.index]['companyName']??''}',
                style: const TextStyle(fontSize: 16),
              ),
              // Text(
              //   'موعد التسليم  : ${formatPostDate(widget.service[widget.index]['dateOfGet'])}',
              //   style: const TextStyle(fontSize: 16),
              // ),
              Text(
                ' قيمة الخدمة : ${widget.service[widget.index]['praice']??''}',
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.service[widget.index]['state'] == true) ...[
                    const Text('التقديم متاح'),
                  ] else ...[
                    const Text('التقديم غير متاح'),
                  ],
                  Text(
                      ' ${widget.service[widget.index]['aplicationcont']??0} مقدم'),
                  Text(widget.service[widget.index]['dateSaved']!=null? formatPostDate(
                      widget.service[widget.index]['dateSaved']):""),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
