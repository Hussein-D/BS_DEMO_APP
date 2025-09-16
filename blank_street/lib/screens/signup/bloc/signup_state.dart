part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

final class SignupInitial extends SignupState {
  final User? user;
  final String? message;
  const SignupInitial({this.user, this.message});
    @override
  List<Object?> get props => [user,message];
}

class SignupLoading extends SignupState {}
