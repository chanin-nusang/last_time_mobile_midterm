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
  LastTime lastTimeInit =
      LastTime('ปลูกผัก', 'Chores', DateTime.now(), DateTime.now());

  List<LastTime> lastTimeBox = [];
  List<LastTime> lastTimeItem = [];
  List<String> category = ['All', 'Chores', 'Learning', 'Body Care', 'People'];
  String dropdownValue = 'All';

  @override
  void initState() {
    box.put('lasttime', lastTimeInit);
    pullLastTime();
    super.initState();
  }

  void pullLastTime() {
    print('Box lenght : ${box.length}');
    try {
      lastTimeBox = box.get('lasttime');
      print('Box lenght : ${box.length}');
      if (dropdownValue == 'All')
        lastTimeItem = lastTimeBox;
      else {
        lastTimeItem = lastTimeBox
            .where((element) => element.category == dropdownValue)
            .toList();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text('Last Time',
                style: TextStyle(color: Colors.black, fontSize: 20)),
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Catagory : "),
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).accentColor,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'All',
                            'Chores',
                            'Learning',
                            'Body Care',
                            'People'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.add,
                        // color: Colors.pink,
                        size: 24.0,
                      ),
                      label: Text('Add'),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              if (lastTimeItem.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Center(child: Text('No Last Time List.')),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: lastTimeItem.length,
                      itemBuilder: (BuildContext context, int index) {
                        LastTime _lastTime = lastTimeItem[index];
                        return Wrap(
                          children: [
                            LasttimeTile(lasttime: _lastTime),
                            if (index < lastTimeItem.length - 1)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Divider(),
                              )
                          ],
                        );
                      }),
                )
            ],
          ),
        ));
  }
}

class LasttimeTile extends StatelessWidget {
  LasttimeTile({@required this.lasttime});
  final LastTime? lasttime;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 10,
            child: Container(
              child: Icon(Icons.access_alarm),
            ),
          ),
          Flexible(
            flex: 20,
            child: SizedBox(
              width: 10,
            ),
          ),
          Flexible(
              flex: 15,
              child: Text(lasttime?.targetTime!.day.toString() ?? ' ')),
        ],
      ),
    );
  }
}
