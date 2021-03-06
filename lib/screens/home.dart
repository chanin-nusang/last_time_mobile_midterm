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
  var box = Hive.box<LastTime>('lasttime');
  var historyBox = Hive.box<LastTime>('history');
  LastTime lastTimeInit =
      LastTime('ปลูกผัก', 'Chores', DateTime.now(), DateTime.now());

  List<LastTime> lastTimeBox = [];
  List<LastTime> lastTimeItem = [];
  List<LastTime> lastTimeHistory = [];
  List<String> category = ['All', 'Chores', 'Learning', 'Body Care', 'People'];
  String dropdownValue = 'All';
  String dropdownValueToAdd = 'Chores';
  String titleToAdd = '';
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    pullLastTime();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pullLastTime() {
    print('Box lenght : ${box.length}');
    try {
      lastTimeBox = box.values.toList();
      print('lastTimeBox lenght : ${lastTimeBox.length}');
      if (dropdownValue == 'All')
        setState(() {
          lastTimeItem = lastTimeBox;
        });
      else {
        setState(() {
          lastTimeItem = lastTimeBox
              .where((element) => element.category == dropdownValue)
              .toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future lasttimeToAdd() async {
    LastTime lasttimeToAdd = LastTime(
        titleToAdd, dropdownValueToAdd, DateTime.now(), DateTime.now());
    await box.clear();
    lastTimeBox.insert(0, lasttimeToAdd);
    lastTimeBox.asMap().forEach((index, value) {
      box.put(index, value);
    });
    setState(() {
      pullLastTime();
    });
  }

  Future completedItem(LastTime item) async {
    lastTimeHistory = historyBox.values.toList();
    print(
        'lastTimeHistory lenght in completedItem : ${lastTimeHistory.length}');
    await historyBox.clear();
    LastTime reTime =
        LastTime(item.title, item.category, item.targetTime, DateTime.now());
    lastTimeHistory.insert(0, reTime);
    lastTimeHistory.asMap().forEach((index, value) {
      historyBox.put(index, value);
    });
    deleteItem(item);
  }

  Future deleteItem(LastTime item) async {
    lastTimeBox = box.values.toList();
    print('lastTimeBox lenght in delete : ${lastTimeBox.length}');
    int index = lastTimeBox
        .indexWhere((element) => element.targetTime == item.targetTime);
    lastTimeBox.removeAt(index);
    print('lastTimeBox lenght in delete after remove : ${lastTimeBox.length}');
    // await box.delete(index);
    await box.clear();
    if (lastTimeBox.isNotEmpty) {
      lastTimeBox.asMap().forEach((index, value) {
        box.put(index, value);
      });
    }
    setState(() {
      pullLastTime();
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
                        Icon(
                          Icons.filter_list,
                          color: Colors.grey[600],
                        ),
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
                              print('dropdownValue: $dropdownValue');
                              pullLastTime();
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
                      onPressed: () {
                        setState(() {
                          titleToAdd = '';
                          dropdownValueToAdd = 'Chores';
                          _controller.clear();
                        });

                        showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text(
                                    'Add a Task',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  content: Wrap(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Title : '),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                child: TextField(
                                                  cursorColor: Theme.of(context)
                                                      .primaryColor,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black),
                                                  controller: _controller,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                  ),
                                                  onChanged: (text) {
                                                    setState(() {
                                                      titleToAdd = text;
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              Text("Catagory : "),
                                              DropdownButton<String>(
                                                value: dropdownValueToAdd,
                                                icon: const Icon(
                                                    Icons.arrow_downward),
                                                iconSize: 24,
                                                elevation: 16,
                                                underline: Container(
                                                  height: 2,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValueToAdd =
                                                        newValue!;
                                                    print(
                                                        'Selected category : $dropdownValueToAdd');
                                                  });
                                                },
                                                items: <String>[
                                                  'Chores',
                                                  'Learning',
                                                  'Body Care',
                                                  'People'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
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
                                        Navigator.of(dialogContext)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('Add'),
                                      onPressed: () {
                                        try {
                                          lasttimeToAdd();
                                          Navigator.of(dialogContext).pop();
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                            });
                      },
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
                Expanded(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: ReorderableListView(
                        children: <Widget>[
                          for (int index = 0;
                              index < lastTimeItem.length;
                              index++)
                            LasttimeTile(
                                key: Key('$index'),
                                lasttime: lastTimeItem[index],
                                pressAction: (bool, lasttime) {
                                  if (bool) {
                                    setState(() {
                                      deleteItem(lasttime!);
                                    });
                                  } else {
                                    setState(() {
                                      completedItem(lasttime!);
                                    });
                                  }
                                }),
                        ],
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            if (dropdownValue == 'All') {
                              final LastTime item =
                                  lastTimeItem.removeAt(oldIndex);
                              lastTimeItem.insert(newIndex, item);
                              box.clear();
                              lastTimeItem.asMap().forEach((index, value) {
                                box.put(index, value);
                              });
                              print(
                                  'Box lenght in ReorderableListView : ${box.length}');
                              print(
                                  'lastTimeBox lenght in ReorderableListView: ${lastTimeBox.length}');
                              pullLastTime();
                            }
                          });
                        },
                      )),
                )
            ],
          ),
        ));
  }
}

class LasttimeTile extends StatelessWidget {
  LasttimeTile({Key? key, @required this.lasttime, @required this.pressAction})
      : super(key: key);
  final LastTime? lasttime;
  final Function(bool, LastTime?)? pressAction;
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
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
                              ],
                            )
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              pressAction!(true, lasttime);
                            },
                          ),
                          ElevatedButton(
                            child: Text('Completed'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              pressAction!(false, lasttime);
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
                    '${lasttime?.targetTime!.day.toString() ?? ' '}/${lasttime?.targetTime!.month.toString() ?? ' '}',
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
