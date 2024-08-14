import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Job/jobHome.dart';
import 'package:it_world/Notice/noticeHome.dart';
import 'package:it_world/Servicess/serviceHome.dart';
import 'package:it_world/chat/chatHome.dart';
import 'package:it_world/profile/profile.dart';
import 'package:it_world/search.dart';
import 'Home/homePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const JobHome(),
    const ServiceHome(),
    const ChatHome(),
    const NoticeHome()
  ];
  Map<String, dynamic> userData = {};
  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    userData = (await FireBase()
        .fetchDataFromFirebase_DoucmentID('users', user!.uid))!;
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            toolbarHeight: 50,
            elevation: 2,
            shadowColor: Colors.blueGrey,
            leading: Container(
              margin: const EdgeInsets.all(1),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: userData['imageUrl'] != null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userData['imageUrl']),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
              ),
            ),
            title: const Center(
                child: Text(
              "IT world",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      if (_currentIndex == 1) {
                        return SearchScreen("jobs");
                      } else if (_currentIndex == 2) {
                        return SearchScreen("services");
                      } else {
                        return SearchScreen("users");
                      }
                    }),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                  // إضافة الإجراء المطلوب عند الضغط على زر المزيد
                },
              ),
            ],
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center),
                label: 'الوظائف',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.miscellaneous_services),
                label: 'الخدمات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'الدردشات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'الاشعارات',
              ),
            ],
          ),
        ));
  }
}
