import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class ShowProFileData extends StatefulWidget {
  const ShowProFileData({super.key, required this.userId});
  final String userId;
  @override
  State<ShowProFileData> createState() => _ShowProFileDataState();
}

class _ShowProFileDataState extends State<ShowProFileData> {
  Map<String, dynamic> userData = {};
  Future<void> getUserData() async {
    // final user = FirebaseAuth.instance.currentUser;
    userData = (await FireBase()
        .fetchDataFromFirebase_DoucmentID('users', widget.userId))!;
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "معلومات الولادة والمعيشة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['birthCuntry'] != null ||
                userData['birthdDate'] != null ||
                userData['birthCity'] != null ||
                userData['liveCountry'] != null) ...[
              Text(
                  "ولد في ${userData['birthCuntry'] ?? ''} - ${userData['birthCity'] ?? ''}"),
              Text("تاريخ الميلاد ${userData['birthdDate'] ?? ''}"),
              Text(
                  "يعيش حاليا في  ${userData['liveCountry'] ?? ''} - ${userData['liveCity'] ?? ''}"),
            ] else ...[
              const Text('لا يوجد بيانات'),
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              "معلومات  التعليم",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['edution'] != null &&
                userData['edution'].isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userData['edution'].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        ' التخصص : ${userData['edution'][index]['Education Level']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'الجامعة: ${userData['edution'][index]['University']}'),
                        Text(
                            'الدرجة : ${userData['edution'][index]['Degree']}'),
                        Text(
                            ' تاريخ البداية: ${userData['edution'][index]['Start Date']}'),
                        Text(
                            'تاريخ النهاية: ${userData['edution'][index]['End Date']}'),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              const Text('لا يوجد بيانات تعليم')
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              "معلومات  الوظيفة الحالية",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['myJob'] != null && userData['myJob'].isNotEmpty) ...[
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userData['myJob'].length,
                itemBuilder: (context, index) {
                  String? jobTitle = userData['myJob'][index]['myjobname'];
                  String? companyName =
                      userData['myJob'][index]['mycompanyname'];
                  return ListTile(
                    title: Text('المسمى الوظيفي: $jobTitle'),
                    subtitle: Text('اسم الشركة: $companyName'),
                  );
                },
              ),
            ] else ...[
              const Text('لا يوجد بيانات وضيفة')
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              "معلومات الخبرات السابقة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['experiences'] != null &&
                userData['experiences'].isNotEmpty) ...[
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userData['experiences'].length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> experience =
                      userData['experiences'][index];
                  String institution = experience['institution'];
                  int years = experience['years'];
                  String field = experience['field'];
                  String responsibilities = experience['responsibilities'];

                  return ListTile(
                    title: Text('مجال الخبرة: $field'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اسم المؤسسة: $institution'),
                        Text('عدد سنين الخبرة: $years'),
                        Text('العمل المكلف به: $responsibilities'),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              const Text('لا يوجد بيانات لخبرات سابقة')
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              "معلومات المشاريع السابقة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['projects'] != null &&
                userData['projects'].isNotEmpty) ...[
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userData['projects'].length,
                itemBuilder: (context, index) {
                  String name = userData['projects'][index]['projectName'];
                  String description =
                      userData['projects'][index]['description'];
                  String link = userData['projects'][index]['link'] ?? "";

                  return ListTile(
                    title: Text('اسم المشروع: $name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('وصف المشروع: $description'),
                        Text('رابط المشروع: $link'),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              const Text("لا يوجد بيانات لمشاريع سابقة")
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              " المهارات ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['skills'] != null && userData['skills'].isNotEmpty)
              Wrap(
                children: (userData['skills'] as List<dynamic>)
                    .map<Widget>((skill) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: Chip(
                            label: Text(skill),
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " اللغات ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['languages'] != null &&
                userData['languages'].isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userData['languages'].length,
                itemBuilder: (context, index) {
                  String language =
                      userData['languages'][index]['language'] ?? "";
                  int? rating = userData['languages'][index]['rating'];
                  return ListTile(
                    title: Text('اللغة: $language'),
                    subtitle: Text('درجة الاجادة: $rating/5'),
                  );
                },
              ),
            ] else ...[
              const Text('لا يوجد بيانات للغات يتقنها')
            ],
            const SizedBox(
              height: 10,
            ),
            const Text(
              "ملف ال CV",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (userData['cvFile'] != null) ...[
              ListView.builder(
                shrinkWrap: true,
                itemCount: userData['cvFile'].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.download),
                    title: Text(userData['cvFile'][index].path),
                  );
                },
              ),
            ] else ...[
              const Text('لا يوجد ملف cv ')
            ],
          ],
        ),
      ),
    );
  }
}
