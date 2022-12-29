import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

import './home_page.dart';
import './intro_page.dart';


class StartPage extends StatefulWidget {

  static const routeName = '/intro';

  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.popAndPushNamed(context, HomePage.routeName);
    } else {
      await prefs.setBool('seen', true);
      // Navigator.popAndPushNamed(context, IntroPage.routeName);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }
}