import 'package:flutter/material.dart';
import 'package:ukk/view/authentication/reset_password/reset_password.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPassword(),
            ),
          ),
        },
        child: const Text(
          'Forgot Password ?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
