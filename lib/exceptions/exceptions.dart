import 'dart:developer';
import 'package:cat_tapper_telegram_web_app/config/routes_config.dart';
import 'package:cat_tapper_telegram_web_app/shared/widgets/custom_button.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ErrorCatcher {
  bool dialogIsOpen = false;

  void showDialogForError(AppExceptions exception) {
    log(exception.toString());
    if (dialogIsOpen) {
      return;
    }
    dialogIsOpen = true;
    showDialog(
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error!'),
        actionsAlignment: MainAxisAlignment.center,
        content: Text(exception.messageForUser),
        actions: [
          CustomButton(
            primary: true,
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      context: navigatorKey.currentState!.context,
    ).then(
      (_) {
        dialogIsOpen = false;
      },
    );
  }
}

// {AppExceptions} - name of the model class which represents the building entity of the error
class AppExceptions extends Equatable {
  final String messageForUser;
  final String messageForDev;
  const AppExceptions({
    required this.messageForUser,
    required this.messageForDev,
  });

  AppExceptions.fromError(dynamic error)
      : this(messageForUser: error.toString(), messageForDev: error.toString());

  @override
  String toString() => "messageForDev $messageForDev";

  @override
  List<Object?> get props => [messageForUser, messageForDev];
}
