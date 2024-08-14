import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
        }
        final docs = snapshot.data?.docs;
        return ListView.builder(
          itemCount: docs?.length ?? 0,
          itemBuilder: (context, index) {
            final docData = docs?[index].data();
            if (docData == null) {
              return Container();
            }
            final email = docData['email'] as String?;
            final name = docData['name'] as String?;
            return Container(
              decoration: BoxDecoration(
                  // color: Colors.blueGrey[200],
                  border: Border.all(color: Colors.black12, width: 0.7),
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          email: email!,
                          name: name!,
                          image: docData['imageUrl'] ?? ''),
                    ),
                  );
                },
                title: Text(name ?? ''),
                subtitle: Text(email ?? ''),
                leading: docData['imageUrl'] == null
                    ? Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(docData['imageUrl']),
                      ),
                trailing: const Column(
                  children: [
                    Text(
                      'أمس',
                      style: TextStyle(color: Colors.blue),
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        '2',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
