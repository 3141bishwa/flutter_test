import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());


final dummySnapshot = [
  {"name" : "Bishwa", "votes" : 0} ,
  {"name" : "Ara", "votes" : 0} ,
  {"name" : "bea", "votes" : 0} ,
  {"name" : "Cow", "votes" : 0} ,
  {"name" : "Dog", "votes" : 0} ,
];


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
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
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Baby Name Vote")),
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      });
  }

  Widget _buildList(BuildContext context,List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((f) => _buildListElement(context, f)).toList()
    );
  }

  Widget _buildListElement(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
  
  return Padding(
    key: ValueKey(record.name),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0,)
      ),

      child: ListTile(
        title: Text(record.name),
        trailing: Text(record.votes.toString()),
        onTap: () =>  record.reference.updateData({'votes': record.votes + 1}),
      )
    ),
  );
  }
}

class Record {
    final String name;
    final int votes;
    final DocumentReference reference;


    Record.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['votes'] != null),
      assert(map['name'] != null),

      name = map['name'],
      votes = map['votes'];


    Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
    

   @override
    String toString() => "Record<$name:$votes>";
}
  
 