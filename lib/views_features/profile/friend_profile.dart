import 'package:betweener_app/models/user.dart';
import 'package:betweener_app/views_features/widgets/custom_user_data_contenar.dart';
import 'package:flutter/material.dart';

class FriendProfile extends StatelessWidget {
  static String id = '/profileView';
  final UserClass friendUser;

  const FriendProfile({super.key, required this.friendUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomUserDataContainer(user: friendUser, isUser: false),

              /// NOTE: This section is commented out intentionally.
              /// The current API does NOT provide access to other users' links.
              /// Only the authenticated user's own links are available via the API.
              /// Therefore, we cannot fetch or display links for another user here.
              /// If API support is added in the future, you can re-enable this block.

              // Consumer<LinkProvider>(
              //   builder: (context, provider, child) {
              //     final response = provider.links;
              //     if (response.isCompleted) {
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         scrollDirection: Axis.vertical,
              //         itemCount: response.data!.length,
              //         itemBuilder: (context, index) {
              //           return CustomSlidableWidget(
              //             link: response.data![index],
              //             isMyProfile: false,
              //                index:  index,
              //           );
              //         },
              //       );
              //     } else {
              //       return const Center(child: Text('No Links'));
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
