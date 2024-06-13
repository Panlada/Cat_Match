import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/repositories/repositories.dart';
import 'config/app_router.dart';
import '/screens/screens.dart';

import 'config/theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase init
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: "AIzaSyD5V2fvKzE-4F_jssyt8RxqS3u5HBre-ig",
            authDomain: "flutter-cat-matching.firebaseapp.com",
            projectId: "flutter-cat-matching",
            storageBucket: "flutter-cat-matching.appspot.com",
            messagingSenderId: "1065080694428",
            appId: "1:1065080694428:web:a44fae4a3c31f2f04faf59",
          )
        : null,
  );
  // firebase init

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // initiate auth repository
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        // initiate auth repository

        // initiate repository that connect with firebase firestore db
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
        // initiate repository that connect with firebase firestore db

        // initiate repository that connect with firebase storage db
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
        // initiate repository that connect with firebase storage db

        // initiate repository that connect with google map api
        RepositoryProvider(
          create: (context) => LocationRepository(),
        ),
        // initiate repository that connect with google map api
      ],
      child: MultiBlocProvider(
        providers: [
          // initiate auth bloc
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              databaseRepository: context.read<DatabaseRepository>(),
            ),
          ),
          // initiate auth bloc

          // initiate login cubit
          BlocProvider<LoginCubit>(
            create: (context) =>
                LoginCubit(authRepository: context.read<AuthRepository>()),
          ),
          // initiate login cubit
        ],
        child: MaterialApp(
          title: 'Cat Match',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
