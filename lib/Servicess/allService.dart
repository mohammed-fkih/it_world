import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Servicess/serviceWidght.dart';

class ServiceInterface extends StatefulWidget {
  const ServiceInterface({super.key});

  @override
  State<ServiceInterface> createState() => _JobsInterfaceState();
}

class _JobsInterfaceState extends State<ServiceInterface> {
  List<Map<String, dynamic>> services = [];
  int aplicationcount = 0;
  List<dynamic> asleeps = [];
  @override
  void initState() {
    getServicData();

    super.initState();
  }

  Future<void> getServicData() async {
    services = await FireBase().fetchAllDataFromFirebase('services');
    if (mounted) {
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
                SizedBox(
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
                    items: jobCategories.map((category) {
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  ServiceElement(
                    index: index,
                    service: services,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text(
                          '           تقديم          ',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          aplicationcount = services[index]['aplicationcont'] ?? [];
                          asleeps = services[index]['asleeps'] ?? [];
                          aplicationcount++;
                          final user = FirebaseAuth.instance.currentUser;
                          asleeps.add(user!.uid);
          
                          await FireBase().updateDataInFirebase(
                              'services', services[index]['gID'], {
                            'aplicationcont': aplicationcount,
                            'asleeps': asleeps
                          });
          
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
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
