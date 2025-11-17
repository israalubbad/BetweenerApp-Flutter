import 'package:betweener_app/core/util/constants.dart';
import 'package:betweener_app/views_features/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/helpers/api_response.dart';
import '../../view_models/auth_provider.dart';
import '../../view_models/link_provider.dart';
import '../../view_models/user_provider.dart';
import '../links/add_link_view.dart';
import '../search/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const id = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
      Provider.of<LinkProvider>(context, listen: false).fetchLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, SearchView.id);
            },
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () async {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, LoginView.id);
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    final response = provider.userResponse;

                    if (response == null || response.status == Status.LOADING) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (response.status == Status.ERROR) {
                      Future.microtask(() {
                        Navigator.pushReplacementNamed(context, LoginView.id);
                      });
                      return const SizedBox();
                    }
                    final user = response.data!;
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello ${user.user.name}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: QrImageView(
                              data: user.user.id.toString(),
                              version: QrVersions.auto,
                              size: 330,
                              backgroundColor: Colors.white,
                              foregroundColor: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Divider(color: Colors.black, height: 9),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Consumer<LinkProvider>(
                builder: (context, provider, child) {
                  final response = provider.links;
                  if (response.isCompleted) {
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (response.data!.length) + 1,

                        itemBuilder: (context, index) {
                          if (index == response.data!.length) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.all(8),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: kLightPrimaryColor,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddLinkView(),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: kPrimaryColor),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Add Link',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kLightSecondaryColor,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    response.data![index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: kOnSecondaryColor),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    response.data![index].link,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: kOnSecondaryColor),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    );
                  } else if (response.isError) {
                    return Center(child: Text('${response.message}'));
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
