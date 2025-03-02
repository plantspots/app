import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantspots/api/requests.dart';
import 'package:plantspots/pages/requests.dart';
import 'package:plantspots/utils/colors.dart';
import 'package:plantspots/utils/vars.dart';

class ViewRequestPage extends StatefulWidget {
  final String hash;
  final String username;
  final String email;
  final String phone;
  final Map<String, dynamic> tier;
  final int id;

  const ViewRequestPage({
    super.key,
    required this.hash,
    required this.username,
    required this.email,
    required this.phone,
    required this.tier,
    required this.id,
  });

  @override
  State<ViewRequestPage> createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  String hash = "";
  String username = "";
  String email = "";
  String phone = "";
  late int id;
  late Map<String, dynamic> tier;

  late String title;
  late String description;
  late Map<String, dynamic> type;
  late Map<String, dynamic> user;
  late bool emailContact;
  late bool phoneContact;

  int currentImageIndex = 0;

  bool loading = false;

  List<String> images = [];

  bool firstTime = true;

  Widget generateImageWidget(context, index) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.hardEdge,
        child: Stack(children: [
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
                onPressed: () {
                  setState(() {
                    images.removeAt(index);
                  });
                },
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

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      hash = widget.hash;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      tier = widget.tier;
      id = widget.id;

      loading = true;
      getRequestAPI(hash, id).then((res) {
        if (res["status_code"] != 200) {
          setState(() {
            firstTime = true;
          });
        } else {
          setState(() {
            title = res["title"];
            description = res["description"];
            // log(res["type"]["type"]);
            // log(res["email_contact"]);
            // log(res["phone_contact"]);
            type = res["type"];
            user = res["user"];
            emailContact = res["email_contact"];
            phoneContact = res["phone_contact"];
            // type = int.parse(res["type"]["type"]);
            // log(res["email_contact"]);
            // emailContact = bool.parse(res["email_contact"]);
            // phoneContact = bool.parse(res["phone_contact"]);

            List<dynamic> tempImages = res["images"];
            // log(tempImages.length as String);
            images = [];

            for (dynamic image in tempImages) {
              images.add(image["image"]);
            }

            loading = false;
          });
        }
      });

      firstTime = false;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: loading ? Center(child: CircularProgressIndicator()) : FractionallySizedBox(
            widthFactor: 1,
            child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 36, color: textColor),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "by ${user['username']}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: hexToColor(type['color']),
                                  borderRadius: BorderRadius.circular(10000)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  type['type'],
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
                      () {
                        if (images.isEmpty) {
                          return Center();
                        }
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 25, bottom: 15),
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).width / 1.2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                clipBehavior: Clip.hardEdge,
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                        widthFactor: 1,
                                        heightFactor: 1,
                                        child: Image.memory(
                                            base64.decode(
                                                images[currentImageIndex]),
                                            fit: BoxFit.cover)),
                                    () {
                                      if (images.length <= 1) {
                                        return Center();
                                      }
                                      return Container(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                currentImageIndex += 1;
                                                if (currentImageIndex >=
                                                    images.length) {
                                                  currentImageIndex = 0;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color: backgroundColor,
                                            )),
                                      );
                                    }(),
                                    () {
                                      if (images.length <= 1) {
                                        return Center();
                                      }
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                currentImageIndex -= 1;
                                                if (currentImageIndex <= -1) {
                                                  currentImageIndex =
                                                      images.length - 1;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons.keyboard_arrow_left_rounded,
                                              color: backgroundColor,
                                            )),
                                      );
                                    }()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 0),
                          child: Text(
                            description,
                            style: TextStyle(fontSize: 14, color: textColor),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 5),
                          child: Text(
                            "Contact:",
                            style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      () {
                        if (emailContact) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user["email"],
                              style:
                                  TextStyle(fontSize: 14, color: textColor),
                            ),
                          );
                        }
                        return Center();
                      }(),
                      () {
                        if (phoneContact) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user["phone"],
                              style:
                                  TextStyle(fontSize: 14, color: textColor),
                            ),
                          );
                        }
                        return Center();
                      }(),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: FractionallySizedBox(
                      //     widthFactor: 0.8,
                      //     child: Column(
                      //       children: [
                      //         Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Text(
                      //           errorMessage,
                      //           style: TextStyle(
                      //               color: Colors.red, fontSize: errorMessageSize),
                      //                               ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 5, bottom: 10),
                      //             child: FractionallySizedBox(
                      //               widthFactor: 0.8,
                      //               child: TextField(
                      //                 onTapOutside: (event) {
                      //                   FocusManager.instance.primaryFocus?.unfocus();
                      //                 },
                      //                 controller: titleController,
                      //                 style: const TextStyle(
                      //                   color: softTextColor,
                      //                 ),
                      //                 decoration: const InputDecoration(
                      //                   hintText: "Title",
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         TextField(
                      //           onTapOutside: (event) {
                      //             FocusManager.instance.primaryFocus?.unfocus();
                      //           },
                      //           controller: descriptionController,
                      //           style: const TextStyle(
                      //             color: softTextColor,
                      //           ),
                      //           decoration: const InputDecoration(
                      //             hintText: "Description",
                      //           ),
                      //           maxLines: null,
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 35),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Radio(
                      //                 value: 0,
                      //                 groupValue: type,
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     type = value;
                      //                   });
                      //                 },
                      //                 visualDensity: VisualDensity(
                      //                   horizontal: VisualDensity.minimumDensity,
                      //                   vertical: VisualDensity.minimumDensity,
                      //                 ),
                      //                 materialTapTargetSize:
                      //                     MaterialTapTargetSize.shrinkWrap,
                      //               ),
                      //               Padding(
                      //                 padding:
                      //                     const EdgeInsets.only(left: 5, right: 25),
                      //                 child: Text("Land Request"),
                      //               ),
                      //               Radio(
                      //                 value: 1,
                      //                 groupValue: type,
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     type = value;
                      //                   });
                      //                 },
                      //                 visualDensity: VisualDensity(
                      //                   horizontal: VisualDensity.minimumDensity,
                      //                   vertical: VisualDensity.minimumDensity,
                      //                 ),
                      //                 materialTapTargetSize:
                      //                     MaterialTapTargetSize.shrinkWrap,
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(left: 5),
                      //                 child: Text("Plant Request"),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 25, bottom: 10),
                      //             child: Text(
                      //               "Contact Method:",
                      //               style: TextStyle(
                      //                   fontSize: 16,
                      //                   color: textColor,
                      //                   fontWeight: FontWeight.w500),
                      //             ),
                      //           ),
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.only(bottom: 5),
                      //               child: Checkbox(
                      //                 value: emailContact,
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     emailContact = value;
                      //                   });
                      //                 },
                      //                 visualDensity: VisualDensity(
                      //                   horizontal: VisualDensity.minimumDensity,
                      //                   vertical: VisualDensity.minimumDensity,
                      //                 ),
                      //                 materialTapTargetSize:
                      //                     MaterialTapTargetSize.shrinkWrap,
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(left: 10, bottom: 5),
                      //               child: Text("Email"),
                      //             ),
                      //           ],
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             Checkbox(
                      //               value: phoneContact,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   phoneContact = value;
                      //                 });
                      //               },
                      //               visualDensity: VisualDensity(
                      //                 horizontal: VisualDensity.minimumDensity,
                      //                 vertical: VisualDensity.minimumDensity,
                      //               ),
                      //               materialTapTargetSize:
                      //                   MaterialTapTargetSize.shrinkWrap,
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(left: 10),
                      //               child: Text("Phone"),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 25, bottom: 15),
                      //   child: Divider(),
                      // ),
                      // FractionallySizedBox(
                      //   widthFactor: 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(10),
                      //     child: Column(
                      //       children: images.isNotEmpty
                      //           ? [
                      //               OutlinedButton(
                      //                 onPressed: () {
                      //                   pickImage();
                      //                 },
                      //                 style: OutlinedButton.styleFrom(
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.circular(2)),
                      //                     side: BorderSide(color: darkBackgroundColor),
                      //                     foregroundColor: darkBackgroundColor,
                      //                     backgroundColor: backgroundColor,
                      //                     visualDensity: VisualDensity(
                      //                         vertical: VisualDensity.minimumDensity)),
                      //                 child: Padding(
                      //                   padding:
                      //                       const EdgeInsets.symmetric(vertical: 5),
                      //                   child: Text(
                      //                     "Add Images",
                      //                     // style: TextStyle(fontSize: 12, color: textColor),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(top: 25),
                      //                 child: GridView.builder(
                      //                   itemCount: images.length,
                      //                   shrinkWrap: true,
                      //                   padding: EdgeInsets.all(0),
                      //                   gridDelegate:
                      //                       SliverGridDelegateWithFixedCrossAxisCount(
                      //                           crossAxisCount: 5,
                      //                           mainAxisSpacing: 15,
                      //                           crossAxisSpacing: 10,
                      //                           childAspectRatio: 1),
                      //                   itemBuilder: generateImageWidget,
                      //                 ),
                      //               )
                      //             ]
                      //           : [
                      //               OutlinedButton(
                      //                 onPressed: buttonEnabled ? () {
                      //                   pickImage();
                      //                 } : null,
                      //                 style: OutlinedButton.styleFrom(
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.circular(2)),
                      //                     side: BorderSide(color: darkBackgroundColor),
                      //                     foregroundColor: darkBackgroundColor,
                      //                     backgroundColor: backgroundColor,
                      //                     visualDensity: VisualDensity(
                      //                         vertical: VisualDensity.minimumDensity)),
                      //                 child: Padding(
                      //                   padding:
                      //                       const EdgeInsets.symmetric(vertical: 5),
                      //                   child: Text(
                      //                     "Add Images",
                      //                     // style: TextStyle(fontSize: 12, color: textColor),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 15, bottom: 15),
                      //   child: Divider(),
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Row(
                      //     children: [
                      //       OutlinedButton(
                      //         onPressed: buttonEnabled ? editRequest : null,
                      //         style: OutlinedButton.styleFrom(
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(2)),
                      //             side: BorderSide(color: darkBackgroundColor),
                      //             foregroundColor: darkBackgroundColor,
                      //             backgroundColor: backgroundColor),
                      //         child: Text("Save Request"),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 10),
                      //         child: OutlinedButton(
                      //           onPressed: buttonEnabled ? closeRequest : null,
                      //           style: OutlinedButton.styleFrom(
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(2)),
                      //               side: BorderSide(color: darkBackgroundColor),
                      //               foregroundColor: darkBackgroundColor,
                      //               backgroundColor: backgroundColor),
                      //           child: Text("Close Request"),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
