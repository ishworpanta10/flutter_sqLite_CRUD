import 'package:flutter/material.dart';
import 'package:flutterdbDemo/Model/quote.dart';
import 'package:flutterdbDemo/dbHelper/dbHelper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlQuote = TextEditingController();
  final _ctrlAuthor = TextEditingController();

  Quote _quote = Quote();
  List<Quote> _quotes = [];

  void _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      // _quotes.add(
      //   Quote(id: null, quote: _quote.quote, author: _quote.author),
      // );
      if (_quote.id == null) {
        await _dbHelper.insert(_quote);
      } else {
        await _dbHelper.update(_quote);
      }
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlAuthor.clear();
      _ctrlQuote.clear();
      _quote.id = null;
    });
  }

  _showForEdit(index) {
    setState(() {
      _quote = _quotes[index];
      _ctrlQuote.text = _quotes[index].quote;
      _ctrlAuthor.text = _quotes[index].author;
    });
  }

  _deleteQuote(int index) async {
    await _dbHelper.delete(index);
    _resetForm();
    _refreshQuotesList();
  }

  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshQuotesList();
  }

  _refreshQuotesList() async {
    List<Quote> quotes = await _dbHelper.queryAll();
    setState(() {
      _quotes = quotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Quotes Collection",
            style: TextStyle(color: Colors.lightBlue),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
            _list(),
          ],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ctrlQuote,
                decoration: InputDecoration(labelText: 'Quote Here'),
                validator: (val) =>
                    (val.length == 0 ? 'This field is mandatory' : null),
                onSaved: (val) => setState(
                  () => _quote.quote = val,
                ),
                // autovalidate: true,
              ),
              TextFormField(
                controller: _ctrlAuthor,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (val) =>
                    val.length == 0 ? 'author is required' : null,
                onSaved: (val) => setState(
                  () => _quote.author = val,
                ),
                // autovalidate: true,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Submit'),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  _list() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Scrollbar(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.blueGrey,
                        size: 40.0,
                      ),
                      title: Text(
                        _quotes[index].quote.toUpperCase(),
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_quotes[index].author),
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),
                          onPressed: () {
                            _deleteQuote(_quotes[index].id);
                          }),
                      onTap: () {
                        _showForEdit(index);
                      },
                    ),
                    Divider(
                      height: 5.0,
                    ),
                  ],
                );
              },
              itemCount: _quotes.length,
            ),
          ),
        ),
      );
}
