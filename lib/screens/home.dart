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
  bool admin = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> ifUserAdmin() async {
    await users.doc(user?.uid).get().then((DocumentSnapshot document) {
      if (document.exists) {
        admin = (document['role'] == 'admin');
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    ifUserAdmin();
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
        stream: posts.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No posts yet"),
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
      floatingActionButton: admin == true
          ? FloatingActionButton(
              onPressed: () async {
                final postMessage = await openDialog();
                if (postMessage != null && postMessage.isNotEmpty) {
                  posts.doc().set({
                    'message': postMessage,
                    "register_date": DateTime.now(),
                  });
                }
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
