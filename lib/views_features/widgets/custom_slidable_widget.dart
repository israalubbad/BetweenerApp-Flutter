
import 'package:betweener_app/models/link_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../core/util/constants.dart';
import '../../view_models/link_provider.dart';
import '../links/add_link_view.dart';
class CustomSlidableWidget extends StatelessWidget {
  final LinkElement? link;
  final bool isMyProfile;
  final int index;
  const CustomSlidableWidget({super.key, this.link ,required this.isMyProfile ,required this.index});

  @override
  Widget build(BuildContext context) {
    final Color tileColor = index % 2 == 0 ? kLightDangerColor : kLightPrimaryColor;
    return Slidable(
      key: ValueKey(index),
      endActionPane: isMyProfile ?
      ActionPane(
        extentRatio: 0.35,
        motion: ScrollMotion(),
        children: [
          SizedBox(width: 6),
          SizedBox(
            width: 60,
            height: 60,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        AddLinkView(
                          link: link,)),);
              },
              color: kSecondaryColor,
              textColor: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.edit, size: 20),
            ),
          ),
          SizedBox(width: 6),
          SizedBox(
            width: 60,
            height: 60,
            child: MaterialButton(
              onPressed: () {
                Provider.of<LinkProvider>(context, listen: false).deleteLink(link!.id);
              },
              color: Colors.red,
              textColor: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.delete, size: 20),
            ),
          ),
        ],
      ) : null,

      child: Card(
        color:tileColor ,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            link!.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            link!.link,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
