import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/pages/home.dart';
import 'package:plantspots/pages/requests.dart';

class NavbarWidget extends StatefulWidget {
  final int index;
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const NavbarWidget({super.key, required this.index,required this.hash,
      required this.username,
      required this.email,
      required this.phone,
      required this.tier,});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int index = 0;
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  late Map<String, dynamic> tier;

   bool firstTime = true;

  void changeDesination(int value) {
    if (value == index) { return; }

    setState(() {
      index = value;

      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade,
                  child: HomePage(
                    hash: hash,
                    username: username,
                    email: email,
                    phone: phone,
                    tier: tier,
                  ),
                  childCurrent: context.currentRoute), (route) {
            return false;
          });
        case 1:
          Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade,
                  child: RequestsPage(
                    hash: hash,
                    username: username,
                    email: email,
                    phone: phone,
                    tier: tier,
                  ),
                  childCurrent: context.currentRoute), (route) {
            return false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      index = widget.index;
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;

      firstTime = false;
    }

    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: changeDesination,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label: "Home"
        ),
        NavigationDestination(
          icon: Icon(Icons.local_florist_rounded),
          label: "Requests"
        ),
        NavigationDestination(
          icon: Icon(Icons.smart_toy_rounded),
          label: "Sterling AI"
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: "Settings"
        )
      ],
    );
  }
}