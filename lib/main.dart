import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:red_social/domain/uses_cases/Auth_use_case.dart';
import 'package:red_social/infraestructure/repositories/firebase_auth_repository.dart';
import 'package:red_social/presentation/pages/Init_page.dart';
import 'package:red_social/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_social/presentation/providers/post_provider.dart';

import 'infraestructure/injectories/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUp();
  final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
  final authUseCase = AuthUseCase(authRepository);

  runApp(

    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Auth1Provider(authUseCase)),
    ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => GetIt.I<PostProvider>()
                ..getPosts('post')

          ),
        ],
        child : MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Red Social',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyInitPage(),
        )
    );
  }
}
