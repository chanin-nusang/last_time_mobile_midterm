import 'package:flutter/material.dart';
import 'package:last_time_mobile_midterm/models/lasttime.dart';
import 'package:last_time_mobile_midterm/screens/history.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var box = Hive.box('lasttime');
  List<LastTime> lastTime = [];
  List<String> category = {}
  @override
  void initState() {
    // pullLastTime();
    super.initState();
  }

  // void pullLastTime() async {
  //   try {
  //     lastTime = await box.get('lasttime');
  //   } catch (e) {

  //   }
  // }

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [],
              ),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    LastTime _lastTime = box.get(index + 1);
                    return Wrap(
                      children: [
                        LasttimeTile(lasttime: _lastTime),
                        if (index < box.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(),
                          )
                      ],
                    );
                  })
            ],
          ),
        ));
  }
}

class LasttimeTile extends StatelessWidget {
  LasttimeTile({@required this.lasttime});
  final lasttime;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
