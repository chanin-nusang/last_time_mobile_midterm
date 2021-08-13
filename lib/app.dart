import 'package:flutter/material.dart';
import 'package:last_time_mobile_midterm/screens/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 60, 113, 1),
          accentColor: Colors.amberAccent[700],
          scaffoldBackgroundColor: Color.fromRGBO(242, 242, 242, 1),
          canvasColor: Color.fromRGBO(242, 242, 242, 1),
          appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              color: Color.fromRGBO(242, 242, 242, 1),
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black)),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Color.fromRGBO(242, 242, 242, 1),
            elevation: 0.0,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Color.fromRGBO(0, 60, 113, 1),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(0, 60, 113, 1),
                ),
                elevation: MaterialStateProperty.all<double>(0.0)),
          ),
          fontFamily: 'PSU-Stidti'),
      initialRoute: '/',
      routes: {'/': (_) => Home()},
    );
  }
}
