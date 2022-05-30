part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserFetchedState extends UserState {
  final UserModel userModel;

  UserFetchedState({required this.userModel});
}

class UserErrorState extends UserState {
  final String? message;

  UserErrorState({this.message});
}
