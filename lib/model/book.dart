class Book {
  int _id;
  String _title;

  Book(this._title);

  Book.map(dynamic obj) {
    this._title = obj['title'];
  }

  int get getId => _id;

  set setId(int id) {
    _id = id;
  }

  String get getTitle => _title;

  set setTitle(String title) {
    _title = title;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['title'] = _title;
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
  }
}