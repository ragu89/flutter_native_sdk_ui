import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter and PhotoEditorSDK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform =
      const MethodChannel("ch.ragu.flutter_native_sdk/photoEditorChannel");
  var _callDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InfoTitle(),
          FlatButton(
            child: Text("Start native PhotoEditor"),
            onPressed: _startPhotoEditorScreen,
            textTheme: ButtonTextTheme.accent,
          ),
          ShowDuration(
            callDuration: _callDuration,
          )
        ],
      ),
    );
  }

  void _startPhotoEditorScreen() async {
    print("_startPhotoEditorScreen");
    var callDuration = "Unknown call duration.";
    try {
      callDuration = await platform.invokeMethod("openPhotoEditor");
    } on PlatformException catch (_) {
      callDuration = "Failed to get call duration.";
    }
    setState(() {
      _callDuration = callDuration;
    });
  }
}

/// Widget to display start video call title.
class InfoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "This is a Flutter App that will open a native view from a 3rd party native SDK",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Widget to display last call duration.
class ShowDuration extends StatelessWidget {
  final String callDuration;

  const ShowDuration({Key key, this.callDuration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (callDuration != null) {
      return Text("Last call duration : $callDuration");
    } else {
      return Container();
    }
  }
}
