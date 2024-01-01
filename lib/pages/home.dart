import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String userToDo = '';
  List todoList = [];

  // connect to db, async function
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized(); // 100% connect to db
    await Firebase.initializeApp(); // connect db

  }

  @override
  void initState() { // when run app
    super.initState();

    // coll db
    initFirebase();

    todoList.addAll(['Read book', 'Buy milk']);
  }

  void menuOpen () {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Menu'),
              ),
              body: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false
                        );
                      },
                      child: const Text('Go to Start')
                  ),
                ],
              ),
            );
          }
      )
    );
  }

  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('To do list'),
        centerTitle: true,
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: menuOpen,
              icon: const Icon(Icons.menu)
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return const Text(' Error, no data');
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible( // delete when swipe
                key: Key(snapshot.data!.docs[index].id),
                child: Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index].get('item')),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // remove local
                        // setState(() {
                        //   todoList.removeAt(index);
                        // });

                        // delete item from db
                        FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                      },
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  // if(direction == DismissDirection.endToStart) // in which direction it was swiped

                  // delete item from db
                  FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                },
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
      onPressed: () {
          showDialog( // modal window
              context: context, // this page
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add item'),
                  content: TextField(
                    onChanged: ( String value) {
                      userToDo = value; // less setState because needless dynamic view
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('items').add({'item': userToDo});
                          // close modal
                          Navigator.of(context).pop();
                        },
                        child: const Text('Add item')
                    ),
                  ],
                );
              }
          );
      },
        child: const Icon(Icons.add_circle, color: Colors.white,),
      ),
    );
  }
}
