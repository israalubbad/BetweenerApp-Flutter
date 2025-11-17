import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/user_provider.dart';
import '../widgets/list_tile_user.dart';

class SearchView extends StatefulWidget {
  static const String id = '/search_view';

  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: false,
        title: const Text('Search Users'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => _performSearch(),
              decoration: InputDecoration(
                hintText: "Search by name…",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, provider, _) {
                  final query = _searchController.text.trim();

                  if (query.isEmpty) {
                    return const Center(
                      child: Text(
                        "Type to search for users…",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  if (provider.users.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.users.isError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  if (provider.users.isCompleted) {
                    final users = provider.users.data ?? [];

                    if (users.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) =>
                          ListTileUser(user: users[index], index: index),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    context.read<UserProvider>().searchUser(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }
}
