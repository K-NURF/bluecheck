import 'package:flutter/widgets.dart';
import 'package:bluecheck/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        'We have sent you an email to reset your pasword. Check email for more information',
    optionsBuilder: () => {'OK': null},
  );
}
