import 'package:flutter/material.dart';
import 'package:flutter_crud_example/model/book.dart';
import 'package:flutter_crud_example/repository/database_helper.dart';

class InsertPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InsertPageState();
  }
}

class _InsertPageState extends State<InsertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insertion Page'),
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: _insertPageBody(context)),
    );
  }
}

Widget _insertPageBody(BuildContext context) {
  final titleController = TextEditingController();
  DatabaseManager db = new DatabaseManager();

  return Container(
    margin: EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        TextField(
          controller: titleController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input title here',
              contentPadding: const EdgeInsets.all(8.0)),
        ),
        FlatButton(
          child: Text(
            'Insert data',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.lightBlue,
          onPressed: () {
            titleController.text = titleController.text.trim();
            if (titleController.text != '') {
              db.saveTitle(Book(titleController.text)).then((_) {
                Navigator.pop(context, 'insert');
              });
            }
          },
        )
      ],
    ),
  );
}
