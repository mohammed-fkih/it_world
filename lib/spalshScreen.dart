import 'package:flutter/material.dart';
import 'package:it_world/Auth/login.dart';
import 'package:it_world/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // يمكنك هنا إضافة أي عمليات أو تأخيرات ترغب في تنفيذها قبل الانتقال إلى الواجهة الرئيسية

    Future.delayed(Duration(seconds: 3), () {
      checkUserLoggedIn();
    });
  }

  Future<void> checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // المستخدم قام بتسجيل الدخول بالفعل، قم بعرض الواجهة الرئيسية
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // المستخدم لم يقم بتسجيل الدخول بعد، قم بعرض واجهة تسجيل الدخول أو إنشاء حساب جديد
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'IT World',
            style: TextStyle(fontSize: 60),
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator()
        ]),
      ),
    );
  }
}
