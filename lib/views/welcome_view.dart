import 'package:bluecheck/services/auth/bloc/auth_bloc.dart';
import 'package:bluecheck/services/auth/bloc/auth_event.dart';
import 'package:bluecheck/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

enum MenuAction { logout }


class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Welcome to BlueCheck'),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            })
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('You have logged in'),
        ),
    );
  }
}