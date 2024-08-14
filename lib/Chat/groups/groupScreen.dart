import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/message.dart';
import 'package:it_world/Chat/chat/sendMessage.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen(
      {Key? key,
      required this.GroupId,
      required this.name,
      required this.imageUrl,
      required this.member})
      : super(key: key);

  final String GroupId;
  final String name;
  final String imageUrl;
  final List<String> member;

  @override
  State<GroupScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<GroupScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                maxRadius: 23,
                backgroundImage:
                    // ignore: unnecessary_null_comparison
                    widget.imageUrl != ""
                        ? NetworkImage(widget.imageUrl)
                        : null,
                child:
                    // ignore: unnecessary_null_comparison
                    widget.imageUrl == ""
                        ? const Icon(Icons.groups_2_sharp)
                        : null,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          // .orderBy('createdAt', descending: true)

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs1 = snapshot.data?.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: docs1?.length,
                    itemBuilder: (context, index) {
                      final messageData;
                      print("---------------------------${widget.member}");
                      if (widget.member
                              .contains(docs1![index]['senderEmail']) &&
                          docs1[index]['recipientEmail'] == widget.GroupId) {
                        messageData = docs1[index].data();
                      } else {
                        messageData = null;
                      }

                      if (messageData == null) {
                        return const SizedBox();
                      }

                      final senderEmail = messageData['senderEmail'] as String;
                      final message = messageData['message'] as String;
                      final imageURL = messageData['imageURL']?.toString();

                      // Check if the imageURL field exists before accessing it
                      final String? imageUrl =
                          imageURL != null ? imageURL : " ";

                      print(
                          "====================mmmmm================$message");

                      return Message(
                        imageUrl: imageUrl!,
                        userName:
                            user?.email != senderEmail ? widget.name : 'أنت',
                        message: message,
                        isMe: user?.email == senderEmail,
                        key: ValueKey(docs1[index].id),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SendMessage(
                  recipientEmail: widget.GroupId,
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
