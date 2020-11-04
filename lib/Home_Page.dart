import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  String HelpText = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,

        ),
      backgroundColor: Colors.blue,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 5.0, 100.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Text(
                    "Daily ",
                    style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ]
              ),
            ),
            Text(
              "        Planner",
              style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold
              ),
            ), Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 0.0),
              child: Text(
               'Swipe down to reload',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            TaskList(),
            FlatButton(
              onPressed: (){
                Navigator.pushNamed(context, '/planner').whenComplete(() =>TaskList());
              },
              child: Text(
                "Click to start planning for the day >",
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight:FontWeight.bold
                ),
              ),
            )],
        ),
      ),
      drawer:  Drawer(

        child: Container(
          color: Colors.blue,
          child: ListView(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                    onTap: (){HelpTextContent();},
                  ),
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Help"),
                    onTap: (){HelpTextContent();},
                  ),
                  color: Colors.white,
                ),
              ),
              Text(HelpText)

            ],
          ),
        )
      ),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: false,
    );

  }
  HelpTextContent(){
    setState(() {
      HelpText = "Thanks for using Help\n"

          ;

    });
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  SharedPreferences prefs;
  List eventList;
  bool checkBoxValue = false;
  List finalList = [];
  DateTime date1;
  DateTime date2;
  DateTime tasktime;

  initState() {
    initprefs();
    super.initState();
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
    var value = jsonDecode(prefs.getString('events'));

    setState(() {
      eventList = value;
    });
    finalList.clear();
    for (var index = 0; index < eventList.length; index++) {
      var year = eventList[index][1].toString().substring(0, 4);
      var month = eventList[index][1].toString().substring(5, 7);
      var day = eventList[index][1].toString().substring(9, 10);
      var temp = DateTime.now().toUtc();
      var d1 = DateTime.utc(temp.year, temp.month, temp.day);

      var d2 = DateTime.utc(int.parse(year), int.parse(month), int.parse(day));

      if (d2.compareTo(d1) == 0) {
        tasktime = DateTime.parse(eventList[index][1]);
        finalList.add(eventList[index]);
        //print(finalList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 9.0, 8.0, 8.0),
      child: Container(
        height: 400,
        child: RefreshIndicator(
          child: ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: CheckboxListTile(
                    title: Text(finalList[index][0]),
                    subtitle: Text(finalList[index][1]),
                    value: (jsonDecode(finalList[index][3])),
                    onChanged: (bool value) async {
                      setState(() {
                        finalList[index][3] = jsonEncode(value);
                      });
                    },
                  ),
                  color: Colors.white,
                );
              }
          ),
          onRefresh: () async {
            setState(() {
              initprefs();
            });
          },
        ),
      ),
    );
  }
}