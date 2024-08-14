import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/profile/showProfile.dart';

class JobElement extends StatefulWidget {
  const JobElement({super.key, required this.jobs, required this.index});
  final List<Map<String, dynamic>> jobs;
  final int index;

  @override
  State<JobElement> createState() => _JobElementState();
}

class _JobElementState extends State<JobElement> {
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

  List<Map<String, dynamic>> users = [];

  Map<String, dynamic> userpup = {};

  Future<void> getUersData() async {
    users = await FireBase().fetchAllDataFromFirebase('users');
    if (mounted) {
      setState(() {
        userpup = users.firstWhere(
            (element) => element['id'] == widget.jobs[widget.index]['userId'],
            orElse: () => {});
      });
    }
  }

  @override
  void initState() {
    getUersData();
    super.initState();
  }

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
              widget.jobs[widget.index]['jobTitle'] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              title: Text(userpup['name'] ?? " "),
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
              Text(
                "  الشركة/المؤسسة : ${widget.jobs[widget.index]['companyName']} ",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                'الموقع: ${widget.jobs[widget.index]['workLocation']}, ',
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "عدد ساعات العمل :  ${widget.jobs[widget.index]['workSchedule']}",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                " الراتب  :  ${widget.jobs[widget.index]['salary']}",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                widget.jobs[widget.index]['FromWhare'] == 'من المنزل'
                    ? 'الدوام عن بعد بُعد'
                    : 'الدوام من مقر الشركة',
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.jobs[widget.index]['states'] == true) ...[
                    const Text("التقديم متاح")
                  ] else ...[
                    const Text("التقديم غير متاح")
                  ],
                  Text(' ${widget.jobs[widget.index]['asleep']} مقدم'),
                  Text(formatPostDate(widget.jobs[widget.index]['createdAt'])),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class JobShow extends StatefulWidget {
  const JobShow({super.key, required this.jobs, required this.index});
  final List<Map<String, dynamic>> jobs;
  final int index;

  @override
  State<JobShow> createState() => _JobShowState();
}

class _JobShowState extends State<JobShow> {
  int aplicationcount = 0;
  List<dynamic> asleeps = [];
  @override
  void initState() {
    super.initState();
    aplicationcount = widget.jobs[widget.index]['asleep'];
    asleeps = widget.jobs[widget.index]['asleeps'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.jobs[widget.index]['jobTitle'])),
        body: SingleChildScrollView(
          child: Container(
            //padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              JobElement(index: widget.index, jobs: widget.jobs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('      تقديم       '),
                    onPressed: () async {
                      aplicationcount++;
                      final user = FirebaseAuth.instance.currentUser;
                      asleeps.add(user!.uid);

                      await FireBase().updateDataInFirebase(
                          'jobs',
                          widget.jobs[widget.index]['gID'],
                          {'asleep': aplicationcount, 'asleeps': asleeps});

                      setState(() {});
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم التقديم بنجاح'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('     حفظ       '),
                    onPressed: () {
                      // إضافة الإجراء الذي يتم تنفيذه عند الضغط على زر التقديم
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12, width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      " وصف الوظيفة",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(' ${widget.jobs[widget.index]['jobDescription']}',
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      " معايير التوضيف",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' ${widget.jobs[widget.index]['employmentStandards']}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "عن الشركة أو صاحيب العمل",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(' ${widget.jobs[widget.index]['aboutCanpany']}',
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                        widget.jobs[widget.index]['notes'] != null
                            ? ' ${widget.jobs[widget.index]['notes']}'
                            : ' ',
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
