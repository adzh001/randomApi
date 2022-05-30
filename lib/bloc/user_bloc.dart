import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:random_api/models/randomUserModels.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is GeteUserEvent) {
        emit(UserLoadingState());
        try {
          var url = Uri.parse("https://randomuser.me/api/");
          var response = await get(url);
          if (response.statusCode == 200) {
            UserModel userModel = UserModel.fromRawJson(response.body);
            emit(UserFetchedState(userModel: userModel));
          } else {
            print('qwerty');
            emit(UserErrorState(message: "Error from server"));
          }
        } on SocketException catch (e) {
          emit(UserErrorState(message: "No internet connection"));
        } catch (e) {
          print('e === $e');
          emit(UserErrorState(message: e.toString()));
        }
      }
    });
  }
}
