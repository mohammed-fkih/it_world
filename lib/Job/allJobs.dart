import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Job/jobWidght.dart';

class JobsInterface extends StatefulWidget {
  const JobsInterface({super.key});

  @override
  State<JobsInterface> createState() => _JobsInterfaceState();
}

class _JobsInterfaceState extends State<JobsInterface> {
  List<Map<String, dynamic>> gobData = [];
  @override
  void initState() {
    getGobsData();
    super.initState();
  }

  Future<void> getGobsData() async {
    gobData = await FireBase().fetchAllDataFromFirebase('jobs');
    if (mounted) {
      setState(() {});
    }
  }
  List<String> fields = [
  'تطوير الويب',
  'تطبيقات الجوال',
  'تصميم واجهة المستخدم',
  'تطوير البرمجيات',
  'الذكاء الاصطناعي',
  'تحليل البيانات',
  'الأمن المعلوماتي',
  'تقنية السحابة',
  'تجربة المستخدم',
  'تطبيقات الواقع الافتراضي',
  'التعلم الآلي',
  'الروبوتات',
  'تطبيقات الشبكات',
  'تطوير الألعاب',
  'تطبيقات الذكاء الاصطناعي',
  'تحسين محركات البحث',
  'تحليل البيانات الضخمة',
  'التصور البياني',
  'تجربة المستخدم للأجهزة المحمولة',
  'تجربة المستخدم للويب',
  'تصميم الألعاب',
  'تطوير البرمجيات القائمة على السحابة',
  'تطوير تطبيقات الهاتف المحمول المتقدمة',
  'تصميم قواعد البيانات',
  'تقنية تتبع العين',
  'التشفير والأمان',
  'تحسين أداء المواقع',
  'تطبيقات الواقع المعزز',
  'تطبيقات الهندسة الطبية',
  'تصميم الأجهزة',
  'تطبيقات الروبوت',
  'تصميم واجهة المستخدم للهاتف المحمول',
  'تطوير البرمجيات التعليمية',
  'تحليل البيانات الجغرافية',
  'تطوير تطبيقات سطح المكتب',
  'تصميم المواقع',
  'تطوير تطبيقات الويب القائمة على السحابة',
  'تطبيقات الواقع الافتراضي للألعاب',
  'تحليل بيانات السوشيال ميديا',
  'تطبيقات الواقع الافتراضي للتدريب',
  'تصميم الأجهزة القابلة للارتداء',
  'تطوير تطبيقات الذكاء الاصطناعي للروبوتات',
  'تحليل البيانات الصوتية',
  'تطوير تطبيقات الويب الاجتماعية',
];
 String? selectedType;
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
                  Expanded(
                    flex: 9,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'الكل',
                      ),
                      value: selectedType,
                      items: fields.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.substring(2), style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gobData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobShow(
                            index: index,
                            jobs: gobData,
                          ),
                        ),
                      );
                    },
                    child: JobElement(
                      index: index,
                      jobs: gobData,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}