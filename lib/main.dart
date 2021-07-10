import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'dart:async';
void main() {
  runApp(MyFaApp());
}

// *********Don't touch anything under the return method*********
DateTime currentBackPressTime;
class MyFaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // ***********status bar color and navigation bar color******
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFFE03B4D));
    FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFE03B4D));
    // ***************change color here!****************
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        debugShowCheckedModeBanner: false,
      home: Scaffold(
      // appBar: AppBar(),
        body: SafeArea(child: MyAppBody()),

      ),
    );
  }
}
// *******gloabl variable for controling the webView state*****
WebViewController controllerGlobal;

Future<bool> browserBack(BuildContext context) async{
  print('activated');

  // if(await controllerGlobal.canGoBack())
  // {print('cant');}
  if (await controllerGlobal.canGoBack()) {
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("loading...")),
    );
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // Scaffold.of(context).showSnackBar(
    //   const SnackBar(content: Text("Double Press To Exit")),
    // );
    return Future.value(false);
  }


}

// ***********stateFulWidget for FCM***************


class MyAppBody extends StatefulWidget {

  @override
  _MyAppBodyState createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<MyAppBody> {
  // ****Firebase var for messaging****
  final FirebaseMessaging _messaging = FirebaseMessaging();
  // *****Webview state controller*****
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState(){
    super.initState();
    _messaging.getToken().then((token) => print(token));

  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: ()=> browserBack(context),
      child:Scaffold(

      body: Builder(builder: (BuildContext context){
          return WebView(
            // **********change the url only here*******
            initialUrl: 'https://env-5604035.cloudjiffy.net/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              controllerGlobal = webViewController;
              // ************passing the controllerGlobal state to Webview contr
              //-oler**************
            },
          );
      },),

      ),
    );
    // controllerGlobal.canGoBack();
  }



}


