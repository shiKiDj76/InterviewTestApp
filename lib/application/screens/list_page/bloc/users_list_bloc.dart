import 'package:bloc/bloc.dart';
import 'package:interview_test_app/data/models/users_list_model.dart';
import 'package:interview_test_app/data/repositories/users_list_repo.dart';
// import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  final UsersListRepository usersListRepository = UsersListRepository();

  UsersListBloc() : super(UsersListInitial()) {
    on<LoadUsersList>((event, emit) async {
      emit(UsersListLoading());

      try {
        final usersList = await usersListRepository.fetchUsersList();
        emit(UsersListLoaded(usersList: usersList));
      } catch (error) {
        emit(UsersListError(message: error.toString()));
      }
    });
  }
}
