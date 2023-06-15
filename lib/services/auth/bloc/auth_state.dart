import 'package:bluecheck/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(
      {required super.isLoading, required this.exception});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword(
      {required this.exception,
      required this.hasSentEmail,
      required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  final Exception? exception;
  final bool notVerified;
  const AuthStateNeedsVerification(
      {required super.isLoading, required this.notVerified, this.exception,super.loadingText});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut(
      {required this.exception,
      required bool isLoading,
      super.loadingText //new method of doing it
      })
      : super(isLoading: isLoading); //method shown in course

  @override
  List<Object?> get props => [exception, isLoading];
}
