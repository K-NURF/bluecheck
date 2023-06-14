// import 'package:bluecheck/services/auth/auth_exceptions.dart';
// import 'package:bluecheck/services/auth/bloc/auth_bloc.dart';
// import 'package:bluecheck/services/auth/bloc/auth_event.dart';
// import 'package:bluecheck/services/auth/bloc/auth_state.dart';
// import 'package:bluecheck/utilities/dialogs/error_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({Key? key}) : super(key: key);

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final _key = GlobalKey<FormState>();
//   late MyFormState _state;
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _confirmPasswordController;

//   void _onEmailChanged() {
//     setState(() {
//       _state = _state.copyWith(email: Email.dirty(_emailController.text));
//     });
//   }

//   void _onPasswordChanged() {
//     setState(() {
//       _state = _state.copyWith(
//         password: Password.dirty(_passwordController.text),
//       );
//     });
//   }

//   void _onConfirmPasswordChanged() {
//     setState(() {
//       _state = _state.copyWith(
//         confirmPassword: ConfirmPassword.dirty(_confirmPasswordController.text, _state.password.value),
//       );
//     });
//   }

//   Future<void> _onSubmit() async {
//     if (!_key.currentState!.validate()) return;

//     setState(() {
//       _state = _state.copyWith(status: FormzSubmissionStatus.submissionInProgress);
//     });

//     try {
//       await _submitForm();
//       _state = _state.copyWith(status: FormzSubmissionStatus.submissionSuccess);
//     } catch (_) {
//       _state = _state.copyWith(status: FormzSubmissionStatus.submissionFailure);
//     }

//     if (!mounted) return;

//     setState(() {});

//     FocusScope.of(context)
//       ..nextFocus()
//       ..unfocus();

//     const successSnackBar = SnackBar(
//       content: Text('Submitted successfully! 🎉'),
//     );
//     const failureSnackBar = SnackBar(
//       content: Text('Something went wrong... 🚨'),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         _state.status.isValid ? successSnackBar : failureSnackBar,
//       );

//     if (_state.status.isValid) {
//       _resetForm();
//     }
//   }

//   Future<void> _submitForm() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     context.read<AuthBloc>().add(
//       AuthEventRegister(
//         email,
//         password,
//       ),
//     );
//   }

//   void _resetForm() {
//     _key.currentState!.reset();
//     _emailController.clear();
//     _passwordController.clear();
//     _confirmPasswordController.clear();
//     setState(() => _state = MyFormState());
//   }

//   @override
//   void initState() {
//     _state = MyFormState();
//     _emailController = TextEditingController(text: _state.email.value)
//       ..addListener(_onEmailChanged);
//     _passwordController = TextEditingController(text: _state.password.value)
//       ..addListener(_onPasswordChanged);
//     _confirmPasswordController = TextEditingController(text: _state.confirmPassword.value)
//       ..addListener(_onConfirmPasswordChanged);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateRegistering) {
//           if (state.exception is WeakPasswordAuthException) {
//             await showErrorDialog(context, 'Weak password');
//           } else if (state.exception is EmailAlreadyInUseAuthException) {
//             await showErrorDialog(context, 'Email is already in use');
//           } else if (state.exception is InvalidEmailAuthException) {
//             await showErrorDialog(context, 'Invalid email');
//           } else if (state.exception is GenericAuthException) {
//             await showErrorDialog(context, 'Failed to register');
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Sign Up')),
//         body: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Form(
//             key: _key,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     icon: Icon(Icons.email),
//                     labelText: 'Email',
//                     helperText: 'A valid email e.g. joe.doe@gmail.com',
//                   ),
//                   validator:  _state.email.displayError?.text(),
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                 ),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(
//                     icon: Icon(Icons.lock),
//                     helperText:
//                         'At least 8 characters including one letter and number',
//                     helperMaxLines: 2,
//                     labelText: 'Password',
//                     errorMaxLines: 2,
//                   ),
//                   validator: (_) => _state.password.invalid
//                       ? 'Please enter a valid password'
//                       : null,
//                   obscureText: true,
//                   textInputAction: TextInputAction.next,
//                 ),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   decoration: const InputDecoration(
//                     icon: Icon(Icons.lock),
//                     labelText: 'Confirm Password',
//                   ),
//                   validator: (_) => _state.confirmPassword.invalid
//                       ? _state.confirmPassword.errorText
//                       : null,
//                   obscureText: true,
//                   textInputAction: TextInputAction.done,
//                 ),
//                 const SizedBox(height: 10),
//                 if (_state.status.isSubmissionInProgress)
//                   const CircularProgressIndicator()
//                 else
//                   ElevatedButton(
//                     onPressed: _onSubmit,
//                     child: const Text('Sign Up'),
//                   ),
//                 ElevatedButton.icon(
//                   key: const Key('loginForm_googleLogin_raisedButton'),
//                   label: const Text(
//                     'Continue with Google',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.red,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Perform Google sign-in here
//                   },
//                   icon: const Icon(Icons.g_translate),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class MyFormState with FormzMixin {
//   MyFormState({
//     Email? email,
//     this.password = const Password.pure(),
//     this.confirmPassword = const ConfirmPassword.pure(),
//     this.status = FormzSubmissionStatus.initial,
//   }) : email = email ?? Email.pure();

//   final Email email;
//   final Password password;
//   final ConfirmPassword confirmPassword;
//   final FormzSubmissionStatus status;

//   MyFormState copyWith({
//     Email? email,
//     Password? password,
//     ConfirmPassword? confirmPassword,
//     FormzSubmissionStatus? status,
//   }) {
//     return MyFormState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       confirmPassword: confirmPassword ?? this.confirmPassword,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<FormzInput> get inputs => [email, password, confirmPassword];
// }






// enum EmailValidationError { invalid }

// class Email extends FormzInput<String, EmailValidationError>
//     with FormzInputErrorCacheMixin {
//   Email.pure([super.value = '']) : super.pure();

//   Email.dirty([super.value = '']) : super.dirty();

//   static final _emailRegExp = RegExp(
//     r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
//   );

//   @override
//   EmailValidationError? validator(String value) {
//     return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
//   }
// }

// enum PasswordValidationError { invalid }

// class Password extends FormzInput<String, PasswordValidationError> {
//   const Password.pure([super.value = '']) : super.pure();

//   const Password.dirty([super.value = '']) : super.dirty();

//   static final _passwordRegex =
//       RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

//   @override
//   PasswordValidationError? validator(String value) {
//     return _passwordRegex.hasMatch(value)
//         ? null
//         : PasswordValidationError.invalid;
//   }
// }

// extension on EmailValidationError {
//   String text() {
//     switch (this) {
//       case EmailValidationError.invalid:
//         return 'Please ensure the email entered is valid';
//     }
//   }
// }

// extension on PasswordValidationError {
//   String text() {
//     switch (this) {
//       case PasswordValidationError.invalid:
//         return '''Password must be at least 8 characters and contain at least one letter and number''';
//     }
//   }
// }

// enum ConfirmPasswordValidationError { invalid, mismatch }

// extension ConfirmPasswordValidationErrorText on ConfirmPasswordValidationError {
//   String text() {
//     switch (this) {
//       case ConfirmPasswordValidationError.invalid:
//         return 'Please ensure the passwords match';
//       case ConfirmPasswordValidationError.mismatch:
//         return 'Passwords do not match';
//     }
//   }
// }

// class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {
//   const ConfirmPassword.pure([String value = '']) : super.pure(value);

//   const ConfirmPassword.dirty([String value = '']) : super.dirty(value);

//   @override
//   ConfirmPasswordValidationError? validator(String value) {
//     if (value.isEmpty) {
//       return ConfirmPasswordValidationError.invalid;
//     } else if (value != super.value) {
//       return ConfirmPasswordValidationError.mismatch;
//     }
//     return null;
//   }
// }
