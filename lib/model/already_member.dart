import 'package:flutter/material.dart';
import 'package:ukk/constants/color_constant.dart';

class AlreadyMember extends StatelessWidget {
  const AlreadyMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Already a Member? ",
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          child: const Text(
            "Login Now",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
