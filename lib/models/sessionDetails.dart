import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class SessionDetails extends ChangeNotifier {
  String? code = "0";
  String? isLoggedIn;
  String? loginToken;
  String? userId;
  String? userType;
  String? fullName;
  String? givenName;
  String? message;

  SessionDetails(
      {this.code,
      this.isLoggedIn,
      this.loginToken,
      this.userId,
      this.userType,
      this.fullName,
      this.givenName,
      this.message});
  static SessionDetails fromJSON(String jsonString) {
    Map<String, String> sessionDetailsMap = json.decode(jsonString)["status"];
    return SessionDetails(
        code: sessionDetailsMap["is_login"].toString(),
        isLoggedIn: sessionDetailsMap["is_login"].toString(),
        loginToken: sessionDetailsMap["login_token"].toString(),
        userId: sessionDetailsMap["user_id"].toString(),
        userType: sessionDetailsMap["user_type"].toString(),
        fullName: sessionDetailsMap["full_name"].toString(),
        givenName: sessionDetailsMap["given_name"].toString(),
        message: sessionDetailsMap["message"].toString());
  }

  Map<String, String> toJSON() => {
        "code": code!,
        "isLoggedIn": isLoggedIn!,
        "loginToken": loginToken!,
        "userId": userId!,
        "userType": userType!,
        "fullName": fullName!,
        "givenName": givenName!,
        "message": message!,
      };
}
