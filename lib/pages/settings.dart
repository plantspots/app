import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/home.dart';
import 'package:plantspots/pages/edit_request.dart';
import 'package:plantspots/pages/login.dart';
import 'package:plantspots/pages/view_request.dart';
import 'package:plantspots/utils/colors.dart';
import 'package:plantspots/utils/vars.dart';
import 'package:plantspots/widgets/navbar.dart';

class SettingsPage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const SettingsPage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  // List<dynamic> tier = [];
  late Map<String, dynamic> tier;

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;

      firstTime = false;
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "User Details",
                style: TextStyle(fontSize: 36, color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [Text("Username: ",
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),), Text(username,
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w400),),],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [Text("Email: ",
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),), Text(email,
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w400),),],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [Text("Phone: ",
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),), Text(phone,
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w400),),],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: LoginPage(),
                            childCurrent: context.currentRoute), (route) {
                      return false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    )
                  ),
                  child: Text("Log Out"),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarWidget(
        index: 0,
        hash: hash,
        username: username,
        email: email,
        phone: phone,
        tier: tier,
      ),
    );
  }
}
