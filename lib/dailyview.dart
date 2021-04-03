import 'package:flutter/material.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'package:firebase_database/firebase_database.dart';


class DailyView extends StatefulWidget {
  String oName;
  String identifier;
  DailyView({Key key, this.title, @required this.oName, @required this.identifier}) : super(key: key);
  final String title;

  @override
  _DayState createState() => _DayState(oName, identifier);
}

class block {
  String index;
  String name;
  int duration;
  List<String> tags;
  String Color;
  int start;
  block (this.index, this.name, this.duration, this.tags, this.Color, this.start) {
  }
}

class _DayState extends State<DailyView> {

  final database = FirebaseDatabase.instance.reference();

  //String oName;
  String index;
  String user;
  //List<block> blocks;

  List<SpannableGridCellData> schedData = List();
  var occupied = new List(25);
  int where = 6;

  TextEditingController nameController;

  _DayState (String n, String k){
    //oName = n;
    index = k;
    user = 'admin';
    nameController = new TextEditingController(text: n);
    //blocks = List<block>(24);
    //for (int i = 0; i < 24; i++){
    //  blocks[i] = block("","",0,[],"",0);
    //}
    //blocks[0] = block(0,"test condition",2,["big"],"blue", 6);
    //blocks[1] = block(1,"the second",4,[],"red", 1);
    loadData(false);
  }

  final Future<String> _wait = Future<String>.delayed(
      Duration(milliseconds: 500),
          () => 'Data Loaded'
  );

  loadData (bool re) {
    for (int i = 0; i < 25; i++) {
      occupied[i] = false;
    }

    schedData.clear();

    database.once().then((DataSnapshot snapshot) {
      var map = snapshot.value as Map<dynamic, dynamic>;
      var nodes = map['users'][user]['schedules'][index]['nodes'];
      //print (nodes);
      //print (index);

      nodes.forEach((key, value) {
        print ('the node is: ' + value['name']);

        List<String> tags;

        block curr = block(value['id'],value['name'],value['duration'],[],value['colour'],value['start']);
        //value.forEa

        schedData.add(SpannableGridCellData(
          id: value['id'],
          column: 2,
          row: value['start'],
          rowSpan: value['duration'],
          child: Draggable<block>(
            data: curr,
            child: Container(
                color: Colors.blue,
                child: Text(curr.name)
            ),
            feedback: Container(
                color: Colors.blue,
                height: 100,
                width: 130,
                child: Text(curr.name)
            ),
          ),
        ));
        for (int b = curr.start; b < curr.start + curr.duration; b++){
          occupied[b] = true;
        }
      });

      for (int i = 1; i <= 24; i++) {
        schedData.add(SpannableGridCellData(
            id: "time " + i.toString(),
            column: 1,
            row: i,
            child: Container(
                child: Text((((i - 1) % 12) + 1).toString() + ":00")
            )
        ));
        if (!occupied[i]) {
          schedData.add(SpannableGridCellData(
              id: "dest" + i.toString(),
              column: 2,
              row: i,
              child: DragTarget<block>(
                builder: (BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected) {
                  return Container(

                  );
                },
                onAccept: (block data) async {
                  if (data.duration + i < 26) {
                    print("dragged");
                    //String curkey = curr
                    var currChi = database.child('users').child(user).child('schedules').child(index).child('nodes').child(data.index).child('start');
                    currChi.set(i);
                    //blocks[data.index].start = i;
                    loadData(true);
                    //sleep(Duration (seconds: 1));
                    //etState(() {

                    //});
                  }
                },
              )
          ));
        }
      }
      if (re) {
        setState(() {

        });
      }
    });

    //return schedData;
    //setState(() {

    //});
  }

  @override
  Widget build(BuildContext context) {


    //schedData.clear();
    //loadData(false);

    /*for (int i = 0; i < 24; i++) {
      if (blocks[i].name != "") {
        schedData.add(SpannableGridCellData(
          id: i,
          column: 2,
          row: blocks[i].start,
          rowSpan: blocks[i].duration,
          child: Draggable<block>(
            data: blocks[i],
            child: Container(
                color: Colors.blue,
                child: Text(blocks[i].name)
            ),
            feedback: Container(
                color: Colors.blue,
                height: 100,
                width: 130,
                child: Text(blocks[i].name)
            ),
          ),
        ));
        for (int b = blocks[i].start; b < blocks[i].start + blocks[i].duration; b++){
          occupied[b] = true;
        }
      }
    }*/

    //database.child('maybe').set("test");

    /*
    database.once().then((DataSnapshot snapshot) {
      var map = snapshot.value as Map<dynamic, dynamic>;
      var nodes = map['users'][user]['schedules'][index]['nodes'];
      //print (nodes);
      //print (index);

      nodes.forEach((key, value) {
        print ('the node is: ' + value['name']);

        List<String> tags;

        block curr = block(value['id'],value['name'],value['duration'],[],value['colour'],value['start']);
        //value.forEa

        schedData.add(SpannableGridCellData(
          id: value['id'],
          column: 2,
          row: value['start'],
          rowSpan: value['duration'],
          child: Draggable<block>(
            data: curr,
            child: Container(
                color: Colors.blue,
                child: Text(curr.name)
            ),
            feedback: Container(
                color: Colors.blue,
                height: 100,
                width: 130,
                child: Text(curr.name)
            ),
          ),
        ));
        for (int b = curr.start; b < curr.start + curr.duration; b++){
          occupied[b] = true;
        }
      });

      for (int i = 1; i <= 24; i++) {
        schedData.add(SpannableGridCellData(
            id: "time " + i.toString(),
            column: 1,
            row: i,
            child: Container(
                child: Text((((i - 1) % 12) + 1).toString() + ":00")
            )
        ));
        if (!occupied[i]) {
          schedData.add(SpannableGridCellData(
              id: "dest" + i.toString(),
              column: 2,
              row: i,
              child: DragTarget<block>(
                builder: (BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected) {
                  return Container(

                  );
                },
                onAccept: (block data) {
                  if (data.duration + i < 26) {
                    print("dragged");
                    //String curkey = curr
                    var currChi = database.child('users').child(user).child('schedules').child(index).child('nodes').child(data.index).child('start');
                    currChi.set(i);
                    //blocks[data.index].start = i;
                    setState(() {

                    });
                  }
                },
              )
            ));
          }
        }
      });
     */

    final nameField = TextField(
        controller: nameController,
        obscureText: false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Schedule name",

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        )
    );

    final backButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff01A0C7),
        child: MaterialButton(
            minWidth: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("<",
              textAlign: TextAlign.center,
            )
        )
    );

    return Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                  child: Column(
                    children: [
                      nameField,
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: Colors.black
                          )
                        ),
                          child: ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [FutureBuilder<String>(
                              future: _wait,
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return SpannableGrid(
                                        columns: 2,
                                        rows: 24,
                                        spacing: 2.0,
                                        rowHeight: 50,
                                        cells: schedData
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }
                            )]
                          )
                      ),
                      backButton
                    ],
                  )
              )
          )
        )
    );
  }
}