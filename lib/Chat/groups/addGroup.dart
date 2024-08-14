import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<String> selectedUsers = [];
  List<String>? selectedDomain = [];
  File? _imageFile;
  String? imageUrl;
  final TextEditingController _groupName = TextEditingController();
  final TextEditingController _groupDesc = TextEditingController();
  List<Map<String, dynamic>>? users;

  @override
  void initState() {
    final use = FirebaseAuth.instance.currentUser;
    selectedUsers.add(use!.email.toString());
    super.initState();

    getUsers();
  }

  Future<void> getUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    selectedDomain?.add(user?.email ?? '');
    users = (await FireBase().fetchAllDataFromFirebase("users"));
    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  Future<void> _showImageSourceDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void toggleUserSelection(String userEmail) {
    setState(() {
      if (selectedUsers.contains(userEmail)) {
        selectedUsers.remove(userEmail);
      } else {
        selectedUsers.add(userEmail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء مجموعة'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.blueGrey, width: 0.6),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
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
                            onPressed: () {
                              _showImageSourceDialog();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: _groupName,
                  decoration: const InputDecoration(labelText: 'اسم المجموعة'),
                ),
                TextFormField(
                  controller: _groupDesc,
                  decoration: const InputDecoration(
                    labelText: 'نبذة مختصرة عن المجموعة',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'قم بإضافة أعضاء :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: users?.length ?? 0,
                  itemBuilder: (context, index) {
                    final userName = users?[index]['name'] ?? '';
                    final uesrEmail = users?[index]['email'] ?? '';
                    final isSelected = selectedUsers.contains(uesrEmail);
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                      ),
                      title: Text(userName),
                      subtitle: Text(uesrEmail),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          toggleUserSelection(uesrEmail);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_imageFile != null) {
                      imageUrl = await FireBase().uploadFile(_imageFile!);
                    }

                    // ignore: unnecessary_null_comparison
                    if ((_groupName.text != null && _groupName.text != "") &&
                        selectedUsers.isNotEmpty) {
                      await FireBase().addDataToFirebase_Id('groups', {
                        'name': _groupName.text,
                        'descrip': _groupDesc.text,
                        'imageUrl': imageUrl,
                        'members': selectedUsers.toList(),
                        'domain': selectedDomain,
                        'createdAt': DateTime.now()
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      const snackBar = SnackBar(
                        content: Text('تم إنشاء المجموعة'),
                        duration: Duration(seconds: 2),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      const snackBar = SnackBar(
                        content: Text('قم بكتابة اسم المجموعة واختيار أعضاء'),
                        duration: Duration(seconds: 2),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    // ignore: use_build_context_synchronously
                  },
                  child: const Text('إنشاء المجموعة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
