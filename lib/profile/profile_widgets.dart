import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class EducationCard extends StatefulWidget {
  const EducationCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EducationCardState createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  final List<Map<String, dynamic>> _educationData = [];

  final TextEditingController _educationLevelController =
      TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'التخصص',
              ),
              controller: _educationLevelController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'الجامعة',
              ),
              controller: _universityController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'الدرجة',
              ),
              controller: _degreeController,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDateController.text =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                        });
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ البداية',
                        suffixIcon: Icon(Icons.date_range),
                      ),
                      controller: _startDateController,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _endDateController.text =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                        });
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ النهاية',
                        suffixIcon: Icon(Icons.date_range),
                      ),
                      controller: _endDateController,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('إضافة تعليم'),
                  onPressed: () {
                    if (_educationLevelController.text.isNotEmpty &&
                        _universityController.text.isNotEmpty &&
                        _degreeController.text.isNotEmpty &&
                        _startDateController.text.isNotEmpty &&
                        _endDateController.text.isNotEmpty) {
                      setState(() {
                        Map<String, dynamic> education = {
                          'Education Level': _educationLevelController.text,
                          'University': _universityController.text,
                          'Degree': _degreeController.text,
                          'Start Date': _startDateController.text,
                          'End Date': _endDateController.text,
                        };
                        _educationData.add(education);
                        _educationLevelController.clear();
                        _universityController.clear();
                        _degreeController.clear();
                        _startDateController.clear();
                        _endDateController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_educationData.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _educationData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        ' التخصص : ${_educationData[index]['Education Level']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الجامعة: ${_educationData[index]['University']}'),
                        Text('الدرجة : ${_educationData[index]['Degree']}'),
                        Text(
                            ' تاريخ البداية: ${_educationData[index]['Start Date']}'),
                        Text(
                            'تاريخ النهاية: ${_educationData[index]['End Date']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _educationLevelController.text =
                                _educationData[index]['Education Level'];
                            _universityController.text =
                                _educationData[index]['University'];
                            _degreeController.text =
                                _educationData[index]['Degree'];
                            _startDateController.text =
                                _educationData[index]['Start Date'];
                            _endDateController.text =
                                _educationData[index]['End Date'];

                            setState(() {
                              _educationData.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _educationData.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      await FireBase().updateDataInFirebase(
                          'users', user!.uid, {'edution': _educationData});
                      setState(() {
                        isSaved = true;
                      });
                    },
                    child: isSaved
                        ? const Text("تعديل بيانات التعليم")
                        : const Text("حفظ بيانات التعليم"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

//===============================================  add language  ===================================

class LanguageCard extends StatefulWidget {
  const LanguageCard({Key? key}) : super(key: key);

  @override
  _LanguageCardState createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  final List<Map<String, dynamic>> _languages = [];
  Map<String, dynamic> _language = {};
  TextEditingController _languageController = TextEditingController();
  int _selectedRating = 1;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'اللغة',
              ),
              controller: _languageController,
            ),
            const SizedBox(height: 10),
            const Text('درجة الاجادة:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  Row(
                    children: [
                      Radio<int>(
                        value: i,
                        groupValue: _selectedRating,
                        onChanged: (value) {
                          setState(() {
                            _selectedRating = value!;
                          });
                        },
                      ),
                      Text('$i')
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('إضافة لغة'),
                  onPressed: () {
                    if (_languageController.text.isNotEmpty) {
                      setState(() {
                        _language = {
                          'language': _languageController.text,
                          'rating': _selectedRating
                        };
                        _languages.add(_language);
                        _language = {}; // Clear the language variable
                        _languageController.clear();
                        _selectedRating = 1;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_languages.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  String language = _languages[index]['language'] ?? "";
                  int? rating = _languages[index]['rating'];
                  return ListTile(
                    title: Text('اللغة: $language'),
                    subtitle: Text('درجة الاجادة: $rating/5'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _languageController.text = language;
                              _languages.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _languages.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await FireBase().updateDataInFirebase(
                      'users',
                      user!.uid,
                      {'languages': _languages},
                    );
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: Text(
                      isSaved ? "تعديل بيانات اللغات" : "حفظ بيانات اللغات"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//============================================  work info ============

class JobTitleCard extends StatefulWidget {
  const JobTitleCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JobTitleCardState createState() => _JobTitleCardState();
}

class _JobTitleCardState extends State<JobTitleCard> {
  bool isSaved = false;
  bool _isCurrentlyEmployed = false;
  final TextEditingController _personalJobTitleController =
      TextEditingController();
  final TextEditingController _companyJobTitleController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  // ignore: unused_field
  final Map<String, dynamic> _jobTitle = {};
  final List<Map<String, dynamic>> _jobTitles = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'المسمى الوظيفي الشخصي',
              ),
              controller: _personalJobTitleController,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isCurrentlyEmployed,
                  onChanged: (value) {
                    setState(() {
                      _isCurrentlyEmployed = value!;
                    });
                  },
                ),
                const Text('أنا أعمل حاليًا'),
              ],
            ),
            if (_isCurrentlyEmployed) ...[
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ما هو المسمى الوظيفي الحالي في الشركة؟',
                ),
                controller: _companyJobTitleController,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم الشركة التي تعمل فيها',
                ),
                controller: _companyNameController,
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('إضافة مسمى '),
                  onPressed: () {
                    Map<String, dynamic> jobTitle0 = {};
                    if (_isCurrentlyEmployed) {
                      jobTitle0 = {
                        'myjobname': _companyJobTitleController.text,
                        'mycompanyname': _companyNameController.text,
                        'isCurrentlyEmployed': _isCurrentlyEmployed
                      };
                    } else {
                      jobTitle0 = {'isCurrentlyEmployed': _isCurrentlyEmployed};
                    }
                    _jobTitles.add(jobTitle0);

                    //  _personalJobTitleController.clear();
                    _companyJobTitleController.clear();
                    _companyNameController.clear();
                    _isCurrentlyEmployed = false;
                    setState(() {});
                  },
                ),
              ],
            ),
            if (_jobTitles.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('الوظائف المحفوظة:'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _jobTitles.length,
                itemBuilder: (context, index) {
                  String? jobTitle = _jobTitles[index]['myjobname'];
                  String? companyName = _jobTitles[index]['mycompanyname'];
                  return ListTile(
                    title: Text('المسمى الوظيفي: $jobTitle'),
                    subtitle: Text('اسم الشركة: $companyName'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          // ignore: list_remove_unrelated_type
                          _jobTitles.remove(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      await FireBase().updateDataInFirebase(
                          'users', user!.uid, {'myJob': _jobTitles});
                      setState(() {
                        isSaved = true;
                      });
                    },
                    child: isSaved
                        ? const Text("تعديل بيانات الوظيفة")
                        : const Text("حفظ بيانات الوضيفة"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

//================================== Exprexes ==========================================================

class ExperienceCard extends StatefulWidget {
  const ExperienceCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExperienceCardState createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _responsibilitiesController =
      TextEditingController();
  final List<Map<String, dynamic>> _experiences = [];
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'مجال الخبرة',
              ),
              controller: _fieldController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'اسم المؤسسة',
              ),
              controller: _institutionController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'عدد سنين الخبرة',
              ),
              controller: _yearsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'العمل المكلف به',
              ),
              controller: _responsibilitiesController,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('إضافة خبرة '),
                  onPressed: () {
                    String field = _fieldController.text;
                    String institution = _institutionController.text;
                    int years = int.tryParse(_yearsController.text) ?? 0;
                    String responsibilities = _responsibilitiesController.text;

                    if (field.isNotEmpty &&
                        institution.isNotEmpty &&
                        years > 0 &&
                        responsibilities.isNotEmpty) {
                      setState(() {
                        Map<String, dynamic> experience = {
                          'field': field,
                          'institution': institution,
                          'years': years,
                          'responsibilities': responsibilities,
                        };
                        _experiences.add(experience);
                      });

                      _fieldController.clear();
                      _institutionController.clear();
                      _yearsController.clear();
                      _responsibilitiesController.clear();
                    }
                  },
                ),
              ],
            ),
            if (_experiences.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('الخبرات المضافة:'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _experiences.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> experience = _experiences[index];
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
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _fieldController.text = field;
                          _institutionController.text = institution;
                          _yearsController.text = years.toString();
                          _responsibilitiesController.text = responsibilities;
                          _experiences.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await FireBase().updateDataInFirebase(
                        'users', user!.uid, {'experiences': _experiences});
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: isSaved
                      ? const Text("تعديل بيانات خبرات")
                      : const Text("حفظ بيانات الخبرات"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//=========================================  projects ==================================

class ProjectCard extends StatefulWidget {
  const ProjectCard({Key? key}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final List<Map<String, dynamic>> _projects = [];
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'اسم المشروع',
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'وصف المشروع',
              ),
              controller: _descriptionController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'رابط المشروع',
              ),
              controller: _linkController,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('إضافة مشرع'),
                  onPressed: () {
                    String name = _nameController.text;
                    String description = _descriptionController.text;
                    String link = _linkController.text;
                    Map<String, dynamic> project = {};
                    if (name.isNotEmpty &&
                        description.isNotEmpty &&
                        (isValidUrl(link) || link.isEmpty)) {
                      setState(() {
                        project = {
                          'projectName': name,
                          'description': description,
                          'link': link,
                        };
                        _projects.add(project);
                      });
                      _nameController.clear();
                      _descriptionController.clear();
                      _linkController.clear();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('خطأ'),
                            content: const Text('يرجى إدخال رابط صحيح للمشروع'),
                            actions: [
                              TextButton(
                                child: const Text('موافق'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            if (_projects.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('المشاريع المضافة:'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  String name = _projects[index]['projectName'];
                  String description = _projects[index]['description'];
                  String link = _projects[index]['link'] ?? "";

                  return ListTile(
                    title: Text('اسم المشروع: $name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('وصف المشروع: $description'),
                        Text('رابط المشروع: $link'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _nameController.text = name;
                              _descriptionController.text = description;
                              _linkController.text = link;
                              _projects.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _projects.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await FireBase().updateDataInFirebase(
                      'users',
                      user!.uid,
                      {'projects': _projects},
                    );
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: isSaved
                      ? const Text("تعديل بيانات المشاريع")
                      : const Text("حفظ بيانات المشاريع"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasScheme ?? false;
  }
}

//=================================================== commnection ===============================

// class PhoneCard extends StatefulWidget {
//   const PhoneCard({super.key});
//   @override
//   _PhoneCardState createState() => _PhoneCardState();
// }

// class _PhoneCardState extends State<PhoneCard> {
//   final TextEditingController _phoneNumberController = TextEditingController();

//   final Map<String, String> _phoneNumbers = {};

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 200, // You can adjust the width to your desired value
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'رقم الهاتف',
//                 ),
//                 controller: _phoneNumberController,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   child: Text('حفظ'),
//                   onPressed: () {
//                     String phoneNumber = _phoneNumberController.text;

//                     if (phoneNumber.isNotEmpty) {
//                       setState(() {
//                         _phoneNumbers['phonmumder'] = phoneNumber;
//                       });

//                       _phoneNumberController.clear();
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('خطأ'),
//                             content: Text('يرجى إدخال رقم الهاتف'),
//                             actions: [
//                               TextButton(
//                                 child: Text('موافق'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//             if (_phoneNumbers.isNotEmpty) ...[
//               SizedBox(height: 10),
//               Text('أرقام الهواتف المحفوظة:'),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _phoneNumbers.length,
//                 itemBuilder: (context, index) {
//                   String country = _phoneNumbers.keys.elementAt(index);
//                   String phoneNumber = _phoneNumbers.values.elementAt(index);
//                   return ListTile(
//                     title: Text('رقم الهاتف: $phoneNumber'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         setState(() {
//                           _phoneNumbers.remove(country);
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

class FileUploadCard extends StatefulWidget {
  const FileUploadCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FileUploadCardState createState() => _FileUploadCardState();
}

class _FileUploadCardState extends State<FileUploadCard> {
  List<File> files = [];
  bool isSaved = false;
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
      });
    } else {
      // لم يتم اختيار أي ملف
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: _selectFile,
            ),
            title: const Text('رفع الملفات'),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.file_copy),
                title: Text(files[index].path),
              );
            },
          ),
          ElevatedButton(
            onPressed: _selectFile,
            child: const Text('إضافة ملف آخر'),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await FireBase().updateDataInFirebase(
                        'users', user!.uid, {'cvFile': files});
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: isSaved
                      ? const Text("تعديل ملفات CV")
                      : const Text("حفظ ملفات CV"))
            ],
          )
        ],
      ),
    );
  }
}

//=======================================================  Skills ========================================

class SkillsCard extends StatefulWidget {
  const SkillsCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SkillsCardState createState() => _SkillsCardState();
}

class _SkillsCardState extends State<SkillsCard> {
  List<String> skills = [];
  bool isSaved = false;

  final TextEditingController _skillController = TextEditingController();

  void _addSkill() {
    setState(() {
      if (_skillController.text.isNotEmpty) {
        skills.add(_skillController.text);
        _skillController.clear();
      }
    });
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: TextField(
              controller: _skillController,
              decoration: const InputDecoration(
                labelText: 'أدخل المهارة',
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addSkill,
            ),
          ),
          Wrap(
            children: skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: Chip(
                  label: Text(skill),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await FireBase().updateDataInFirebase(
                        'users', user!.uid, {'skills': skills});
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: isSaved
                      ? const Text("تعديل المهارات")
                      : const Text("حفظ المهارات"))
            ],
          )
        ],
      ),
    );
  }
}
