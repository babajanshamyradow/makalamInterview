import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:my_project/src/database/init.dart';
import 'package:my_project/src/pages/home.dart';


final dbHelper = DatabaseSQL();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,]
  );
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'makalam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 90, 88, 92)),
        useMaterial3: true,
      ),
      routes: {
            '/': (context) => const MyHomePage(title: 'Makalam'),
          },
    );
  }
}
