import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Job/jobWidght.dart';
import 'package:it_world/profile/showProfile.dart';

class MyJob extends StatefulWidget {
  const MyJob({super.key, required this.jobs, required this.index});
  final List<Map<String, dynamic>> jobs;
  final int index;

  @override
  State<MyJob> createState() => _MyJobState();
}

class _MyJobState extends State<MyJob> {
  // ignore: non_constant_identifier_names
  // final List<Map<String, dynamic>> RseivePeople = [
  //   {'name': "moammed al Fakeeh"},
  //   {'name': "علي عبدالله"},
  //   {'name': "سلام جمال الحربي"},
  //   {'name': "قاسم عبده سعيد"},
  //   {'name': "علي عبدالله"},
  //   {'name': "سلام جمال الحربي"},
  //   {'name': "قاسم عبده سعيد"},
  //   {'name': "علي عبدالله"},
  //   {'name': "سلام جمال الحربي"},
  //   {'name': "قاسم عبده سعيد"},
  // ];
  bool status = true;
  @override
  void initState() {
    status = widget.jobs[widget.index]['states'];
    getUserData();
    super.initState();
  }
   List<Map<String,dynamic>>RseivePeople=[];
Future<void> getUserData() async {
  if(widget.jobs[widget.index]['asleeps']!=null){
    for (var element in widget.jobs[widget.index]['asleeps']) {
    final user = await FireBase().fetchDataFromFirebase_DoucmentID('users', element);
    if (user is Map<String, dynamic>) {
      RseivePeople.add(user);
    } else {
      
    }
  }
  }
 setState(() {
   
 });
 
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
                    child: status
                        ? const Text('      إنهاء إستقبال الطالبات       ')
                        : const Text('      إعادة إستقبال الطالبات       '),
                    onPressed: () async {
                      status = !widget.jobs[widget.index]['states'];
                      await FireBase().updateDataInFirebase(
                          'jobs', widget.jobs[widget.index]['gID'], {
                        'states': status,
                      });
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: const Text('     حذف       '),
                    onPressed: () {
                      FireBase().deleteDataFromFirebase(
                          'jobs', widget.jobs[widget.index]['gID']);
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "المقدمين على الوظيفة :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  // height: 700,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child:RseivePeople.isEmpty?const Center(child: Text("لا يوجد متقدمين"),)
                   :ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: RseivePeople.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                        context,
                        DialogRoute(
                            context: context,
                            builder: (context) => ShowProfile(
                                  userId: RseivePeople[index]['id'],
                                )));
                          },
                          tileColor: Colors.black12,
                          title: Text(RseivePeople[index]['name']),
                          leading: const Icon(
                            Icons.person,
                            color: Colors.blueGrey,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          email: RseivePeople[index]['email']??'',
                          name: RseivePeople[index]['name']??"",
                          image: RseivePeople[index]['imageUrl'] ?? ''),
                    ),
                  );
                            },
                            icon: const Icon(
                              Icons.message,
                              color: Colors.blueGrey,
                            ),
                          ),
                        );
                      })),
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
