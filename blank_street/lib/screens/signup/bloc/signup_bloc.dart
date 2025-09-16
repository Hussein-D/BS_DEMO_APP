import 'package:blank_street/models/user.dart';
import 'package:blank_street/screens/signup/repo/signup_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepo repo;
  User? _user;
  SignupBloc(this.repo) : super(SignupInitial()) {
    on<SignupRequest>((event, emit) async {
      String message = "";
      emit(SignupLoading());
      await Future.delayed(const Duration(seconds: 3));
      try {
        await repo.signup(user: event.user);
        _user = event.user;
        message = "User created successfully";
      } catch (e) {
        message = "Error signing up";
      }
      emit(SignupInitial(message: message));
      await Future.delayed(const Duration(seconds: 2));
      emit(SignupInitial(user: _user));
    });
    on<AutloLogin>((event, emit) async {
      emit(SignupLoading());
      await Future.delayed(const Duration(seconds: 3));
      _user = await repo.autologin();
      emit(SignupInitial(user: _user));
    });
    on<Logout>((event, emit) async {
      await repo.logout();
      emit(SignupInitial());
    });
  }
}
