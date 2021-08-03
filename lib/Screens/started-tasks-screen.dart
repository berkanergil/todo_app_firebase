import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_firebase/CustomWidgets/custom-app-bar.dart';

class StartedTasksScreen extends StatefulWidget {
  const StartedTasksScreen({Key? key}) : super(key: key);

  @override
  _StartedTasksScreenState createState() => _StartedTasksScreenState();
}

class _StartedTasksScreenState extends State<StartedTasksScreen> {
  Stream<QuerySnapshot> _objectStream = FirebaseFirestore.instance
      .collection('todos')
      .orderBy("updated_at", descending: true)
      .snapshots();
  CollectionReference object = FirebaseFirestore.instance.collection("todos");

  final titleController = new TextEditingController();
  final subTitleController = new TextEditingController();
  final titleEditController = new TextEditingController();
  final subTitleEditController = new TextEditingController();

  DateTime now = new DateTime.now();

  String formatTimeStamp(Timestamp dateTime) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(dateTime.toDate());
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todo"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 16,
                        decoration: InputDecoration(labelText: "Title"),
                      ),
                      TextField(
                        controller: subTitleController,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(labelText: "SubTitle"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            object.add({
                              "title": titleController.text,
                              "subtitle": subTitleController.text,
                              "created_at": now,
                              "updated_at": now,
                            });
                          });
                          titleController.clear();
                          subTitleController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _objectStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot object) {
              return Dismissible(
                  key: Key(object["title"]),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                title: Text("Edit Todo"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: titleEditController
                                        ..text = (object["title"]),
                                      minLines: 1,
                                      maxLines: 1,
                                      maxLength: 20,
                                      decoration:
                                          InputDecoration(labelText: "Title"),
                                    ),
                                    TextField(
                                      controller: subTitleEditController
                                        ..text = (object["subtitle"]),
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          labelText: "SubTitle"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          object.reference.update({
                                            "title": titleEditController.text,
                                            "subtitle":
                                                subTitleEditController.text,
                                            "updated_at": now
                                          });
                                        });
                                        titleEditController.clear();
                                        subTitleEditController.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Update"))
                                ],
                              );
                            });
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(object["title"]),
                            Text(
                              formatTimeStamp(object["updated_at"]),
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        subtitle: Text(object["subtitle"]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              object.reference.delete();
                            });
                          },
                        ),
                      ),
                    ),
                  ));
            }).toList(),
          );
        },
      ),
    );
  }
}
