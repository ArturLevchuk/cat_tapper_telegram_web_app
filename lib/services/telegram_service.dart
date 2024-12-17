import 'dart:convert';
import 'package:flutter/widgets.dart';
// import 'dart:js' as js;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class TelegramService {
  Map<String, dynamic>? telegramData;

  TelegramService() {
    getTelegramData();
  }

  void getTelegramData() {
    telegramData = initTelegramWebApp();
    if (telegramData != null && telegramData!.isNotEmpty) {
      debugPrint('Telegram Data: $telegramData');
    } else {
      debugPrint('Telegram data is null. This app is opened outside telegram');
    }
  }

  // Function to initialize the Telegram WebApp
  static Map<String, dynamic>? initTelegramWebApp() {
    // final result = js.context.callMethod('initTelegramWebApp');
    final result =
        globalContext.callMethod<JSString?>('initTelegramWebApp'.toJS);
    debugPrint("result: $result");
    if (result != null) {
      // Convert JsObject to JSON string and then parse it to a Map
      // String jsonString = js.context['JSON'].callMethod('stringify', [result]);
      return jsonDecode(result.toDart);
    }

    return null;
  }

  // Function to send data back to Telegram
  static void sendTelegramData(String data) {
    globalContext.callMethod('sendTelegramData'.toJS, [data.toJS].toJS);
  }

  // Function to control the MainButton in Telegram
  static void setMainButton(String text, bool isVisible) {
    globalContext.callMethod(
        'setMainButton'.toJS, [text.toJS, isVisible.toJS].toJS);
  }
}
