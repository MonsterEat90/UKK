import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk/constants/color_constant.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kSecondaryColor,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
          child: Center(
            child: MaterialButton(
              child: Text(
                "Reset",
                textAlign: TextAlign.center,
                style: GoogleFonts.dongle(
                  fontSize: 28,
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
