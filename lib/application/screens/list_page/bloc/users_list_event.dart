part of 'users_list_bloc.dart';

@immutable
abstract class UsersListEvent {
  const UsersListEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersList extends UsersListEvent {
  // ...
}

class LoadUserImageAtIndex extends UsersListEvent {
  final int index;
  const LoadUserImageAtIndex(this.index);

  @override
  List<Object> get props => [index];
}
