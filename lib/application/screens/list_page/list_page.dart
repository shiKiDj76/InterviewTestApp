import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test_app/application/screens/details_page/details_page.dart';
import 'package:interview_test_app/application/screens/list_page/bloc/users_list_bloc.dart';

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

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersListBloc = context.read<UsersListBloc>(); // Access the Bloc
    usersListBloc.add(LoadUsersList());

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Users List'),
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
                                    user.firstName + ' ' + user.lastName,
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
                },
              ),
            );
          } else {
            // Handle other states (e.g., error)
            return Container();
          }
        },
      ),
    );
  }
}
