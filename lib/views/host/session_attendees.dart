// import 'package:bluecheck/services/cloud/attendee_format.dart';
// import 'package:bluecheck/services/cloud/firestore_storage.dart';
// import 'package:flutter/material.dart';

// class SessionAttendees extends StatefulWidget {
//   const SessionAttendees({super.key, required this.sessionId, required this.name,});
//   final String sessionId;
//   final String name;
//   @override
//   State<SessionAttendees> createState() => _SessionAttendeesState();
// }

// class _SessionAttendeesState extends State<SessionAttendees> {
//   FirestoreStorage firestoreStorage = FirestoreStorage();
//   late final String sessionId;
//   late final String sessionName;
//   List<Attendee> attendeesList = [];
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Future<void> initState() async {
//     sessionId = widget.sessionId;
//     sessionName = widget.name;
//     final attendees = await firestoreStorage.fetchAttendees(sessionId);
//     setState(
//       () {
//         attendeesList = List.from(attendees);
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Attendees for $sessionName',
//           style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//         ),
//         centerTitle: true,
//       ),
// //       body: Scrollbar(
// //       thumbVisibility: true,
// //       controller: _scrollController,
// //       child: ListView.separated(
// //         shrinkWrap: true,
// //         scrollDirection: Axis.vertical,
// //         physics: const ScrollPhysics(),
// //         controller: _scrollController,
// //         itemCount: attendeesList.length,
// //         separatorBuilder: (BuildContext context, int index) => const Divider(
// //           height: 1,
// //           color: Colors.black,
// //         ),
// //         // itemBuilder: (context, index) {
// //         //   Attendee attendee = attendeesList[index];
// //         //   final item = ListTile(
// //         //       title: Text(
// //         //         // session.name,'d'
// //         //         textAlign: TextAlign.justify,
// //         //         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
// //         //               fontSize: 14,
// //         //               // color: const Color(0xFF1A1B26),
// //         //               fontWeight: FontWeight.normal,
// //         //             ),
// //         //       ),
// //         //       // subtitle: Text(session.created.toString()),
// //         //       onTap: () {
                
// //         //         // Navigator.of(context)
// //         //         //     .pushNamedAndRemoveUntil(home, (route) => false);
// //         //       });
// //         //   return item;
// //         // },
// //       ),
// //     )
// //     );
// //   }
// }
