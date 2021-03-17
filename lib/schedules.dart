import 'package:flutter/material.dart';
import 'package:schedu_block/dailyview.dart';

class Schedules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Schedules')
        ),
        body: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('<')
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DailyView()),
                      );
                    },
                    child: Text('Edit')
                )
              ],
            )
        )
    );
  }
}