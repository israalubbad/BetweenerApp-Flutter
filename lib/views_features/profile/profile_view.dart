import 'package:betweener_app/models/followers_api_response.dart';
import 'package:betweener_app/models/link_response_model.dart';
import 'package:betweener_app/views_features/auth/login_view.dart'
    show LoginView;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/api_response.dart';
import '../../view_models/followers_provider.dart';
import '../../view_models/link_provider.dart';
import '../../view_models/user_provider.dart';
import '../widgets/custom_slidable_widget.dart';
import '../widgets/custom_user_data_contenar.dart';

class ProfileView extends StatefulWidget {
  static String id = '/profileView';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
      Provider.of<LinkProvider>(context, listen: false).fetchLinks();
      Provider.of<FollowersProvider>(context, listen: false).fetchFollowers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                final response = provider.userResponse;

                if (response == null || response.status == Status.LOADING) {
                  return Center(child: CircularProgressIndicator());
                }

                if (response.status == Status.ERROR) {
                  Future.microtask(() {
                    Navigator.pushReplacementNamed(context, LoginView.id);
                  });
                  return SizedBox();
                }

                final user = response.data!;
                return CustomUserDataContainer(user: user.user!, isUser: true);
              },
            ),

            SizedBox(height: 20),

            Text(
              'Your Links',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12),

            Consumer<LinkProvider>(
              builder: (context, provider, child) {
                final response = provider.links;

                if (response.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (response.isError) {
                  return Center(child: Text(response.message!));
                }

                if (response.isCompleted) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: response.data!.length,
                    itemBuilder: (context, index) {
                      final link = response.data![index];
                      return CustomSlidableWidget(
                        link: link,
                        isMyProfile: true,
                        index: index,
                      );
                    },
                  );
                }
                return Center(child: Text('No Links'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
