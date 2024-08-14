import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Job/addJob.dart';
import 'package:it_world/Job/jobWidght.dart';
import 'package:it_world/Job/myJob.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({
    super.key,
  });

  @override
  State<MyJobs> createState() => _JobsInterfaceState();
}

class _JobsInterfaceState extends State<MyJobs> {
  List<Map<String, dynamic>> myJobs = [];
  @override
  void initState() {
    getMyjobsData();
    super.initState();
  }

  Future<void> getMyjobsData() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
myJobs = (await FirebaseFirestore.instance
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
            MaterialPageRoute(builder: (context) => AddJob()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
        child: myJobs.isEmpty?const Center(child: Text("لم تقم بنشر أي وظيفة من قبل"),)
       : ListView.builder(
          itemCount: myJobs.length,
          itemBuilder: (context, index) {

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyJob(
                            index: index,
                            jobs: myJobs,
                          )),
                );
                setState(() {});
              },
              child: JobElement(
                index: index,
                jobs: myJobs,
              ),
            );
          },
        ),
      ),
    );
  }
}
