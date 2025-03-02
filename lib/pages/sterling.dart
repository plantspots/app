import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantspots/api/open_ai.dart';
import 'package:plantspots/utils/vars.dart';
import 'package:plantspots/widgets/navbar.dart';

class SterlingPage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const SterlingPage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
  });

  @override
  State<SterlingPage> createState() => _SterlingPageState();
}

class _SterlingPageState extends State<SterlingPage> {
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  late Map<String, dynamic> tier;

  final TextEditingController messageController = TextEditingController();

  String apiKey = "";

  List<Map<String, String>> messages = [
    {
      "role": "system",
      "content":
          "You are a helpful AI chat assistant named Sterling. You are kind, respectful and extremely helpful. You speak in a formal tone. You help users of the app PlantSpots using the following help guide. For anything outside of this dataset, kindly decline to help and suggest that they contact support. Begin by greeting a user fo this app.\n\nApp Description:\nPlantSpots is an app designed to connect those with plants with those with land to help increase plant populations and improve the planet. The way this app works is through requests. Both land owners and plant owners can make requests which can be responded to by the opposite.\n\nHelp Guide:\nQ: How to Add A Request?\nA: Navigate to the requests tab and click on the plus icon in the top-corner. Fill in all the fields and press the 'Create Request' button to add your request.\nQ: How to Edit A Request?\nA: Navigate to the requests tab and find the request you want to edit (request must be posted by yourself). Click on the edit icon (pencil icon) on the right-hand side of your desired request. Update all the fields and press the 'Save Request' button to add your request.\nQ: How to Mark A Request As Complete?\nA: Navigate to the requests tab and find the request you want to edit (request must be posted by yourself). Click on the edit icon (pencil icon) on the right-hand side of your desired request. Press the 'Close Request' button to add your request."
    }
  ];

  bool firstTime = true;
  bool loading = true;

  void sendMessage() {
    final message = messageController.text.trim();

    setState(() {
      messages.add({"role": "user", "content": message});
    });

    sendMessageOpenAIAPI(messages, apiKey).then((res) {
      if (this.mounted) {
        final data = jsonDecode(res.body);

        if (res.statusCode == 200) {
          setState(() {
            messages.add({
              "role": "assistant",
              "content": data["choices"][0]["message"]["content"]
            });
            messageController.text = "";
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;

      getOpenAIKeyAPI(hash).then((res) {
        setState(() {
          apiKey = res["key"];

          sendMessageOpenAIAPI(messages, apiKey).then((res) {
            if (this.mounted) {
              final data = jsonDecode(res.body);
              print(res.body);

              if (res.statusCode == 200) {
                setState(() {
                  messages.add({
                    "role": "assistant",
                    "content": data["choices"][0]["message"]["content"]
                  });
                  messageController.text = "";
                });
              }
            }
            setState(() {
              loading = false;
            });
          });
        });
      });

      firstTime = false;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 5,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: () {
                            List<Widget> res = [];

                            for (Map<String, String> message in messages) {
                              // print(message["content"]);
                              if (message["role"] == "system") {
                                continue;
                              }

                              res.add(Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  alignment: message["role"] == "user"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: message["role"] == "user" ? 0 : 5, right: message["role"] == "user" ? 5 : 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.75,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: message["role"] == "user" ? darkBackgroundColor : mediumBackgroundColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        child: Align(
                                          // alignment: message["role"] == "user" ? Alignment.centerRight : Alignment.centerLeft,
                                          alignment: Alignment.centerLeft,
                                          child: Text(message["content"]!,
                                          style: TextStyle(
                                            color: message["role"] == "user" ? backgroundColor : textColor
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                            }

                            return res;
                          }(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: "Your Question",
                                  border: InputBorder.none),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: IconButton(
                                onPressed: sendMessage,
                                icon: Icon(Icons.send_rounded),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: NavbarWidget(
        index: 2,
        hash: hash,
        username: username,
        email: email,
        phone: phone,
        tier: tier,
      ),
    );
  }
}
