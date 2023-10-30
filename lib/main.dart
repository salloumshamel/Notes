// home work add options to change font in the application
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/View/screens/home/home_screen.dart';
import 'package:snotes/View/screens/note/note_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NoteProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Provider.of<NoteProvider>(context, listen: false).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomePage());
          case '/note':
            int id = settings.arguments as int;
            return MaterialPageRoute(
                builder: (context) => NoteScreen(
                      id: id,
                    ));
          default:
            return MaterialPageRoute(builder: (context) => HomePage());
        }
      },
    );
  }
}
