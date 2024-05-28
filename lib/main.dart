import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:location/location.dart';
import 'package:network_usage/network_usage.dart';
import 'package:network_usage/network_usage_method_channel.dart';
import 'package:network_usage/src/model/network_usage_model.dart';
import 'package:opinator_demo/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
  initialRoute: "/",
    routes: {
      "/": (context)=>_Home(),
      WebViewPage.WebViewPageId: (context) => WebViewPage()
    },
  );
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();


}

class _HomeState extends State<_Home> {
  late final Stream<KioskMode> _currentMode = watchKioskMode();


  @override void init_state(){
    startKioskMode();
    super.initState();
  }
  void _showSnackBar(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  void _handleStart(bool didStart) {
    if (!didStart && Platform.isIOS) {
      _showSnackBar(
        'Single App mode is supported only for devices that are supervised'
            ' using Mobile Device Management (MDM) and the app itself must'
            ' be enabled for this mode by MDM.',
      );
    }
    Navigator.popAndPushNamed(context, WebViewPage.WebViewPageId);
  }

  @override void stopKioskMode(){
    print('Hello World');
    stopKioskMode();
  }

  void _handleStop(bool? didStop) {
    if (didStop == false) {
      _showSnackBar(
        'Kiosk mode could not be stopped or was not active to begin with.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _currentMode,
    builder: (context, snapshot) {
      final mode = snapshot.data;
      final message = mode == null
          ? 'Can\'t determine the mode'
          : 'Current mode: $mode';

      return Scaffold(
        appBar: AppBar(title: 
          Row(
            children: [
              Image.asset('assets/images/OPINATOR-logo1.png')
            ],
          )
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [

              MaterialButton(
                onPressed: mode == null || mode == KioskMode.enabled
                    ? null
                    : () => startKioskMode().then(_handleStart),
                child: const Text('Empezar Aplicación'),
              ),


              MaterialButton(
                onPressed: () async {
                  const intent = AndroidIntent(
                    action: 'android.intent.action.SET_ALARM',
                    arguments: <String, dynamic>{
                      'android.intent.extra.alarm.DAYS': <int>[2, 3, 4, 5, 6],
                      'android.intent.extra.alarm.HOUR': 21,
                      'android.intent.extra.alarm.MINUTES': 30,
                      'android.intent.extra.alarm.SKIP_UI': true,
                      'android.intent.extra.alarm.MESSAGE': 'Create a Flutter app',
                    },
                  );
                  intent.launch();
                  // AndroidIntent intent = AndroidIntent(
                  //   action: 'action_view',
                  //   data: 'https://play.google.com/store/apps/',
                  //
                  // );
                  // intent.launch();
                  // Intent promptInstall =  Intent(Intent.ACTION_VIEW)
                  //     .setDataAndType(Uri.parse("file:///path/to/your.apk"),
                  //     "application/vnd.android.package-archive");
                  // startActivity(promptInstall);                 },
                }, child: Text('Actualizar Aplicación'),
              )
            ],
          ),
        ),
      );
    },
  );
}