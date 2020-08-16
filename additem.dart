import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:balance_sheet/classes/itemclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  final List<ItemClass> temp;
//  final BuildContext ct;
  Function(List<ItemClass>) callback;
  AddItem(this.temp, this.callback);
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
//  BuildContext ct;
//  List<ItemClass> temp;
  final firestoreInstance = Firestore.instance;
  String flow = "Spent";
  TextEditingController amount = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController note = TextEditingController();
  ItemClass st = ItemClass('Paid to me', '23/4/2018', '+', 100.00);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: Container(
        height: 250.0,
        margin: EdgeInsets.all(10.0),
//        color: Colors.white,
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: flow,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 25,
              elevation: 16,
              focusColor: Colors.red,
              onChanged: (String newValue) {
                setState(() {
                  flow = newValue;
                });
              },
              items: <String>['Earned', 'Spent']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Center(
              child: TextField(
                controller: note,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Add a note'),
              ),
            ),
            Center(
              child: TextField(
                controller: date,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter date'),
              ),
            ),
            Center(
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: amount,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Amount'),
              ),
            ),
            FlatButton(
              onPressed: () {

                setState(() {
                  st.note = note.text;
                  if(flow=='Spent')
                    {
                      st.sign='-';
                      print('-');
                    }
                  else
                    {
                      st.sign='+';
                    }
                  st.date = date.text;
                  st.amount = double.parse(amount.text);
                  widget.temp.add(st);
                  firestoreInstance.collection("entries").add(
                    st.tomap()
                  );
                  widget.callback(widget.temp);
                });
                print(st);
                print(widget.temp);
              },
              child: Text('Save'),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
