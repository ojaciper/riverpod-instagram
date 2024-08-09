import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram_clone/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:instantgram_clone/state/auth/backend/authenticator.dart';
import 'package:instantgram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram_clone/state/auth/providers/is_logged_in_provider.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer(builder: (context, ref, child) {
        final isLoggedIn = ref.watch(isLoggedInProvider);
        isLoggedIn.log();
        if (isLoggedIn) {
          return const MainView();
        } else {
          return const LoginView();
        }
      }),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main View"),
      ),
      body: Center(child: Consumer(builder: (context, ref, child) {
        return Center(
          child: TextButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text("Logout"),
          ),
        );
      })),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final authStateNotifier = ref.read(authStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login View"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              await authStateNotifier.loginWithGoogle();
            },
            child: const Text("Signin with Google"),
          ),
          TextButton(
            onPressed: () async {
              await authStateNotifier.loginWithFacebook();
            },
            child: const Text("Signin with Facebook"),
          ),
        ],
      ),
    );
  }
}
