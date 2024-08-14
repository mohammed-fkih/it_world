import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class MyPolls extends StatefulWidget {
  const MyPolls({Key? key}) : super(key: key);

  @override
  State<MyPolls> createState() => _PollsState();
}

class _PollsState extends State<MyPolls> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  List<String> answers = [];
  Map<String, dynamic> polls = {};
  String dropdownValue = 'الكل';

  bool validateFields() {
    if (questionController.text.isEmpty || answers.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('تنبيه'),
            content: const Text('يرجى تعبئة الحقول المطلوبة'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('موافق'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("إستفتاء"),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: "السؤال"),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    for (int i = 0; i < answers.length; i++)
                      TextFormField(
                        initialValue: answers[i],
                        decoration: InputDecoration(
                          labelText: "الإجابة $i",
                        ),
                        onChanged: (value) {
                          setState(() {
                            answers[i] = value;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: answerController,
                        decoration:
                            const InputDecoration(labelText: "إضافة إجابة"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            answers.add(answerController.text);
                            answerController.clear();
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text("لمن يظهر :"),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['الكل', 'المتابعين', 'مخصص']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (validateFields()) {
                          await FireBase().addDataToFirebase_Id('posts', {
                            "question": questionController.text,
                            "answers": answers,
                            "userId": user?.uid,
                            "timeStamp": DateTime.now(),
                            'like': 0,
                            'command': 0,
                            "type": 'polls'
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم النشر بنجاح'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("نشر"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("إلغاء"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
