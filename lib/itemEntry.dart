import 'package:flutter/material.dart';
import 'database_structure_and_class_declaration.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
class ItemEntry extends StatefulWidget {
  @override
  _ItemEntryState createState() => _ItemEntryState();
}

class _ItemEntryState extends State<ItemEntry> {
  List<Items> itemList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  static String _value = "No date selected";
  TextEditingController datecontroller;
  void initState() {
    super.initState();
    datecontroller = TextEditingController(text: _value);
  }

  static Map<String, String> data = Map();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _selectDate() async {}
  Function(String) nonNullChecker = (String username) {
    if (username.isEmpty) {
      return 'Field is empty';
    } else if (username.length < 3) {
      return 'Field is too short';
    }

    return null;
  };

  Widget customTextForm(
      variable, String desc, String Function(String) validator) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.grey,
        focusColor: Colors.grey,
        labelText: desc,
      ),
      validator: validator,
      onSaved: (String value) {
        data[variable] = value;
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget datepicker_module(variable, String desc, String Function(String) validator) {
    return InkWell(
      onTap: () async {
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime(2016),
            lastDate: new DateTime(2030));
        if (picked != null) {
          setState(() {
            var dateNew=(new DateFormat("yyyy-MM-dd").format(picked));
            var date = DateTime.parse(picked.toString());
            _value ="${date.day}-${date.month}-${date.year}";
            datecontroller = TextEditingController(text: dateNew);
            data[variable] = _value;
          });
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: datecontroller,
          decoration: InputDecoration(
            fillColor: Colors.grey,
            focusColor: Colors.grey,
            labelText: desc,
          ),
//          onTap:()
//          {
//            _selectDate();
//          },
          validator: validator,
          onSaved: (String value) {
            data[variable] = value;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Items>();
      updateListView();
    }
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  customTextForm("name", "Enter the item name", nonNullChecker),
                  customTextForm(
                      "item_desc", "Enter the item description", nonNullChecker),
                  datepicker_module("date", "Enter the date", nonNullChecker),
                  SizedBox(height: 100),
                  RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();
                      //main thing i'm trying to show here is that the variable is accessed and it can stored also as per requirement
                      print(data["name"]);
                      print(data["item_desc"]);
                      print(data["date"]);
                      if(data["name"]!=null&&data["item_desc"]!=null&&data["date"]!=null)
                        {
                          print("hello__________________________________>\n");
                          Items x=Items(null,data["name"],data["item_desc"],data["date"]);
                          x.display();
                          _insert(x);
                        }
                      //if(date["name"])
                      //as all the data is stored in a static map the data is flushed using the clear function
                      data.clear();

                      //Send to API
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _insert(Items item) async{
    print("Stage 1");
    int result = await databaseHelper.insertItem((item));
    print("Stage 2__________________________________________________><><>");
    if(result!=0)
    {
      print("Stage 3");
      print(databaseHelper.getCount());
      print("reached here tooo!");
      showAlertDialog(context);
      updateListView();
    }

  }

  // ignore: non_constant_identifier_names
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text("The item has been pushed into list successfully."),
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
  updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Items>> itemsListFuture = databaseHelper.getItemsList();
      itemsListFuture.then((itemList) {
        if (!mounted) return;
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
