part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupRequest extends SignupEvent {
  final User user;
  const SignupRequest({required this.user});
}

class AutloLogin extends SignupEvent {
  const AutloLogin();
}

class Logout extends SignupEvent {
  const Logout();
}
