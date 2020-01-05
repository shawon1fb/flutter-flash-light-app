import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;

    try {
      final result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at ${result.toString()} % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('========== flutter PlatformException execption==========');
      print(e);
    } catch (e) {
      print('========== flutter execption==========');
      print(e);
    }

    setState(() {
      _batteryLevel = batteryLevel;
      print(_batteryLevel);
    });
  }

  static Future turnOn() async {
    platform.invokeMethod('turnOn');
  }

  static Future turnOff() async {
    platform.invokeMethod('turnOff');
  }

  static Future<bool> HasTorch() async {
    try {
      final bool b = await platform.invokeMethod('hasTorch');
      return b;
    } catch (e) {
      print('=========error========');
      print(e);
    }
    return false;
  }

  bool _light = false;
  String ButtonText = "ON";
  bool hasTorch = false;
  var _gradient = RadialGradient(
    center: const Alignment(0, 0), // near the top right
    radius: 0.5,
    colors: [
      const Color(0xFFFFFF00), // yellow sun
      const Color(0xFF0099FF), // blue sky
    ],
    stops: [0.4, 1.0],
  );

  void CleckFlash() async {
    bool _temp = await HasTorch();
    setState(() {
      hasTorch = _temp;

      print("hasTorch: " + hasTorch.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CleckFlash();
  }

  Widget FailedText() {
    return Container(
      child: Center(
        child: Text(
          "No flash light detected",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: hasTorch
            ? Container(
                decoration: BoxDecoration(
                  gradient: (_light) ? _gradient : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blue),
                        child: ClipOval(
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _light = !_light;
                                if (_light) {
                                  ButtonText = "OFF";
                                  //Lantern.turnOn();
                                  turnOn();
                                } else {
                                  ButtonText = "ON";
                                  //Lantern.turnOff();
                                  turnOff();
                                }
                              });
                            },
                            child: Text(
                              '$ButtonText',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : FailedText(),
      ),
    );
  }
}
