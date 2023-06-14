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
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final _key = GlobalKey<FormState>();
//   late MyFormState _state;
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;

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

//     void _passwordConfirmationChanged(PasswordConfirmationChanged e,Emitter<MyFormState> emit){
//     final confirmedPassword = ConfirmedPassword.dirty(
//       password: _state.password.value,
//       value: e.passwordConfirmStr,
//     );
//     final formStatus = Formz.validate([
//     _state.email,
//     _state.password,
//     confirmedPassword,
//   ]);

//   emit(_state.copyWith(
//     confirmedPassword: confirmedPassword,
//     status: FormzSubmissionStatus.inProgress,
//   ));
//   }

//   Future<void> _onSubmit() async {
//     if (!_key.currentState!.validate()) return;

//     setState(() {
//       _state = _state.copyWith(status: FormzSubmissionStatus.inProgress);
//     });

//     try {
//       await _submitForm();
//       _state = _state.copyWith(status: FormzSubmissionStatus.success);
//     } catch (_) {
//       _state = _state.copyWith(status: FormzSubmissionStatus.failure);
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
//         _state.status.isSuccess ? successSnackBar : failureSnackBar,
//       );

//     if (_state.status.isSuccess) {
//       _resetForm();
//     }
//   }

//   Future<void> _submitForm() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     context.read<AuthBloc>().add(
//           AuthEventRegister(
//             email,
//             password,
//           ),
//         );
//   }

//   void _resetForm() {
//     _key.currentState!.reset();
//     _emailController.clear();
//     _passwordController.clear();
//     setState(() => _state = MyFormState());
//   }

//   @override
//   void initState() {
//     _state = MyFormState();
//     _emailController = TextEditingController(text: _state.email.value)
//       ..addListener(_onEmailChanged);
//     _passwordController = TextEditingController(text: _state.password.value)
//       ..addListener(_onPasswordChanged);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
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
//               key: _key,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       icon: Icon(Icons.email),
//                       labelText: 'Email',
//                       helperText: 'A valid email e.g. joe.doe@gmail.com',
//                     ),
//                     validator: (_) => _state.email.displayError?.text(),
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                   ),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       icon: Icon(Icons.lock),
//                       helperText:
//                           'At least 8 characters including one letter and number',
//                       helperMaxLines: 2,
//                       labelText: 'Password',
//                       errorMaxLines: 2,
//                     ),
//                     validator: (_) => _state.password.displayError?.text(),
//                     obscureText: true,
//                     textInputAction: TextInputAction.done,
//                   ),
//                   TextFormField(
//                     key: _key,
//                     onChanged: (confirmPassword) => ,
//                   ),
//                   const SizedBox(height: 10),
//                   if (_state.status.isInProgress)
//                     const CircularProgressIndicator()
//                   else
//                     ElevatedButton(
//                       onPressed: _onSubmit,
//                       child: const Text('Sign Up'),
//                     ),
//                   ElevatedButton.icon(
//                     key: const Key('loginForm_googleLogin_raisedButton'),
//                     label: const Text(
//                       'Continue with Google',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       // backgroundColor: theme.colorScheme.secondary,
//                     ),
//                     icon:
//                         const Icon(Icons.gps_off_outlined, color: Colors.white),
//                     onPressed: () => context
//                         .read<AuthBloc>()
//                         .add(const AuthEventGoogleLogin()),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }

// class MyFormState with FormzMixin {
//   MyFormState({
//     Email? email,
//     this.password = const Password.pure(),
//     this.conpassword = const ConfirmedPassword.pure(),
//     this.status = FormzSubmissionStatus.initial,
//   }) : email = email ?? Email.pure();

//   final Email email;
//   final Password password;
//   final ConfirmedPassword conpassword;
//   final FormzSubmissionStatus status;

//   MyFormState copyWith({
//     Email? email,
//     Password? password,
//     ConfirmedPassword? confirmedPassword,
//     FormzSubmissionStatus? status,
//   }) {
//     return MyFormState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       conpassword: confirmedPassword ?? conpassword,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<FormzInput<dynamic, dynamic>> get inputs => [email, password, conpassword];
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

// enum ConfirmedPasswordValidationError {
//   invalid,
//   mismatch,
// }

// class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
//   final String password;

//   const ConfirmedPassword.pure({
//     this.password = ''
//   }) : super.pure('');

//   const ConfirmedPassword.dirty({
//     required this.password,
//     String value = ''
//   }) : super.dirty(value);

//   @override
//   ConfirmedPasswordValidationError? validator(String value) {
//     if (value.isEmpty) {
//       return ConfirmedPasswordValidationError.invalid;
//     }
//     return password == value
//         ? null
//         : ConfirmedPasswordValidationError.mismatch;
//   }
// }

// extension Explanation on ConfirmedPasswordValidationError {
//   String? get name {
//     switch(this) {
//       case ConfirmedPasswordValidationError.mismatch:
//         return 'passwords must match';
//       default:
//         return null;
//     }
//   }
// }