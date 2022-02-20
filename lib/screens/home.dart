import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fanpage_app/main.dart';
import 'package:fanpage_app/screens/signin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                signOut(context);
              }),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                child: Center(
                  child: Text(document['message']),
                ),
              );
            }).toList(),
          );
        },
      ),
      // TODO: change to if user role = ADMIN,
      floatingActionButton: user != null
          ? FloatingActionButton(
              onPressed: () async {
                // addmind add post;

                final postMessage = await openDialog();
                print(postMessage);
                if (postMessage != null && postMessage.isNotEmpty) {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  CollectionReference posts = firestore.collection('posts');
                  posts.doc().set({
                    'message': postMessage,
                    "register_date": DateTime.now(),
                  });
                }
                print(user);
              },
              tooltip: 'Add post',
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void signOut(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text("Yes."),
              ),
            ],
          );
        });
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Add post"),
            content: TextField(
              autofocus: true,
              controller: textFieldController,
              decoration: const InputDecoration(
                labelText: "Post",
                hintText: "Add post",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: submitPost, child: const Text("Post message!")),
              IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));

  void submitPost() {
    Navigator.of(context).pop(textFieldController.text);
    textFieldController.clear();
  }
}
