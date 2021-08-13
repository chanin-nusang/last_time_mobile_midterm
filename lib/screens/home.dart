import 'package:flutter/material.dart';
import 'package:last_time_mobile_midterm/screens/history.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text('Last Time',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          brightness: Brightness.light, //centerTitle: true,
          // centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          child: Center(
            child: Text('Home'),
          ),
        ));
  }
}
