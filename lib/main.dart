import 'package:flutter/material.dart';

import 'package:enerlink_mobile/screens/menu.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:provider/provider.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();



  // Try to load .env file, but don't fail if it doesn't exist

  try {

    await dotenv.load(fileName: ".env");

  } catch (e) {

    // .env file not found or error loading, continue without it

    print('Warning: Could not load .env file: $e');

  }



  runApp(const MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});



  // This widget is the root of your application.

  @override

  Widget build(BuildContext context) {

    return Provider(

      create: (_) {

        CookieRequest request = CookieRequest();

        return request;

      },

      child: MaterialApp(

        title: 'Enerlink',

        theme: ThemeData(

          colorScheme: ColorScheme.fromSwatch(

            primarySwatch: Colors.blue,

          ).copyWith(secondary: Colors.blueAccent[400]),

        ),

        home: const MyHomePage(),

      ),

    );  }}