import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterdbDemo/Model/quote.dart';
import 'package:flutterdbDemo/dbHelper/dbHelper.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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
                  Quote(author: "Rambijaya", quote: "I am ram "),
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
                print("Stored data is ${quoteList[2].quote}");
                print("Stored data is ${quoteList.length}");
              },
              child: Text('Read'),
              color: Colors.greenAccent,
            ),

            // Update

            RaisedButton(
              onPressed: () async {
                int updatedId = await DatabaseHelper.instance.update(
                  Quote(id: 1, author: "Messi", quote: "Messi is leaving"),
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

            //query
            RaisedButton(
                onPressed: () async {},
                child: Text('Query'),
                color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
