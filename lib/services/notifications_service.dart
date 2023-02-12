import 'package:flutter/material.dart';


class NotificationsService {
  
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {


    final snackbar =  SnackBar(
      content: Text( message, style: TextStyle( fontSize: 20, color: Colors.white),)
    );

    messengerKey.currentState!.showSnackBar(snackbar );
    
  }


}