import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/groups/addGroup.dart';
import 'package:it_world/Chat/groups/groupScreen.dart';

class ListGroupe extends StatefulWidget {
  const ListGroupe({Key? key});

  @override
  State<ListGroupe> createState() => _ListGroupeState();
}

class _ListGroupeState extends State<ListGroupe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddGroup()),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs1 = snapshot.data?.docs;
          return ListView.builder(
            itemCount: docs1?.length,
            itemBuilder: (context, index) {
              final groupData = docs1?[index].data();
              final groupId = groupData?['gID'] as String? ?? "";
              final name = groupData?['name'] as String? ?? "";
              final imageUrl = groupData?['imageUrl'] as String?;
              List<String>? members = [];
              (groupData?['members'] as List<dynamic>?)?.forEach((element) {
                members.add(element.toString());
              });
              print(
                  "-======================================================$members");
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupScreen(
                        GroupId: groupId,
                        member: members,
                        name: name,
                        imageUrl: imageUrl ?? "",
                      ),
                    ),
                  );
                },
                title: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: CircleAvatar(
                  maxRadius: 23,
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: imageUrl == null
                      ? const Icon(Icons.groups_2_sharp)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
