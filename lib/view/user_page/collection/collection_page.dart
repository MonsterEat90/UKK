// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ukk/constants/color_constant.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightRedColor,
        title: Text('My Collection'),
      ),
    );
  }
}
