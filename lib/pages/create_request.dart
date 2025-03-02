import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/requests.dart';
import 'package:plantspots/pages/requests.dart';
import 'package:plantspots/utils/vars.dart';

class CreateRequestPage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;

  const CreateRequestPage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
  });

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {

  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  late Map<String, dynamic> tier;

  int? type = 0;
  bool? emailContact = true;
  bool? phoneContact = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String errorMessage = "";
  // double errorMessagePadding = 0;
  double errorMessageSize = 0; // 0 or 15
  bool buttonEnabled = true;

  List<String> images = [];

  bool firstTime = true;

  Widget generateImageWidget(context, index) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child:
                Image.memory(base64.decode(images[index]), fit: BoxFit.cover),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(0),
            child: IconButton(
                onPressed: () { setState(() {
                  images.removeAt(index);
                }); },
                padding: EdgeInsets.all(0),
                visualDensity: VisualDensity(
                    vertical: VisualDensity.minimumDensity,
                    horizontal: VisualDensity.minimumDensity),
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 24,
                  color: textColor,
                  )),
          )
        ]));
  }

  Future pickImage() async {
    try {
      // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final newImages = await ImagePicker().pickMultiImage(limit: 10);

      // if (images == null) return;

      for (XFile image in newImages) {
        if (images.length < 10) {
          setState(() {
            images.add(Base64Encoder.urlSafe()
                .convert((File(image.path).readAsBytesSync())));
          });
        }
      }
    } on PlatformException {
      // print('Failed to pick image: $e');
      // No image picked
    }
  }

  void createRequest() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    setState(() {
      buttonEnabled = false;
      errorMessage = "";
      errorMessageSize = 0;
    });

    if (title == "" || description == "") {
      setState(() {
        errorMessage = "Please Fill All Fields";
        errorMessageSize = 15;
        buttonEnabled = true;
      });
      return;
    }

    if (!emailContact! && !phoneContact!) {
      setState(() {
        errorMessage = "Please Select A Contact Method";
        errorMessageSize = 15;
        buttonEnabled = true;
      });
      return;
    }

    createRequestAPI(title, description, type!, emailContact!, phoneContact!, images).then((res) {
      if (mounted) {
        if (res["status_code"] != 200) {
          setState(() {
            errorMessage = res["error_message"];
            errorMessageSize = 15;
            buttonEnabled = true;
          });
        } else {
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
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Create Request",
                    style: TextStyle(fontSize: 36, color: textColor),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                        errorMessage,
                        style: TextStyle(
                            color: Colors.red, fontSize: errorMessageSize),
                                            ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: TextField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: titleController,
                              style: const TextStyle(
                                color: softTextColor,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Title",
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: descriptionController,
                        style: const TextStyle(
                          color: softTextColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                        maxLines: null,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 0,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value;
                                });
                              },
                              visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 25),
                              child: Text("Land Request"),
                            ),
                            Radio(
                              value: 1,
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = value;
                                });
                              },
                              visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Plant Request"),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 10),
                          child: Text(
                            "Contact Method:",
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Checkbox(
                              value: emailContact,
                              onChanged: (value) {
                                setState(() {
                                  emailContact = value;
                                });
                              },
                              visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 5),
                            child: Text("Email"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: phoneContact,
                            onChanged: (value) {
                              setState(() {
                                phoneContact = value;
                              });
                            },
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Phone"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: Divider(),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: images.isNotEmpty
                        ? [
                            OutlinedButton(
                              onPressed: () {
                                pickImage();
                              },
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  side: BorderSide(color: darkBackgroundColor),
                                  foregroundColor: darkBackgroundColor,
                                  backgroundColor: backgroundColor,
                                  visualDensity: VisualDensity(
                                      vertical: VisualDensity.minimumDensity)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Add Images",
                                  // style: TextStyle(fontSize: 12, color: textColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: GridView.builder(
                                itemCount: images.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 15,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 1),
                                itemBuilder: generateImageWidget,
                              ),
                            )
                          ]
                        : [
                            OutlinedButton(
                              onPressed: () {
                                pickImage();
                              },
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  side: BorderSide(color: darkBackgroundColor),
                                  foregroundColor: darkBackgroundColor,
                                  backgroundColor: backgroundColor,
                                  visualDensity: VisualDensity(
                                      vertical: VisualDensity.minimumDensity)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Add Images",
                                  // style: TextStyle(fontSize: 12, color: textColor),
                                ),
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Divider(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: buttonEnabled ? createRequest : null,
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      side: BorderSide(color: darkBackgroundColor),
                      foregroundColor: darkBackgroundColor,
                      backgroundColor: backgroundColor),
                  child: Text("Create Request"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
