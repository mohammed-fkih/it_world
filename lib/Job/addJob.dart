// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});
  

  @override
  // ignore: library_private_types_in_public_api
  _JobDataEntryState createState() => _JobDataEntryState();
}

class _JobDataEntryState extends State<AddJob> {
  List<String> jobCategories = [
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
  'اخرى'
  // المزيد من المجالات هنا
];
  String? selectedCategory;
  List<String> jobFromWhere = [
    'من مقر الشركة ',
    'من المنزل',
  ];
  String? selectedFromWhere;

  String? jobTitle;
  String? companyName;
  String? workSchedule;
  String? workLocation;
  String? employmentStandards;
  String? salary;
  String? jobDescription;
  String? aboutCanpany;
  String? notes;
  bool states = true;
  int asleep = 0;

  Map<String, dynamic> jobData = {};

  void saveJobData() {
    if (jobTitle != null &&
        companyName != null &&
        selectedCategory != null &&
        workLocation != null &&
        workSchedule != null &&
        salary != null &&
        employmentStandards != null) {
      final user = FirebaseAuth.instance.currentUser;
      FireBase().addDataToFirebase_Id('jobs', {
        'jobTitle': jobTitle,
        'companyName': companyName,
        'category': selectedCategory,
        'workSchedule': workSchedule,
        'workLocation': workLocation,
        'FromWhare': selectedFromWhere,
        'employmentStandards': employmentStandards,
        'states': states,
        'asleep': asleep,
        'salary': salary,
        'userId': user?.uid,
        'jobDescription': jobDescription,
        'aboutCanpany': aboutCanpany,
        'notes': notes,
        'createdAt': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نشر الوظيفة بنجاح'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تعبئة الحقول'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    // اقوم بتنفيذ الاجراء الذي أحتاجه عند الضغط على زر الحفظ
    // يمكنني استخدام البيانات المحفوظة في المتغير jobData
  }

  @override
  void initState() {
    selectedFromWhere = jobFromWhere[0].toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('إدخال بيانات الوظيفة'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'اسم الوظيفة',
                  ),
                  onChanged: (value) {
                    setState(() {
                      jobTitle = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'اسم المؤسسة',
                  ),
                  onChanged: (value) {
                    setState(() {
                      companyName = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'الصنف',
                        ),
                        value: selectedCategory,
                        items: jobCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category,style: TextStyle(fontSize: 12),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'مكان العمل',
                        ),
                        value: selectedFromWhere,
                        items: jobFromWhere.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFromWhere = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'الدوام / عدد ساعات العمل',
                  ),
                  onChanged: (value) {
                    setState(() {
                      workSchedule = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'موقع العمل',
                  ),
                  onChanged: (value) {
                    setState(() {
                      workLocation = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'الراتب',
                  ),
                  onChanged: (value) {
                    setState(() {
                      salary = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'وصف العمل',
                  ),
                  onChanged: (value) {
                    setState(() {
                      jobDescription = value;
                    });
                  },
                  maxLines: 6,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'معايير التوظيف',
                  ),
                  onChanged: (value) {
                    setState(() {
                      employmentStandards = value;
                    });
                  },
                  maxLines: 6,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'تحدث عن الشركة الموظفة',
                  ),
                  onChanged: (value) {
                    setState(() {
                      aboutCanpany = value;
                    });
                  },
                  maxLines: 3,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات',
                  ),
                  onChanged: (value) {
                    setState(() {
                      notes = value;
                    });
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    saveJobData();
                  },
                  child: const Text('نشر الوظيفة'),
                ),
              ],
            ),
          )),
    );
  }
}
