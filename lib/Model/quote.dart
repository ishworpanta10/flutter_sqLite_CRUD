class Quote {
  // commnly used variables
  static final tableName = 'myfavTable';

  // for table column
  static final columnId = '_id';
  static final columnQuote = 'quote';
  static final columnAuthor = 'author';
  static final columnisFav = 'isFav';

  int id;
  String quote;
  String author;
  bool isFav ;

  Quote({this.id, this.quote, this.author, this.isFav});

  Quote.fromMap(Map<String, dynamic> map) {
    // id is class variable and inside map is columnName of db table
    id = map[columnId];
    quote = map[columnQuote];
    author = map[columnAuthor];
    isFav = map[columnisFav] == 1;
  }

  // store
  Map<String, dynamic> toMap() {
    // key:columnQuote is table ColumnName of db and value:quote is class variable
    var map = <String, dynamic>{
      columnQuote: quote,
      columnAuthor: author,
      columnisFav: isFav == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
