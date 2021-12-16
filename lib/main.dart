import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animations/animations.dart';
import 'package:todo_app_firebase/Screens/discussions-screen.dart';
import 'package:todo_app_firebase/Screens/finished-tasks-screen.dart';
import 'package:todo_app_firebase/Screens/started-tasks-screen.dart';
import 'package:todo_app_firebase/Screens/tasks-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0;

  static const List<Widget> _screenOptions = <Widget>[
    DiscussionsScreen(),
    TasksScreen(),
    StartedTasksScreen(),
    FinishedTasksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        centerTitle: true,
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation) =>
            FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
        ),
        child: _screenOptions[pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Discussions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Started',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Finished',
          ),
        ],
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
