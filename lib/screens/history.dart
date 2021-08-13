import 'package:flutter/material.dart';
import 'package:last_time_mobile_midterm/models/lasttime.dart';
import 'package:hive_flutter/hive_flutter.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var historyBox = Hive.box<LastTime>('history');

  List<LastTime> lastTimeHistory = [];
  List<String> category = ['All', 'Chores', 'Learning', 'Body Care', 'People'];
  String dropdownValue = 'All';
  String dropdownValueToAdd = 'Chores';
  String titleToAdd = '';
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    //box.put(0, lastTimeInit);
    pullHistory();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pullHistory() {
    print('historyBox lenght : ${historyBox.length}');
    try {
      lastTimeHistory = historyBox.values.toList();
      print('lastTimeHistory lenght : ${lastTimeHistory.length}');
    } catch (e) {
      print(e);
    }
  }

  Future deleteItem(LastTime item) async {
    lastTimeHistory = historyBox.values.toList();
    print('lastTimeBox lenght in delete : ${lastTimeHistory.length}');
    int index = lastTimeHistory
        .indexWhere((element) => element.targetTime == item.targetTime);
    lastTimeHistory.removeAt(index);
    print(
        'lastTimeBox lenght in delete after remove : ${lastTimeHistory.length}');
    // await box.delete(index);
    await historyBox.clear();
    if (lastTimeHistory.isNotEmpty) {
      lastTimeHistory.asMap().forEach((index, value) {
        historyBox.put(index, value);
      });
    }
    setState(() {
      pullHistory();
    });
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
          // centerTitle: true
        ),
        body: Container(
          child: Column(
            children: [
              if (lastTimeHistory.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Center(child: Text('No History List.')),
                )
              else
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: lastTimeHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          LastTime _lastTime = lastTimeHistory[index];
                          return Wrap(
                            children: [
                              LasttimeTile(
                                  lasttime: _lastTime,
                                  pressAction: (lasttime) {
                                    setState(() {
                                      deleteItem(lasttime!);
                                    });
                                  }),
                              if (index < lastTimeHistory.length - 1)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Divider(),
                                )
                            ],
                          );
                        }),
                  ),
                )
            ],
          ),
        ));
  }
}

class LasttimeTile extends StatelessWidget {
  LasttimeTile({@required this.lasttime, @required this.pressAction});
  final LastTime? lasttime;
  final Function(LastTime?)? pressAction;
  static Map<String, Icon> categoryIcons = {
    'Chores': Icon(
      Icons.home_outlined,
      size: 30,
    ),
    'Learning': Icon(
      Icons.book_outlined,
      size: 30,
    ),
    'Body Care': Icon(
      Icons.face_outlined,
      size: 30,
    ),
    'People': Icon(
      Icons.person_outline,
      size: 30,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      content: Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Title : ${lasttime?.title ?? ' '}'),
                              Divider(),
                              Text('Category : ${lasttime?.category ?? ' '}'),
                              Divider(),
                              Text(
                                  'Created on : ${lasttime?.targetTime!.day}/${lasttime?.targetTime!.month}/${lasttime?.targetTime!.year}'),
                              Divider(),
                              Text(
                                  'Success on : ${lasttime?.successTime!.day}/${lasttime?.successTime!.month}/${lasttime?.successTime!.year}'),
                            ],
                          )
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            pressAction!(lasttime);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Container(
                    child: categoryIcons[lasttime?.category ??
                        Icon(
                          Icons.home,
                          size: 30,
                        )]),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                          lasttime?.title ?? ' ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )),
                Text(
                  '${lasttime?.successTime!.day.toString() ?? ' '}/${lasttime?.successTime!.month.toString() ?? ' '}',
                  style: TextStyle(fontSize: 20),
                ),
              ]),
            ),
          )),
    );
  }
}
