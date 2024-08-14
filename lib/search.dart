import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Job/jobWidght.dart';
import 'package:it_world/Servicess/serviceWidght.dart';
import 'package:it_world/profile/showProfile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(this.collectinName);
  final String collectinName;
  

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    dataList = await FireBase().fetchAllDataFromFirebase(widget.collectinName);
  }

  void _search(String query) {
    setState(() {
      searchResults = dataList.where((data) {
        final lowercaseQuery = query.toLowerCase();
        if (widget.collectinName == "jobs") {
          final jobTitle = data['jobTitle'].toString().toLowerCase();
          return jobTitle.contains(lowercaseQuery);
        } else if (widget.collectinName == 'services') {
          final serviceName = data['ServiceName'].toString().toLowerCase();
          return serviceName.contains(lowercaseQuery);
        } else {
          final name = data['name'].toString().toLowerCase();
          return name.contains(lowercaseQuery);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 0.6),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              onChanged: (value) => _search(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ابحث هنا...',
              ),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  if (widget.collectinName == "jobs") {
                    return JobElement(jobs: searchResults, index: index);
                  } else if (widget.collectinName == 'services') {
                    return ServiceElement(service: searchResults, index: index);
                  } else {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            DialogRoute(
                              context: context,
                              builder: (context) => ShowProfile(
                                userId: searchResults[index]['id'],
                              ),
                            ),
                          );
                        },
                        leading: searchResults[index]['imageUrl'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    searchResults[index]['imageUrl'] ?? ""),
                              )
                            : CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blueGrey[600],
                                ),
                              ),
                        title: Text(searchResults[index]['name'] ?? ''),
                        subtitle: Text(searchResults[index]['email'] ?? " "),
                        // يمكنك إضافة المزيد من العناصر هنا
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
