import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);
  static const String WebViewPageId = 'WebviewPageId';
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void writePassword() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('password', 'opinator');

  }
  Future confirmPassword(password) async {
    final SharedPreferences prefs = await _prefs;
    print(password);
    var pass = prefs.getString('password');
    print(pass);
    if(pass==password){
      return Future.value(true);
    }
    return Future.value(false);
  }

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://web.opinator.com/'));
  @override void init_state(){
    writePassword();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        WebViewWidget(controller: controller),
        Positioned(
          left: 0,
            top: 0,
            child: MaterialButton(onPressed: (){


            },child: Container(width: 50,height: 50,color: Color.fromRGBO(0, 0, 0, 0),),
            onLongPress: (){
              showDialog(context: context, builder: (BuildContext context){
                TextEditingController controladorPass = TextEditingController();
                return AlertDialog(
                  title: const Text("Ingresa una Contraseña"),
                  content: TextField(controller: controladorPass),
                  actions: <Widget>[
                    TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar"))
                    ,TextButton(onPressed: () async{
                      writePassword();
                      bool checkPass = await confirmPassword(controladorPass.value.text);

                      if(checkPass) {
                        stopKioskMode();
                        Navigator.popAndPushNamed(context, "/");
                      }
                      Navigator.pop(context);
                    }, child: Text("Entrar"))
                  ],

                );
              });
            },)),
      ]),

    );
  }
}


// ,
// ),
// MaterialButton(onPressed: ()async{
// var location = Location();
// var currentLocation = await location.getLocation();
// print(currentLocation);
// await MethodChannelNetworkUsage.init(); // Only Required for Android
// List<NetworkUsageModel> networkUsage = await MethodChannelNetworkUsage.networkUsageAndroid(
// withAppIcon: true,
// dataUsageType: NetworkUsageType.wifi,
// oldVersion: false // will be true for Android versions lower than 23 (MARSHMELLOW)
// );
// print(networkUsage);
// List<NetworkUsageModel> cellUsage = await MethodChannelNetworkUsage.networkUsageAndroid(
// withAppIcon: true,
// dataUsageType: NetworkUsageType.mobile,
// oldVersion: false // will be true for Android versions lower than 23 (MARSHMELLOW)
// );
// print(cellUsage);
// var battery = Battery();
//
// // Access current battery level
// print(await battery.batteryLevel);
// }, child: Text('Obtener Información'),)