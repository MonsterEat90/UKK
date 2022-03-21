import 'package:flutter/material.dart';
import 'package:ukk/constants/color_constant.dart';

class EmailField extends StatelessWidget {
  final TextEditingController inputController;
  const EmailField({Key? key, required this.inputController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            autofocus: false,
            textInputAction: TextInputAction.next,
            controller: inputController,
            onChanged: (value) {
              //Do something wi
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: kWhiteColor,
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: kDarkModerateCyan, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kVeryDarkCyan, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kRedColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kDarkModerateCyan, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please Enter Your Email!';
            //   } else if (!value.contains('@')) {
            //     return 'Please Enter Valid Email!';
            //   }
            //   return null;
            // },
          ),
        ),
      ],
    );
  }
}
