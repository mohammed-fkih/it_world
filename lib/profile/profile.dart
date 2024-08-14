import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_world/Auth/login.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Follows/follow.dart';
import 'dart:io';
import 'package:it_world/profile/addDelopProfile.dart';
import 'package:it_world/profile/myposts.dart';
import 'package:it_world/profile/showProfileData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> follower = [];
  List<dynamic> followed = [];
  File? _imageFile;
  int index1 = 0;
  // ignore: non_constant_identifier_names
  List<dynamic> Page = [];
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  String formatPostDate(Timestamp dateTime) {
    DateTime dateTimeObject = dateTime.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTimeObject);
    if (difference.inSeconds < 60) {
      return "الآن";
    } else if (difference.inMinutes < 60) {
      return 'قبل  ${difference.inMinutes}  دقيقة';
    } else if (difference.inHours < 24) {
      return 'قبل  ${difference.inHours} ساعة';
    } else {
      final formattedDate =
          '${dateTimeObject.day}-${dateTimeObject.month}-${dateTimeObject.year}';
      return formattedDate;
    }
  }

  double valution = 0;
  int countVotes = 1000;
  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختيار مصدر الصورة'),
            content: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('الكاميرا'),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('الملفات'),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> userData = {};
  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    userData = (await FireBase()
        .fetchDataFromFirebase_DoucmentID('users', user!.uid))!;
    follower = userData['follower'] ?? [];
    followed = userData['followed'] ?? [];
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    final user = FirebaseAuth.instance.currentUser;
    Page = [
      MyPosts(userId: user!.uid, showFollow: 2),
      ShowProFileData(userId: user.uid),
    ];
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الملف الشخصي"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(3),
            color: Colors.white12,

            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey, width: 0.5),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Column(
                        children: [
                          RatingBar.builder(
                            initialRating: valution,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, index) {
                              return Icon(
                                index < 3 ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              );
                            },
                            onRatingUpdate: (rating) {
                              setState(() {
                                valution = rating;
                                countVotes++;
                              });
                            },
                          ),
                          Text(
                            "$countVotes  مقيم",
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      )
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: userData['imageUrl'] != null
                                    ? Image.network(
                                        userData['imageUrl']!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.black12,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: IconButton(
                                onPressed: () async {
                                  _showImageSourceDialog();
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (_imageFile != null) {
                                    String url = await FireBase()
                                        .uploadFile(_imageFile!);
                                    await FireBase().updateDataInFirebase(
                                        'users', user!.uid, {'imageUrl': url});
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.blueGrey,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userData['name'] ?? "",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () async{
                              setState(() {
                              showDialog(context: context, builder: (context){
                                String name=userData['name']??'';
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                      title: const Text('تعديل اسم المستخدم'),
                                      content: TextFormField(
                                        initialValue: name,
                                        onChanged: (value) {
                                          name=value;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'الاسم',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('إلغاء'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('تعديل'),
                                          onPressed: ()async {
                                            final user=FirebaseAuth.instance.currentUser;
                                            FireBase().updateDataInFirebase('users',user!.uid , {
                                              'name':name
                                            });
                                            
                                            // قم بتنفيذ الإجراء الذي ترغب فيه عند الحفظ، مثل تحديث الاسم في قاعدة البيانات
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                );
                             
                              });
                              
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //  Text(userData['myJob'] != ""?
                    //   userData['myJob'][0]["myjobname"]:" ",

                    //   style: const TextStyle(fontSize: 18),
                    // ),
                    const Text("مطور تطبيقات" ,

                       style: TextStyle(fontSize: 18),
                     ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowersPage(followingIds:follower,type: 0,)));
                          },
                          child: Text("${follower.length} يتابع"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowersPage(followingIds:followed,type: 1,)));
                          },
                          child: Text("${followed.length} يتابعه"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(userData['createdAt'] != null
                        ? "إلتحق بالتطيبق في  ${formatPostDate(userData['createdAt'])}"
                        : " "),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddDevlopProFile()),
                              );
                            },
                            child: const Text(
                              "تطوير الملف الشخصي",
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddDevlopProFile()),
                              );
                            },
                            child: const Row(children: [
                              Text(
                                "تعديل الملف الشخصي",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.blue,
                              )
                            ]))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index1 = 0;
                        });
                      },
                      child: Text(
                        'المنشورات ',
                        style: TextStyle(
                            fontWeight: index1 == 0
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index1 = 1;
                        });
                      },
                      child: Text(
                        'الملف الشخصي',
                        style: TextStyle(
                            fontWeight: index1 == 1
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ))
                ],
              ),
              const Divider(),
              Container(
                child: Page[index1],
              ),
              const SizedBox(
                height: 15,
              ),
              ListTile(
                // ignore: use_build_context_synchronously
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text(
                                " تسجيل الخروج",
                                style: TextStyle(color: Colors.red),
                              ),
                              content: const Text(
                                  "هل أنت متأكد من أنك تريد تسجيل الخروج من هذا الحساب"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isLoggedIn', false);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: const Text("تسجيل الخروج")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("إلغاء"))
                              ],
                            ));
                      });
                },
                title: const Text("تسجيل الخروج"),
                leading: const Icon(Icons.output_sharp),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text(
                                "حذف الحساب",
                                style: TextStyle(color: Colors.red),
                              ),
                              content: const Text(
                                  "هل أنت متأكد من أنك تريد حذف الحساب نهائيا عند حذف الحساب لا يمكنك الحصول عليه مرة أخرى"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      FireBase().deleteDataFromFirebase(
                                          'users', user!.uid);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isLoggedIn', false);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: const Text("حذف")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("إلغاء"))
                              ],
                            ));
                      });
                },
                title: const Text(" حذف الحساب"),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
