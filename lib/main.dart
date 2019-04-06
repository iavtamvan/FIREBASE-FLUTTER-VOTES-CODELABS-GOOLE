import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final dummySnapshot = [
  {"name": "Filip", "votes": 15},
  {"name": "Abraham", "votes": 14},
  {"name": "Richard", "votes": 11},
  {"name": "Ike", "votes": 10},
  {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names <Nama Apps>',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pemilihan Presiden')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    return MaterialApp(
//      home: Scaffold(
////        appBar: AppBar(title: Text('First app')),
//        body: Row(
//          children: <Widget>[
//            Image.asset(
//              'assets/bolah.jpg',
//              width: 10,
//              height: 10,
//            ),
////            ListView(
////              children: snapshot
////                  .map((data) => _buildListItem(context, data))
////                  .toList(),
////            )
//          ],
//        ),
//      ),
//    );
    return new ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
//          onTap: () => Firestore.instance.runTransaction((transaction) async {
//                final freshSnapshot = await transaction.get(record.reference);
//                final fresh = Record.fromSnapshot(freshSnapshot);
//
//                await transaction
//                    .update(record.reference, {'votes': fresh.votes + 1});
//              }),
//        ),
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new ListTile(
          onTap: () => Firestore.instance.runTransaction((transaction) async{
            final freshSnapshot = await transaction.get(record.reference);
            final fresh = Record.fromSnapshot(freshSnapshot);
            await transaction.update(record.reference, {'votes': fresh.votes + 1});
          }) ,
          leading: new CircleAvatar(
            backgroundColor: Colors.transparent,
//            child: new Image(image: new AssetImage('assets/bolah.jpg')),
            child: new Image.network(record.image, width: 800, height: 200),
          ),
          title: new Row(
            children: <Widget>[
              new Title(color: Colors.red, child: Expanded(child: new Text(record.name),)),
//              new Text(record.name),
//              new Expanded(child: new Text(record.name)),
              new Expanded(child: new Text(record.votes.toString())),

//              new Checkbox(value: product.isCheck, onChanged: (bool value) {
//                setState(() {
//                  product.isCheck = value;
//                });
//              })
            ],
          )
      )
    );


//      Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey),
//          borderRadius: BorderRadius.circular(5.0),
//        ),
//
//        child: ListTile(
//          Image : new Image(image: new AssetImage('assets/bolah.jpg')),
//          title: Text(record.name),
////          subtitle: Text(record.image),
//          trailing: Text(record.votes.toString()),
//          onTap: () => Firestore.instance.runTransaction((transaction) async {
//                final freshSnapshot = await transaction.get(record.reference);
//                final fresh = Record.fromSnapshot(freshSnapshot);
//
//                await transaction
//                    .update(record.reference, {'votes': fresh.votes + 1});
//              }),
//        ),
//      ),
  }
}

class Record {
  final String image;
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['image'] != null),
        assert(map['name'] != null),
        assert(map['votes'] != null),
        image = map['image'],
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$image:$name:$votes>";
}
