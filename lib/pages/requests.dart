import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/requests.dart';
import 'package:plantspots/pages/create_request.dart';
import 'package:plantspots/pages/edit_request.dart';
import 'package:plantspots/pages/view_request.dart';
import 'package:plantspots/utils/colors.dart';
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
                          flex: 4,
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
                                child: Row(
                                  children: [
                                    Text(
                                      "by ${request['user']['username']}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
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
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  request["description"],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                if (username == request["user"]["username"]) {
                                  Navigator.of(context).push(PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: EditRequestPage(
                                        hash: hash,
                                        username: username,
                                        email: email,
                                        phone: phone,
                                        tier: tier,
                                        id: request["id"],
                                      ),
                                      childCurrent: context.currentRoute));
                                } else {
                                  Navigator.of(context).push(PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ViewRequestPage(
                                        hash: hash,
                                        username: username,
                                        email: email,
                                        phone: phone,
                                        tier: tier,
                                        id: request["id"],
                                      ),
                                      childCurrent: context.currentRoute));
                                }
                              },
                              icon: Icon(username == request["user"]["username"]
                                  ? Icons.edit_rounded
                                  : Icons.keyboard_arrow_right_rounded)),
                        )
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

      requests = getRequestsAPI(hash);

      firstTime = false;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              Container(
                padding: EdgeInsets.only(top: 25),
                child: FutureBuilder<List<dynamic>>(
                  future: requests,
                  builder: generateRequestsWidget,
                ),
              )
            ],
          ),
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
