import 'package:fanpage_app/screens/authenticate/authenticate.dart';
import 'package:fanpage_app/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return either home or auth widget
    return Authenticate();
  }
}
