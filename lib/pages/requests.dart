import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/requests.dart';
import 'package:plantspots/pages/create_request.dart';
import 'package:plantspots/utils/vars.dart';
import 'package:plantspots/widgets/navbar.dart';

class RequestsPage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const RequestsPage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
  });

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  late Map<String, dynamic> tier;

  late Future<List<dynamic>> requests;

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;

      requests = getRequestsAPI(hash);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Requests",
                  style: TextStyle(fontSize: 36, color: textColor),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: CreateRequestPage(
                          hash: hash,
                          username: username,
                          email: email,
                          phone: phone,
                          tier: tier,
                        ),
                        childCurrent: context.currentRoute));
                  },
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 36,
                    color: textColor,
                  ),
                )
              ],
            ),
            Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: softBackgroundColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text("a"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: NavbarWidget(
        index: 1,
        hash: hash,
        username: username,
        email: email,
        phone: phone,
        tier: tier,
      ),
    );
  }
}
