import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:csv/csv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List',
      home: LoaderPage(),
    );
  }
}

class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  Future<List<List<dynamic>>>_loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/BengaliDictionary_36.csv");
    return CsvToListConverter().convert(_rawData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
        future: _loadCSV(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return HomePage(
                list:
                snapshot.data ?? []);
          }
        });
  }
}

class HomePage extends StatefulWidget {
  final List<dynamic> list;

  const HomePage({Key key, this.list}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController();
  List<dynamic> _queriedData = [];

  @override
  void initState() {
    super.initState();
    _queriedData = List.from(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Center(child: Text('My Dictionary')),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _queriedData = widget.list
                        .where((element) => element.contains(value))
                        .toList();

                  });
                },
                controller: _textController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search here",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _queriedData.length,
                itemBuilder: (_, index) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Text(_queriedData[index][0].toString()),
                      title: Text(_queriedData[index][1]),
                      trailing: Text(_queriedData[index][2].toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}