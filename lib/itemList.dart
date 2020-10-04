import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_structure_and_class_declaration.dart';
import 'database_helper.dart';

class ListViewAll extends StatefulWidget {
  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ListViewAll> {
  List<Items> itemList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Items>();
      updateListView();
    }
    return GestureDetector(
      onTap: (){
        print(count);
        print(itemList[0].itemName);
        print(itemList[1].itemName);
        print(itemList[2].itemName);
        print(itemList[3].itemName);
        print(itemList[0].itemDescription);
        print(itemList[1].itemDescription);
        print(itemList[2].itemDescription);
        print(itemList[3].itemDescription);
        print(itemList[0].date);
        print(itemList[1].date);
        print(itemList[2].date);
        print(itemList[3].date);

      },
      child: Scaffold(
        body: getItemsListView(),
      ),
    );
  }

  ListView getItemsListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return GestureDetector(
          onTap: (){
            showAlertDialog(BuildContext context) {

              // set up the button
              Widget okButton = FlatButton(
                child: Text("OK"),
                onPressed: () { Navigator.pop(context);},
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text(itemList[position].itemName),
                content: Text(itemList[position].itemDescription),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          },
          child: Card(
            color:Colors.white,
            margin:EdgeInsets.fromLTRB(10, 10, 10,5) ,
            elevation: 2.0,
              child: ListTile(
                title: Text(this.itemList[position].itemName,style: titleStyle,),
                subtitle: Text(this.itemList[position].date),
                trailing: GestureDetector(
                  child: Icon(Icons.delete,color: Colors.green[900]),
                  onTap: (){
                    _delete(context,itemList[position]);
                  },
                ),
              ),
          ),
        );
      },
    );
  }

  void _delete(BuildContext context,Items item) async{
    int result = await databaseHelper.deleteItem((item.id));
    if(result!=0)
      {
        _showSnackBar(context,'Note Deleted Successfully');
        updateListView();

      }

  }
  void _showSnackBar(BuildContext context,String message)
  {
    final snackbar= SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackbar);
  }
  updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Items>> itemsListFuture = databaseHelper.getItemsList();
      itemsListFuture.then((itemList) {
        setState(() {

          this.itemList = itemList;
          this.count = itemList.length;

        });
        this.itemList.sort((a,b) {
          DateTime expiryAsDateTime1 = DateTime.parse(a.date);
          DateTime expiryAsDateTime2 = DateTime.parse(b.date);
          return expiryAsDateTime1.compareTo(expiryAsDateTime2);
        });
      });
    });
  }
}
