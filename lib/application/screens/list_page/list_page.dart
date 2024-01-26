import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test_app/application/screens/details_page/details_page.dart';
import 'package:interview_test_app/application/screens/list_page/bloc/users_list_bloc.dart';
import 'package:interview_test_app/data/models/users_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageWrapperProvider extends StatelessWidget {
  const ListPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersListBloc(),
      child: const ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int launchCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLaunchCount();
    final usersListBloc = context.read<UsersListBloc>(); // Access the Bloc
    usersListBloc.add(LoadUsersList());
  }

  Future<void> _loadLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    launchCount = prefs.getInt('launch_count') ?? 0;
    launchCount++;
    setState(() {});
    await prefs.setInt('launch_count', launchCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Users List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Launch Count'),
                Text(launchCount.toString())
              ],
            ),
          )
        ],
      ),
      body: BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          if (state is UsersListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersListLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: state.usersList.length,
                itemBuilder: (context, index) {
                  final user = state.usersList[index];
                  return UsersListItem(user: user);
                },
              ),
            );
          } else if (state is UsersListError) {
            return const Center(
              child: Text('Failed to fetch users list.', style: TextStyle(fontSize: 24, color: Colors.red),),
            );
          } else {
          return Container();
          }
        },
      ),
    );
  }
}

class UsersListItem extends StatelessWidget {
  const UsersListItem({
    super.key,
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(user: user),
            ));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                user.avatar,
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.height * 0.09,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes !=
                              null
                          ? loadingProgress
                                  .cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
