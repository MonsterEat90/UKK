import 'package:flutter/material.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/view/authentication/signUp/signup.dart';

class RegisterNow extends StatelessWidget {
  const RegisterNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don't have an account?",
          style: TextStyle(color: kZambeziColor),
        ),
        GestureDetector(
          child: const Text(
            " Register Now",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
          },
        ),
      ],
    );
  }
}
