// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JobDataEntryState createState() => _JobDataEntryState();
}

class _JobDataEntryState extends State<AddService> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<String> jobCategories = [
  'تطوير البرمجيات المخصصة',
  'تصميم وتطوير المواقع الإلكترونية',
  'تطوير تطبيقات الجوال',
  'تطوير تطبيقات الويب',
  'تصميم واجهة المستخدم',
  'تجربة المستخدم وتصميم تجربة المستخدم',
  'تحسين محركات البحث وتحسين الأداء الويب',
  'تصميم الرسومات والجرافيكس',
  'تطوير تطبيقات سطح المكتب',
  'تطوير الألعاب',
  'تحليل البيانات والاستخبارات الاصطناعية',
  'تحليل البيانات الضخمة',
  'تطوير الذكاء الاصطناعي والتعلم الآلي',
  'تصميم قواعد البيانات وإدارتها',
  'الحلول السحابية وتقنية المنصات السحابية',
  'تصميم وتطوير الأجهزة القابلة للارتداء',
  'تطوير تطبيقات الواقع المعزز والواقع الافتراضي',
  'تطوير تطبيقات الروبوت',
  'تطوير تطبيقات الشبكات وأمان المعلومات',
  'تطوير تطبيقات الأجهزة الذكية',
  'تصميم وتطوير واجهة المستخدم للأجهزة المحمولة',
  'تطوير تطبيقات البلوكتشين',
  'تطوير تطبيقات الإنترنت الأشياء',
  'تطوير تطبيقات المالية والمدفوعات الإلكترونية',
  'تطوير تطبيقات الطب البايولوجي',
  'تطوير تطبيقات التجارة الإلكترونية',
  'تطوير تطبيقات التعليم الإلكتروني',
  'تصميم وتطوير تطبيقات السفر والسياحة',
  'تصميم وتطوير تطبيقات التوصيل والخدمات',
  'تطوير تطبيقات الصحة الرقمية',
  'تحليل البيانات الصوتية وتطبيقات الموسيقى',
  'تصميم وتطوير البوابات والمنصات الإلكترونية',
  'تصميم وتطوير الروبوتات الذكية',
  'تطوير تطبيقات التسويق الرقمي',
  'تصميم وتطوير تطبيقات الترفيه والثقافة',
  'تطوير تطبيقات الطاقة والبيئة',
  'تصميم وتطوير تطبيقات العقارات والعقارات',
  'تصميم وتطوير تطبيقات اللوجستيات والنقل',
  'تطوير التطبيقات التعليمية',
  'تصميم وتطوير تطبيقات الزراعة الذكية',
  'تصميم وتطوير تطبيقات البحث العلمي',
  'تصميم وتطوير تطبيقات الروبوتات الطبية',
  'تصميم وتطوير تطبيقات الأمن والمراقبة',
  'تصميم وتطوير تطبيقات الألعاب التعليمية',
  'تصميم وتطوير تطبيقات القانونية والمحاماة',
  'تصميم وتطوير تطبيقات البيع بالتجزئة والتجارة الإلكترونية',
  'تصميم وتطوير تطبيقات الدفع الإلكتروني',
  'اخرى'
];

  String? selectedType;

  String? ServiceName;
  String? companyName;

  String? praice;
  String? serviceDesc;
  String? notes;

  Map<String, dynamic> jobData = {};

  void saveJobData() {
    final user = FirebaseAuth.instance.currentUser;
    if (ServiceName != null &&
        companyName != null &&
        selectedDate != null &&
        selectedType != null) {
      FireBase().addDataToFirebase_Id('services', {
        'ServiceName': ServiceName,
        'companyName': companyName,
        'dateOfGet': selectedDate,
        'selectedType': selectedType,
        'serviceDesc': serviceDesc,
        'userId': user?.uid,
        'aplicationcont': 0,
        'praice': praice,
        'state': true,
        'notes': notes,
        'dateSaved': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نشر الطلب بنجاح'),
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('إدخال بيانات الوظيفة'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'اسم الخدمة',
                  ),
                  onChanged: (value) {
                    setState(() {
                      ServiceName = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'اسم المؤسسة التي طلبت الخدمة',
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
                      flex: 9,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'الصنف',
                        ),
                        value: selectedType,
                        items: jobCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category,style: TextStyle(fontSize: 11),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'حدد قيمة الخدمة',
                        ),
                        onChanged: (value) {
                          setState(() {
                            praice = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'وصف الخدمة المطلوبة بالتفصيل',
                  ),
                  onChanged: (value) {
                    setState(() {
                      serviceDesc = value;
                    });
                  },
                  maxLines: 6,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: ' ملاحظة تظهر للجميع',
                  ),
                  onChanged: (value) {
                    setState(() {
                      notes = value;
                    });
                  },
                  maxLines: 2,
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    selectedDate != null
                        ? 'التاريخ المحدد: ${selectedDate.toString().split(' ')[0]}'
                        : 'حدد التاريخ المطلوب لتسليم الخدمة',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      saveJobData();
                    });
                  },
                  child: const Text('نشر طلب الخدمة'),
                ),
              ],
            ),
          )),
    );
  }
}
