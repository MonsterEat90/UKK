// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ukk/constants/color_constant.dart';

class CardCollection extends StatelessWidget {
  const CardCollection({Key? key}) : super(key: key);

  final double _borderRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('card pressed');
      },
      child: Container(
        height: 150,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          gradient: LinearGradient(
            colors: const [kLightRedColor, kLightOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: kDarkGreyColor,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.transparent),
                      shape: BoxShape.rectangle,
                    ),
                    child: Image.asset(
                      'assets/images/bag_1.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('title pressed');
                    },
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        'Put Your Title Here',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      print('Delete Button Pressed');
                      //write onpressed function here
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      size: 30,
                      color: kWhiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Edit Button Pressed');
                      //write onpressed function here
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 30,
                      color: kWhiteColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
