import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 104.0, 100.0, 0.0),
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
          ),
          TaskList(),
          FlatButton(
            onPressed: (){
              Navigator.pushNamed(context, '/planner').whenComplete(() =>TaskList());
            },
            child: Text(
              "Click to start planning the day >",
              style: TextStyle(
                fontSize: 19.0,
                fontWeight:FontWeight.bold
              ),
            ),
          )],
      )
    );
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

  initState() {
    initprefs();
    super.initState();
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var value = jsonDecode(prefs.getString('events'));
    setState(() {
      eventList = value;
    });
    for(var index = 0;index < eventList.length;index++){
      var year = eventList[index][1].toString().substring(0,4);
      var month = eventList[index][1].toString().substring(5,7);
      var day = eventList[index][1].toString().substring(9,10);
      var temp = DateTime.now().toUtc();
      var d1 = DateTime.utc(temp.year,temp.month,temp.day);

      var d2 = DateTime.utc(int.parse(year),int.parse(month),int.parse(day));

      if(d2.compareTo(d1) == 0){
        finalList.add(eventList[index]);
        //print(finalList);
      }else{
        //print('false');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 9.0, 8.0, 8.0),
      child: Container(
        height: 400,
        child: ListView.builder(
          itemCount: finalList.length,
          itemBuilder: (context,index) {
            return Card(
              child: CheckboxListTile(
                title: Text(finalList[index][0]),
                subtitle: Text(finalList[index][1]),
                value:(jsonDecode(finalList[index][3])),
                onChanged: (bool value)async{
                  setState((){
                    finalList[index][3] = jsonEncode(value);
                  });
                },
              ),
              color: Colors.white,
            );
          }
        ),
      ),
    );
  }
}