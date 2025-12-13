import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../utils/constants/routes.dart';
import '../utils/validator/form_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Login Screen')),
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.sizeOf(context).height,
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (_, state) async {
            if (state is AuthenticatedState) {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Success'),
                  content: const Text('You are authenticated successfully!'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.popAndPushNamed(context, Routes.home),
                    ),
                  ],
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoTextFormFieldRow(
                  controller: _usernameController,
                  placeholder: 'Enter your username',
                  validator: isNotEmpty,
                ),
                SizedBox(height: 20),
                CupertinoButton.filled(
                  onPressed: _onLoginBtnTapped,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginBtnTapped() {
    if (_formKey.currentState!.validate()) {
      // Remove extra spaces
      final username = _usernameController.text.trim();
      context.read<AuthBloc>().add(LoginRequestedEvent(username: username));
    }
  }
}
