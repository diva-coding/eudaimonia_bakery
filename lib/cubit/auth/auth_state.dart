part of 'auth_cubit.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final bool rememberMe;
  const AuthState({required this.isLoggedIn, this.accessToken, this.rememberMe = false});
}

final class AuthInitialState extends AuthState {
  const AuthInitialState(): super(isLoggedIn: true, accessToken: "", rememberMe: false);
}