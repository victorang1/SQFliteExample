import 'package:flutter/material.dart';
import 'package:flutter_crud_example/app/insert.dart';
import 'package:flutter_crud_example/app/update.dart';
import 'package:flutter_crud_example/repository/database_helper.dart';

import 'model/book.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> list = new List();
  DatabaseManager db = new DatabaseManager();

  @override
  void initState() {
    super.initState();
    list.clear();
    db.getAllTitle().then((items) {
      setState(() {
        items.forEach((item) {
          list.add(item);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoList with SqfLite'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, i) => Divider(
                  color: Colors.black,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(list[i].getTitle),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(i);
                        },
                      ),
                      onLongPress: () {
                        _showUpdateDialog(context, i);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _createNewBook(context);
        },
      ),
    );
  }

  void _updateBook(BuildContext context, int id) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => UpdatePage(id)));
    if (result == 'update') {
      db.getAllTitle().then((items) {
        setState(() {
          list.clear();
          items.forEach((item) {
            list.add(item);
          });
        });
      });
    }
  }

  void _showUpdateDialog(BuildContext context, int position) {
    String title = list[position].getTitle;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Book'),
            content: Text('Are you sure you want to update $title?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  _updateBook(context, list[position].getId);
                },
              )
            ],
          );
        });
  }

  void _showDeleteDialog(int position) {
    String title = list[position].getTitle;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Remove Book'),
            content: Text('Are you sure you want to remove $title?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  db.deleteBook(list[position].getId).then((_) {
                    setState(() {
                      list.removeAt(position);
                      Navigator.pop(context);
                    });
                  });
                },
              )
            ],
          );
        });
  }

  _createNewBook(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertPage()),
    );
    if (result == 'insert') {
      db.getAllTitle().then((items) {
        setState(() {
          list.clear();
          items.forEach((item) {
            list.add(item);
          });
        });
      });
    }
  }
}
