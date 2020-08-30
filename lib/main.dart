import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterdbDemo/Model/quote.dart';
import 'package:flutterdbDemo/dbHelper/dbHelper.dart';
import 'package:flutterdbDemo/screen/quotePage.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int _randomnumber = random.nextInt(20);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Insert

            RaisedButton(
              onPressed: () async {
                int id = await DatabaseHelper.instance.insert(
                  Quote(
                    author: "Author $_randomnumber",
                    quote:
                        "This is demo quotes with isFav false $_randomnumber",
                    isFav: false,
                  ),
                );

                print('Inserted data is : $id');
              },
              child: Text('Insert'),
              color: Colors.green,
            ),

            // Read
            RaisedButton(
              onPressed: () async {
                List<Quote> quoteList =
                    await DatabaseHelper.instance.queryAll();
                print(
                    "Stored data is ${quoteList[quoteList.length - 1].quote}");
                print(
                    "Stored data bool ${quoteList[quoteList.length - 1].isFav}");
                print("Stored data length ${quoteList.length}");
              },
              child: Text('Read'),
              color: Colors.greenAccent,
            ),

            // Update

            RaisedButton(
              onPressed: () async {
                int updatedId = await DatabaseHelper.instance.update(
                  Quote(
                      id: 1,
                      author: "Messi",
                      quote: "Messi is leaving",
                      isFav: true),
                );
                print('updatedId : $updatedId');
              },
              child: Text('Update'),
              color: Colors.blue,
            ),

            // Delete
            RaisedButton(
              onPressed: () async {
                int rowsEffected = await DatabaseHelper.instance.delete(2);
                print("Deleted id $rowsEffected");
              },
              child: Text('Delete'),
              color: Colors.red,
            ),
            SizedBox(
              height: 10.0,
            ),
            //query
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Text('Quote Page'),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
