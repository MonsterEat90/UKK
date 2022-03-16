// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/view/user_page/add_new_collection.dart';
import 'package:ukk/view/user_page/auction/auction_page.dart';
import 'package:ukk/view/user_page/collection/collection_page.dart';
import 'package:ukk/view/user_page/profile/profile_page.dart';

class PageNavBar extends StatefulWidget {
  const PageNavBar({Key? key}) : super(key: key);

  @override
  State<PageNavBar> createState() => _PageNavBarState();
}

class _PageNavBarState extends State<PageNavBar> {
  int currentIndex = 0;

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  List<Widget> initialWidgets = <Widget>[
    AuctionPage(),
    CollectionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewCollection(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: kRedColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
        children: List<Widget>.generate(
          initialWidgets.length,
          (int index) {
            return IgnorePointer(
              ignoring: index != currentIndex,
              child: Opacity(
                opacity: currentIndex == index ? 1.0 : 0.0,
                child: Navigator(
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (_) => initialWidgets[index],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: 0.2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        elevation: 8,
        tilesPadding: const EdgeInsets.symmetric(vertical: 8.0),
        items: const <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: kDarkBlue,
            icon: Icon(
              Icons.dashboard_outlined,
              color: kVeryDarkCyan,
            ),
            activeIcon: Icon(
              Icons.dashboard_rounded,
              color: kModerateCyan,
            ),
            title: Text('Auction'),
          ),
          BubbleBottomBarItem(
            backgroundColor: kDarkBlue,
            icon: Icon(
              Icons.collections_outlined,
              color: kVeryDarkCyan,
            ),
            activeIcon: Icon(
              Icons.collections,
              color: kLightRedColor,
            ),
            title: Text('Collection'),
          ),
          BubbleBottomBarItem(
            backgroundColor: kDarkBlue,
            icon: Icon(
              Icons.person_outline,
              color: kVeryDarkCyan,
            ),
            activeIcon: Icon(
              Icons.person,
              color: kLightOrange,
            ),
            title: Text('Profile'),
          )
        ],
      ),
    );
  }
}
