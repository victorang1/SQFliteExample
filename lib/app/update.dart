import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_example/model/book.dart';
import 'package:flutter_crud_example/repository/database_helper.dart';

class UpdatePage extends StatefulWidget {

  final int id;

  UpdatePage(this.id);

  @override
  State<StatefulWidget> createState() {
    return _UpdatePageState();
  }
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Page'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: _updatePageBody(context, widget.id),
      ),
    );
  }
}

Widget _updatePageBody(BuildContext context, int id) {
  final _titleController = TextEditingController();
  DatabaseManager db = new DatabaseManager();

  return Container(
    margin: EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input new title here',
              contentPadding: const EdgeInsets.all(8.0)),
        ),
        FlatButton(
          child: Text(
            'Update title',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.lightBlue,
          onPressed: () {
            _titleController.text = _titleController.text.trim();
            if (_titleController.text != '') {
              db.updateBook(Book.fromMap({
                'id' : id,
                'title' : _titleController.text,
              })).then((_) {
                Navigator.pop(context, 'update');
              });
            }
          },
        )
      ],
    ),
  );
}
