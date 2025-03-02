import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/home.dart';
import 'package:plantspots/pages/edit_request.dart';
import 'package:plantspots/pages/view_request.dart';
import 'package:plantspots/utils/colors.dart';
import 'package:plantspots/utils/vars.dart';
import 'package:plantspots/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const HomePage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
  });

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

  // Widget generateRequestsWidget(BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
  //   return FractionallySizedBox(
  //             widthFactor: 1,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: softBackgroundColor,
  //                 borderRadius: BorderRadius.all(Radius.circular(8)),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(15),
  //                     child: SizedBox(
  //                       height: 150,
  //                       child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.red,
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(8)),
  //                           ),
  //                           child: Text("a")),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  // }
  Widget generateRequestsWidget(
      BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
    if (snapshot.hasData) {
      return Column(
        children: () {
          List<Widget> res = [];
          for (dynamic request in snapshot.data!) {
            res.add(Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: mediumBackgroundColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  request["title"],
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 5),
                                child: Text(
                                      "by ${request['user']['username']}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    )
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: hexToColor(
                                        request['type']['color']),
                                    borderRadius:
                                        BorderRadius.circular(10000)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    request['type']['type'],
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              request["description"],
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          }
          return res;
        }(),
      );
    }
    return CircularProgressIndicator();
  }

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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: hexToColor(tier['color']),
                      borderRadius: BorderRadius.circular(10000)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text(
                      "Rank: ${tier['name']}",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recently Closed Events:",
                style: TextStyle(fontSize: 22, color: textColor),
                ),
            ),
            FutureBuilder<List<dynamic>>(
                  future: requests,
                  builder: generateRequestsWidget,
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
