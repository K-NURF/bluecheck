import 'package:bluecheck/services/auth/bloc/auth_state.dart';
import 'package:bluecheck/utilities/dialogs/error_dialog.dart';
import 'package:bluecheck/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluecheck/services/auth/bloc/auth_bloc.dart';
import 'package:bluecheck/services/auth/bloc/auth_event.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          if (state.notVerified) {
            await showGenericDialog(
              context: context,
              title: 'Not Verified',
              content:
                  'This email has not been verified. If not received, please resend the verification email and try again',
              optionsBuilder: () => {'OK': null},
            );
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context,
                'We could not process your request. Please try again later');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Verify Email',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Lottie.asset('assets/lottie/102360-searching-file.json', height: 400),
                      const Text(
                          "We've sent a verification email, open it to verify your account"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventCheckVerification(),
                              );
                        },
                        child: const Text('Continue to HomePage'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventSendEmailVerification(),
                              );
                        },
                        child: const Text(
                            'Click here to resend verification email'),
                      ),
                      TextButton(
                        onPressed: () async {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: const Text('Go back to login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
