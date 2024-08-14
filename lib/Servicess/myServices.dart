import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Servicess/myService.dart';
import 'package:it_world/Servicess/serviceWidght.dart';
import 'package:it_world/Servicess/addService.dart';


class MyServices extends StatefulWidget {
  const MyServices({
    super.key,
  });

  @override
  State<MyServices> createState() => _JobsInterfaceState();
}

class _JobsInterfaceState extends State<MyServices> {
  List<Map<String, dynamic>> services = [];
  @override
  void initState() {
    getServicData();
    super.initState();
  }

  Future<void> getServicData() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
services = (await FirebaseFirestore.instance
      .collection('jobs')
      .where('userId', isEqualTo: userId)
      .get()).docs.map((doc) => doc.data()).toList();
  if (mounted) {
    setState(() {});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddService()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
        child:services.isEmpty?const Center(child: Text("لم تقم بنشر أي وظيفة من قبل"),)
         :ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyService(
                            index: index,
                            service: services,
                          )),
                );
              },
              child: ServiceElement(
                index: index,
                service: services,
              ),
            );
          },
        ),
      ),
    );
  }
}
