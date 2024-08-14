import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/message.dart';
import 'package:it_world/Chat/chat/sendMessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String email;
  final String name;
  final String image;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // ignore: unnecessary_null_comparison
          leading: widget.image == null
              ? Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                )
              : Container(
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(widget.image),
                  ),
                ),
          title: Text(widget.name),
          actions: const [Icon(Icons.more_vert_outlined)],
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
                      if ((docs1![index]['senderEmail'] == user?.email &&
                              docs1[index]['recipientEmail'] == widget.email) ||
                          (docs1[index]['recipientEmail'] == user?.email &&
                              docs1[index]['senderEmail'] == widget.email)) {
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
                  recipientEmail: widget.email,
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
