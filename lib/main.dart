import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'Component/PowerButton.dart';
import 'Component/TimerInput.dart';

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
  Color red = Color(0xffFF3743);
  Color Green = Color(0xff03AB0A);
  Color ButtonColor = Color(0xffFF3743);

  Color textColor = Color(0xff589DFF);
  final TextStyle textStyle = TextStyle(
    color: Color(0xff589DFF),
    fontWeight: FontWeight.w500,
    fontSize: 22.0,
  );

  int cnt = 0;
  int timeCount = 5;
  bool InputVisibility = false;
  bool TimerVisibility = false;
  bool buttonPress = false;

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

  static Future flash(Duration duration) =>
      turnOn().whenComplete(() => Future.delayed(duration, () => turnOff()));

  Future<String> testDelay(int a) {
    Future<String> t = Future.delayed(Duration(seconds: 1), () {
      return '$a';
    });

    return t;
  }

  String SENT = '0';

  void Resent(int c) async {
    for (int i = 1; i <= c; i++) {
      String s = await testDelay(c - i);
      var Rsent = s;
      setState(() {
        SENT = Rsent;
      });
    }
    print('<=============Timer End ==============>');
    onButtonPress(false);
    InputVisibility = true;
    TimerVisibility = false;
  }

  bool _light = false;
  bool hasTorch = false;

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

  Widget TorchUI(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        InputVisibility = !InputVisibility;
                        TimerVisibility = false;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.alarm,
                          color: textColor,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Set Timer',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: InputVisibility,
                    child: TimerInpute(
                      cnt: timeCount,
                      decrement: () {
                        setState(() {
                          timeCount--;
                        });
                      },
                      increment: () {
                        setState(() {
                          timeCount++;
                        });
                      },
                      StartTimer: () {
                        //todo start timer
                        setState(() {
                          InputVisibility = false;
                          SENT = '$timeCount';
                          TimerVisibility = true;
                          onButtonPress(true);
                          Resent(timeCount);
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: TimerVisibility,
                    child: Text(
                      '$SENT',
                      style: textStyle.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.45),
            child: PowerButton(
              color: ButtonColor,
              onPress: () {
                buttonPress = !buttonPress;
                onButtonPress(buttonPress);
              },
            ),
          ),
        ],
      ),
    );
  }

  void onButtonPress(bool b) {
    if (b == true) {
      turnOn();
      setState(() {
        ButtonColor = Green;
      });
    } else {
      setState(() {
        ButtonColor = red;
      });

      turnOff();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff122239),
      body: SafeArea(
        child: hasTorch ? TorchUI(context) : FailedText(),
      ),
    );
  }
}
