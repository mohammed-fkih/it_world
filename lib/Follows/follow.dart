import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';

class FollowersPage extends StatefulWidget {
  final List<dynamic> followingIds;
  final int type;

  const FollowersPage({ required this.followingIds, required this.type});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
 List<Map<String,dynamic>>followersList=[];
Future<void> getUserData() async {
  for (var element in widget.followingIds) {
    final user = await FireBase().fetchDataFromFirebase_DoucmentID('users', element);
    if (user is Map<String, dynamic>) {
      followersList.add(user);
    } else {
      // يمكنك إضافة منطق للتعامل مع الحالة التي لا تكون فيها القيمة على النوع المتوقع
      // أو تجاهلها إذا كان ذلك مناسبًا لتطبيقك
    }
  }
 setState(() {
   
 });
 
}
Future<void> getUserData1() async {
  for (var element in widget.followingIds) {
    final user = await FireBase().fetchDataFromFirebase_DoucmentID('users', element);
    if (user is Map<String, dynamic>) {
      followersList.add(user);
    } else {
      // يمكنك إضافة منطق للتعامل مع الحالة التي لا تكون فيها القيمة على النوع المتوقع
      // أو تجاهلها إذا كان ذلك مناسبًا لتطبيقك
    }
  }
 setState(() {
   
 });
 
}
 @override
  void initState() {
    if(widget.type==0){
       getUserData();
    }else{
       getUserData1();
    }
   
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(widget.type==0?'قائمة المتابعون':'قائمة المتابعين'),
        ),
        body:followersList.isEmpty?const Center(child: Text("قائمة المتابعين فارغة"),):
         ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: followersList.length,
          itemBuilder: (context, index) {
            
            final follower = followersList[index];
            final String userId = follower['id'];
            final String userName = follower['name']??" ";
            final String userImage = follower['image']??'';
    
            // ignore: iterable_contains_unrelated_type
            final isFollowing = widget.followingIds.contains(userId);
    
            return ListTile(
              // ignore: unnecessary_null_comparison
              leading:userImage != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(userImage))
                    : CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Colors.blueGrey[600],
                        ),
                      ),
              
              title: Text(userName),
              trailing:widget.type!=0?
               ElevatedButton(
                onPressed: () {
                  // اضافة أو إزالة المستخدم من قائمة المتابعة
                  if (isFollowing) {
                    // إزالة المستخدم من قائمة المتابعة
                    // اكتب الكود اللازم هنا
                  } else {
                    // إضافة المستخدم إلى قائمة المتابعة
                    // اكتب الكود اللازم هنا
                  }
                },
                child: Text(
                  isFollowing ? 'إلغاء المتابعة' : 'متابعة',
                ),
              ):null,
            );
          },
        ),
      ),
    );
  }
}