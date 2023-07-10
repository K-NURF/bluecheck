import 'package:bluecheck/constants/routes.dart';
import 'package:bluecheck/services/auth/bloc/auth_bloc.dart';
import 'package:bluecheck/services/auth/bloc/auth_event.dart';
import 'package:bluecheck/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

enum MenuAction { logout }

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to BlueCheck',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        // backgroundColor: Color.fromARGB(255, 58, 124, 211),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(createClass);
                  },
                  child: const Text('Create Class'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {Navigator.of(context).pushNamed(scanBeacon);
                  },
                  child: const Text('Scan Beacon'),
                ),
              ],
            ),
            const Text('You have logged in'),
            Lottie.asset('assets/lottie/19148-bluetooth-connected.json'),
          ],
        ),
      ),
    );
  }
}
