import 'package:betweener_app/view_models/auth_provider.dart';
import 'package:betweener_app/view_models/followers_provider.dart';
import 'package:betweener_app/view_models/link_provider.dart';
import 'package:betweener_app/view_models/user_provider.dart';
import 'package:betweener_app/views_features/auth/login_view.dart';
import 'package:betweener_app/views_features/auth/register_view.dart';
import 'package:betweener_app/views_features/home/home_view.dart';
import 'package:betweener_app/views_features/links/add_link_view.dart';
import 'package:betweener_app/views_features/loading/lodaing_screen.dart';
import 'package:betweener_app/views_features/main_app_view.dart';
import 'package:betweener_app/views_features/onboarding/onbording_view.dart';
import 'package:betweener_app/views_features/profile/profile_view.dart';
import 'package:betweener_app/views_features/recieve/receive_view.dart';
import 'package:betweener_app/views_features/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/helpers/shared_prefs.dart';
import 'core/util/constants.dart';
import 'core/util/styles.dart';
int? initScreen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper().initPreferences();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await SharedPrefsHelper().init();
  initScreen = prefs.getInt("initScreen");
  if (initScreen == null) {
    await prefs.setInt("initScreen", 1);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LinkProvider()),
        ChangeNotifierProvider(create: (_) => FollowersProvider())

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Betweener',
        theme: ThemeData(
          useMaterial3: true,

          // ========= COLORS =========
          scaffoldBackgroundColor: kScaffoldColor,

          colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            primary: kPrimaryColor,
            secondary: kSecondaryColor,
            onSecondary: kOnSecondaryColor,
            error: kDangerColor,
            background: kScaffoldColor,
          ),

          // ========= APP BAR =========
          appBarTheme: const AppBarTheme(
            backgroundColor: kScaffoldColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: kPrimaryColor),
            titleTextStyle: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          // ========= TEXT THEME =========
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              color: kPrimaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            bodySmall: TextStyle(
              color: kPrimaryColor,
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
          ),

          // ========= BUTTONS =========
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              foregroundColor: kOnSecondaryColor,
              minimumSize: const Size(double.infinity, 35),
              maximumSize: const Size(double.infinity, 70) ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,

              ),
            ),
          ),

          // ========= INPUT =========
          inputDecorationTheme: InputDecorationTheme(
            border: Styles.primaryRoundedOutlineInputBorder,
            focusedBorder: Styles.primaryRoundedOutlineInputBorder,
            enabledBorder: Styles.primaryRoundedOutlineInputBorder,
            disabledBorder: Styles.primaryRoundedOutlineInputBorder,
          ),

        ),

        initialRoute:
        initScreen == null ? OnBoardingView.id : LoadingScreen.id,

        routes: {
          AddLinkView.id: (context) => AddLinkView(),
          OnBoardingView.id: (context) => OnBoardingView(),
          LoadingScreen.id: (context) => const LoadingScreen(),
          LoginView.id: (context) => const LoginView(),
          RegisterView.id: (context) => const RegisterView(),
          HomeView.id: (context) => const HomeView(),
          MainAppView.id: (context) => const MainAppView(),
          ProfileView.id: (context) => const ProfileView(),
          ReceiveView.id: (context) => const ReceiveView(),
          SearchView.id: (context) => const SearchView(),
        },
      ),
    );
  }
}
