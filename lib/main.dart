import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth/auth_bloc.dart';
import 'screens/host_screen.dart';
import 'screens/join_screen.dart';
import 'screens/login_screen.dart';
import 'utils/constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        initialRoute: Routes.login,
        title: 'Live stream',
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.login: (context) => const LoginScreen(),
          Routes.host: (context) => const HostScreen(),
          Routes.join: (context) => const JoinScreen(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
