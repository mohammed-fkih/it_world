import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/profile/profile_widgets.dart';

class AddDevlopProFile extends StatefulWidget {
  const AddDevlopProFile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddDevlopProFileState createState() => _AddDevlopProFileState();
}

class _AddDevlopProFileState extends State<AddDevlopProFile> {
  TextEditingController birthCuntry = TextEditingController();
  TextEditingController liveCuntry = TextEditingController();
  TextEditingController birthcity = TextEditingController();
  TextEditingController livecity = TextEditingController();
  String birthdDate = '';

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();

    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تطوير الملف الشخصي"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(137, 238, 236, 236),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "قم بتعبئة البيانات التالية والتي ستظهر لجميع المشتركين."
                  " احرص على كتابة البيانات بدقة",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "معلومات البلد والميلاد",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 3,
                              child: TextFormField(
                                style: const TextStyle(height: 0.4),
                                decoration: InputDecoration(
                                  labelText: " بلد الولادة",
                                  hintText: "اليمن",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 3,
                              child: TextFormField(
                                style: const TextStyle(height: 0.4),
                                decoration: InputDecoration(
                                  labelText: "المدينة التي ولدت فيها",
                                  hintText: "صنعاء",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 3,
                              child: TextFormField(
                                style: const TextStyle(height: 0.4),
                                decoration: InputDecoration(
                                  labelText: "البلد التي تعيش فيها حاليا",
                                  hintText: "السعودية",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 3,
                              child: TextFormField(
                                style: const TextStyle(height: 0.4),
                                decoration: InputDecoration(
                                  labelText: "المدينة التي تعيش فيها حاليا",
                                  hintText: "الرياض",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text("تاريخ الميلاد"),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectDate(context);
                                  // ignore: unnecessary_null_comparison
                                  if (selectedDate != null) {
                                    birthdDate = formatDate(selectedDate!);
                                  }
                                });
                              },
                              // ignore: unnecessary_null_comparison
                              child: selectedDate == null
                                  ? const Text('اختر تاريخ الميلاد')
                                  : Text(birthdDate),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (birthCuntry.text.isNotEmpty &&
                                  birthcity.text.isNotEmpty &&
                                  liveCuntry.text.isNotEmpty &&
                                  livecity.text.isNotEmpty &&
                                  birthdDate == "") {
                                await FireBase()
                                    .updateDataInFirebase('users', user!.uid, {
                                  "birthCuntry": birthCuntry,
                                  "birthCity": birthcity,
                                  "liveCountry": liveCuntry,
                                  "liveCity": livecity,
                                  "birthdDate": birthdDate
                                });
                              }
                            },
                            child: const Text("حفظ بيانات الميلاد والمعيشة"))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Text(
                //   "معلومات التواصل",
                //   style: TextStyle(fontSize: 17),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // const PhoneCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "معلومات الشهادات ",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                EducationCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "اللغات التي تجيدها",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                const LanguageCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "معلومات الوظيفة ",
                  style: TextStyle(fontSize: 17),
                ),
                JobTitleCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "الخبرات السابقة",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                const ExperienceCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "مشاريع قمت بتنفيذها",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                const ProjectCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "المهارات ",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                SkillsCard(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  " ملف السيرة الذاتية و الوثاثقCV ",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                const FileUploadCard(),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
