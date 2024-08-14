import 'package:flutter/material.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Servicess/serviceWidght.dart';
import 'package:it_world/profile/showProfile.dart';

class MyService extends StatefulWidget {
  const MyService({super.key, required this.index, required this.service});
  final List<Map<String, dynamic>> service;
  final int index;

  @override
  State<MyService> createState() => _MyJobState();
}

class _MyJobState extends State<MyService> {
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
    status = widget.service[widget.index]['state']??false;
    super.initState();
  }
     // ignore: non_constant_identifier_names
 List<Map<String,dynamic>>RseivePeople=[];
Future<void> getUserData() async {
  if(widget.service[widget.index]['asleeps']!=null){
    for (var element in widget.service[widget.index]['asleeps']) {
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
        appBar: AppBar(
            title: Text(widget.service[widget.index]['ServiceName'] ?? "")),
        body: SingleChildScrollView(
          child: Container(
            //padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ServiceElement(service: widget.service, index: widget.index),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: status
                        ? const Text('      إنهاء إستقبال الطالبات       ')
                        : const Text('      إعادة إستقبال الطالبات       '),
                    onPressed: () async {
                      status = !widget.service[widget.index]['state'];
                      await FireBase().updateDataInFirebase(
                          'services', widget.service[widget.index]['gID'], {
                        'state': status,
                      });
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: const Text('     حذف       '),
                    onPressed: () {
                      FireBase().deleteDataFromFirebase(
                          'services', widget.service[widget.index]['gID']);
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
                  child: RseivePeople.isEmpty?const Center(child: Text("لا يوجد متقدمين"),):
                  ListView.builder(
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
