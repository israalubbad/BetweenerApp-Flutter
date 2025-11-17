import 'package:betweener_app/views_features/profile/profile_view.dart';
import 'package:betweener_app/views_features/recieve/receive_view.dart';
import 'package:betweener_app/views_features/widgets/custom_floating_nav_bar.dart';
import 'package:flutter/material.dart';

import '../core/util/constants.dart';
import 'home/home_view.dart';
import 'links/add_link_view.dart';

class MainAppView extends StatefulWidget {
  static String id = '/mainAppView';

  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  int _currentIndex = 1;

  late List<Widget?> screensList = [
    const ReceiveView(),
    const HomeView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensList[_currentIndex],
      extendBody: true,
      bottomNavigationBar: CustomFloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

        floatingActionButton:_currentIndex == 2 ? FloatingActionButton(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddLinkView.id);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ) : Container()
    );
  }
}
