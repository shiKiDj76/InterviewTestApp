import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // final usersListBloc = context.read<UsersListBloc>(); // Access the Bloc
    // usersListBloc.add(LoadUsersList());

    return BlocConsumer<UsersListBloc, UsersListState>(
      listener: (context, state) {
        if (state is UsersListInitial) {
          context.read<UsersListBloc>().add(LoadUsersList());
        }
      },
      builder: (context, state) {
        if (state is UsersListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersListLoaded) {
          return ListView.builder(
            itemCount: state.usersList.length,
            itemBuilder: (context, index) {
              final user = state.usersList[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    user.avatar,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  title: Text(user.firstName + ' ' + user.lastName),
                  subtitle: Text(user.email),
                ),
              );
            },
          );
        } else {
          // Handle other states (e.g., error)
          return Container();
        }
      },
    );
  }
}
