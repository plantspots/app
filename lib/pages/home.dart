import 'package:flutter/material.dart';
import 'package:plantspots/api/home.dart';
import 'package:plantspots/utils/vars.dart';
import 'package:plantspots/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const HomePage(
      {super.key,
      required this.hash,
      required this.username,
      required this.email,
      required this.phone,
      required this.tier,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  // List<dynamic> tier = [];
  late Map<String, dynamic> tier;

  bool firstTime = true;

  // Future<Map<String, dynamic>> requests = Future(() { return {}; });
  late Future<List<dynamic>> requests;

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;

      firstTime = false;

      requests = homeAPI(hash);
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
                "Hello $username!",
                style: TextStyle(fontSize: 36, color: textColor),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: softBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 150,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text("a")),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: NavbarWidget(index: 0, hash: hash, username: username, email: email, phone: phone, tier: tier,),
    );
  }
}
