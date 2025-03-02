import 'dart:io';
import 'dart:ui';

bool isMobile = (Platform.isAndroid || Platform.isIOS);

String rootAPIURL = "https://excessive-julieta-plantspotsproject-70dd9d8e.koyeb.app/api/";
String rootAPIDomain = "excessive-julieta-plantspotsproject-70dd9d8e.koyeb.app";
String rootAPIPath = "/api/";

const primaryColor = Color.fromRGBO(112, 224, 0, 1);
const textColor = Color.fromRGBO(0, 0, 0, 1);
const softTextColor = Color.fromRGBO(8, 16, 0, 1);
const backgroundColor = Color.fromRGBO(255, 255, 255, 1);
const softBackgroundColor = Color.fromRGBO(245, 255, 235, 1);
const mediumBackgroundColor = Color.fromRGBO(214, 255, 173, 1);
const darkBackgroundColor = Color.fromRGBO(24, 48, 0, 1);

const errorColor = Color.fromRGBO(224, 67, 0, 1);