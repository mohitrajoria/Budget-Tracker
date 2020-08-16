import 'package:balance_sheet/Home/additem.dart';
import 'package:balance_sheet/Home/item.dart';
import 'package:balance_sheet/Home/profile.dart';
import 'package:balance_sheet/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:balance_sheet/classes/itemclass.dart';

final balance = 206;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//final ItemClass one = ItemClass('Paid to Himanshu', '19/8/2019', '-', 434);
//final ItemClass two = ItemClass('Paid to Mohit', '19/3/2019', '+', 44);
final User dummy = User('Mohit Rajoria', '13-10-2000','https://scontent.fjai2-2.fna.fbcdn.net/v/t1.0-9/95362727_2741172542678274_312620172575768576_o.jpg?_nc_cat=101&_nc_sid=09cbfe&_nc_ohc=vbhflBRs8KgAX9GREOo&_nc_ht=scontent.fjai2-2.fna&oh=4041b60cd26a103cf3d82854fb469b08&oe=5F4AC925', 34);

class _HomeState extends State<Home> {
  Future getEntries()
  async{
    final firestoreInstance = Firestore.instance;
    QuerySnapshot q = await firestoreInstance.collection("entries").getDocuments();
    return q.documents;
  }

  List<ItemClass> temporary = [];
  callback(newList) {
    setState(() {
      temporary = newList;
    });
  }
  @override
  Widget build(BuildContext ct) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Balance Meter'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(dummy)),
              );
            }),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
//              height: double.maxFinite,
              child: Center(
                child: Text(
                  '₹ ' + dummy.bal.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                ),
              ))
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
              height: 100.0,
              width: double.maxFinite,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: ct,
                      builder: (ct) {
                        return AddItem(temporary, callback);
                      });
                },
                child: Card(
                  color: Colors.orange,
                  elevation: 25.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '+ Add Expense',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getEntries(),
                  builder: (ct,snapshot){if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: Text('Loading...'),
                    );
                  } else
                    {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (ct, index) {
                            return Dismissible(
                              key: UniqueKey(),
//                      direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                setState(() {
                                  temporary.removeAt(index);
                                });
                              },
                              child: Item(snapshot.data[index].data["sign"], snapshot.data[index].data["amount"],
                                  snapshot.data[index].data["note"], snapshot.data[index].data["date"]),
                            );
                          });
                    }
                  })
            ),
          ],
        ),
      ),
    );
  }
}
