import 'package:bluecheck/constants/routes.dart';
import 'package:bluecheck/services/auth/bloc/auth_bloc.dart';
import 'package:bluecheck/services/auth/bloc/auth_event.dart';
import 'package:bluecheck/services/auth/firebase_auth_provider.dart';
import 'package:bluecheck/services/cloud/firestore_storage.dart';
import 'package:bluecheck/utilities/dialogs/logout_dialog.dart';
import 'package:bluecheck/views/host/attendees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../services/cloud/session_format.dart';
import '../services/cloud/sessiondetails_format.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

enum MenuAction { logout }

class _DashBoardState extends State<DashBoard> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  FirestoreStorage firestoreStorage = FirestoreStorage();

  @override
  void initState() {
    mapUsersSessions();
    mapUsersDetails();
    super.initState();
  }

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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(profile);
            },
            icon: const Icon(Icons.manage_accounts_sharp),
          ),
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(createClass);
                    },
                    child: const Text('Create Session'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(scanBeacon);
                    },
                    child: const Text('Scan Beacon'),
                  ),
                ),
              ],
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Color.fromARGB(255, 179, 30,
                        134), // Set the text color of the selected tab
                    unselectedLabelColor: Color.fromARGB(137, 150, 18,
                        18), // Set the text color of unselected tabs
                    tabs: [
                      Tab(text: 'Created Sessions'),
                      Tab(text: 'Attended Sessions'),
                    ],
                  ),
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight -
                          150, // Adjust the size as needed
                      child: TabBarView(
                        children: [
                          Center(
                            child: _userSessionsList(),
                          ),
                          Center(
                            child: _userListAttended(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userSessionsList() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController2,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: sessionList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          Session session = sessionList[index];
          final item = ListTile(
              title: Text(
                session.name,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      // color: const Color(0xFF1A1B26),
                      fontWeight: FontWeight.normal,
                    ),
              ),

              // ...
              subtitle: Text(
                  'Created at: ${DateFormat('kk:mm – dd-MM-yyyy').format(session.created.toDate())}'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (route) =>
                        Attendees(sessionId: session.sessionId)));

                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(home, (route) => false);
              });
          return item;
        },
      ),
    );
  }
  
  Widget _userListAttended() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: sessionListId.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          SessionId session = sessionListId[index];
          final item = ListTile(
              title: Text(
                session.sessionName,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      // color: const Color(0xFF1A1B26),
                      fontWeight: FontWeight.normal,
                    ),
              ),

              // ...
              subtitle: Text(
                  'Attended at: ${DateFormat('kk:mm – dd-MM-yyyy').format(session.time.toDate())}'),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (route) =>
                //         Attendees(sessionId: session.sessionId)));

                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(home, (route) => false);
              });
          return item;
        },
      ),
    );
  }

  List<Session> sessionList = [];

  void mapUsersSessions() async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    final session = await firestoreStorage.fetchUserSessions(currentUser.id);
    // print(session);
    setState(() {
      sessionList = List.from(session);
    });
  }

  List<SessionId> sessionListId = [];

  void mapUsersDetails() async {
    final details = await firestoreStorage.fetchUserAttended();
    // print('Trying to print details');
    // print('details $details');
    setState(() {
      sessionListId = List.from(details);
    });
    // print(sessionList);
  }
}
