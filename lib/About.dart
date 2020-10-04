import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(

          padding: const EdgeInsets.fromLTRB(20, 50, 10, 0),

          child:GradientText("This app was created to reduce food wastage. So how to use the app? Each time you get any food item, please enter the ingredients manually. So when they expire you would see them. Thus reducing wastage.",
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(19, 84,122,1), Color.fromRGBO(128, 208, 199, 1)]),
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
