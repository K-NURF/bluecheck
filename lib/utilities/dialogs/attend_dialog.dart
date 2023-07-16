import 'package:flutter/material.dart';
import 'package:bluecheck/utilities/dialogs/generic_dialog.dart';

Future<bool> showAttendDialog(BuildContext context, String content) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirm Attendance',
    content: content,
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false,);
}
