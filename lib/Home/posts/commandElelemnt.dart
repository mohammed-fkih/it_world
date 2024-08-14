import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
class ElementCommend extends StatefulWidget {
  const ElementCommend({super.key, required this.userId, required this.content});
 final String userId;
 final String content;

  @override
  State<ElementCommend> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ElementCommend> {
  @override
  void initState() {
    getUersData();
    super.initState();
    setState(() {
      
    });
    
  }
  Map<String,dynamic> user={};
  Future<void> getUersData()async{
      user=(await FireBase().fetchDataFromFirebase_DoucmentID('users', widget.userId))!;
      if(mounted){
        setState(() {
        
      });
      }
  }
  @override
  Widget build(BuildContext context) {
    return  ListTile(
                        leading: user['imageUrl'] != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user['imageUrl'] ?? ""))
                            : CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blueGrey[600],
                                ),
                              ),
                        title: Text(user['name'] ?? ''),
                        subtitle: Text(widget.content),
                      );
  }
}