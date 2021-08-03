import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({Key? key}) : super(key: key);

  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  Stream<QuerySnapshot> _objectStream = FirebaseFirestore.instance
      .collection('discussions')
      .orderBy("updated_at", descending: true)
      .snapshots();
  CollectionReference object = FirebaseFirestore.instance.collection("discussions");

  final titleController = new TextEditingController();
  final subTitleController = new TextEditingController();
  late DateTime meetingAt= new DateTime.now();
  final titleEditController = new TextEditingController();
  final subTitleEditController = new TextEditingController();
  late DateTime meetingAtEdit= new DateTime.now();

  DateTime now = new DateTime.now();

  String formatTimeStamp(Timestamp timestamp) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(timestamp.toDate());
    return formatted;
  }
  String formatDateTime(DateTime dateTime) {
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context,setState){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: Text("Add Discussion"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Select Time:",
                              style: TextStyle(
                                  color: Colors.white70
                              ),),
                            TextButton(
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: now,
                                      onConfirm: (date) {
                                        setState(() {
                                          meetingAt=date;
                                          print(meetingAt);
                                        });
                                      },
                                      currentTime: now,
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  formatDateTime(meetingAt),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor
                                  ),
                                ))
                          ],
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
                                "meeting_at": meetingAt,
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
                },

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
                              return StatefulBuilder(builder: (context,setState){
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Select Time:",
                                            style: TextStyle(
                                                color: Colors.white70
                                            ),),
                                          TextButton(
                                              onPressed: () {
                                                DatePicker.showDateTimePicker(context,
                                                    showTitleActions: true,
                                                    minTime: now,
                                                    onConfirm: (date) {
                                                      setState(() {
                                                        meetingAtEdit=date;
                                                        print(meetingAtEdit);
                                                      });
                                                    },
                                                    currentTime: now,
                                                    locale: LocaleType.en);
                                              },
                                              child: Text(
                                                formatDateTime(meetingAtEdit),
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor
                                                ),
                                              ))
                                        ],
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
                                              "updated_at": now,
                                              "meeting_at": meetingAtEdit
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
