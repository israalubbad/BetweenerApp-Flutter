import 'package:flutter/material.dart';

import '../../core/util/constants.dart';
import '../../models/user.dart' show UserClass;
import '../profile/friend_profile.dart';

class ListTileUser extends StatelessWidget {
  const ListTileUser({
    super.key,
    required this.user,
    required this.index,
  });
  final int index;
  final UserClass user;

  @override
  Widget build(BuildContext context) {
    final Color color = index % 2 == 0 ? kLightDangerColor : kLightPrimaryColor;
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.all(6),
        tileColor: color,
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person ,color: kPrimaryColor,),
        ),
        title: Text(
          user.name!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  FriendProfile(friendUser: user, )),);
        },
      ),
    );
  }
}
