part of 'users_list_bloc.dart';

abstract class UsersListState {
  const UsersListState();

  @override
  List<Object?> get props => [];
}

class UsersListInitial extends UsersListState {}

class UsersListLoading extends UsersListState {}

class UsersListLoaded extends UsersListState {
  late List<UserData> usersList;
  UsersListLoaded({required this.usersList});

  @override
  List<Object> get props => [usersList];
}

class UsersListError extends UsersListState {
  final String message;
  UsersListError({required this.message});

  @override
  List<Object?> get props => [message];
}
