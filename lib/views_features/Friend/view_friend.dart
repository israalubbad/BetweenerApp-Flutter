import 'package:betweener_app/models/user.dart';
import 'package:flutter/material.dart';
import '../widgets/list_tile_user.dart';


class ViewFriend extends StatelessWidget {
  late List<UserClass> followList;
  late String follow;
   ViewFriend({super.key, required this.followList ,required this.follow});

  static String id = '/view_friend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(follow),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),

      ),

      body: ListView.builder(
             padding: EdgeInsets.all(16),
            itemCount: followList.length ,
            itemBuilder: (context, index) {
              return  ListTileUser(user: followList[index],index: index,);
            },),

    );
  }
}
