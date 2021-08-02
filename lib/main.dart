import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
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
  List todos = new List.generate(5, (int index) => "$index. item");
  String input = "";

  @override
  Widget build(BuildContext context) {
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
                  content: TextField(
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            todos.add(input);
                          });
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
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: ListTile(
                    title: Text(todos[index]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: (){
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                    ),
                  ),
                ));
          },
          itemCount: todos.length,
        ),
      ),
    );
  }
}
