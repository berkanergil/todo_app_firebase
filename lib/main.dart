import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final titleController= new TextEditingController();
  final subTitleController= new TextEditingController();
  final titleEditController= new TextEditingController();
  final subTitleEditController= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _todosStream = FirebaseFirestore.instance.collection('todos').orderBy("created_at",descending: true).snapshots();
    CollectionReference todos= FirebaseFirestore.instance.collection("todos");
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        centerTitle: true,
      ),
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
                    children: [
                      TextField(
                        controller: titleController,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: "Title"
                        ),
                      ),
                      TextField(
                        controller: subTitleController,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: "SubTitle"
                        ),
                      ),
                    ],
                  ),

                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            todos.add({
                              "title":titleController.text,
                              "subtitle":subTitleController.text,
                              "created_at":FieldValue.serverTimestamp(),
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
        stream: _todosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot todo) {
              return Dismissible(
                  key: Key(todo["title"]),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                title: Text("Edit Todo"),
                                content: Column(
                                  children: [
                                    TextField(
                                      controller: titleEditController..text=(todo["title"]),
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          labelText: "Title"
                                      ),
                                    ),
                                    TextField(
                                      controller: subTitleEditController..text=(todo["subtitle"]),
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          labelText: "SubTitle"
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          todo.reference.update({
                                            "title":titleEditController.text,
                                            "subtitle":subTitleEditController.text,
                                            "created_at":FieldValue.serverTimestamp(),
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
                        title: Text(todo["title"]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: (){
                            setState(() {
                                todo.reference.delete();
                            });
                          },
                        ),
                      ),
                    ),
                  ));
            }).toList(),
          );
        },
      )
    );
  }
}
