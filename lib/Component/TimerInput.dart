import 'package:flutter/material.dart';

class TimerInpute extends StatefulWidget {
  TimerInpute({
    @required this.cnt,
    @required this.increment,
    @required this.decrement,
    @required this.StartTimer,
  });

  final int cnt;
  final Function increment;
  final Function decrement;
  final Function StartTimer;

  @override
  _TimerInputeState createState() => _TimerInputeState();
}

class _TimerInputeState extends State<TimerInpute> {
  final TextStyle textStyle = TextStyle(
    color: Color(0xff589DFF),
    fontWeight: FontWeight.w500,
    fontSize: 22.0,
  );

   double iconWidth=35.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Color(0xff1F3A61),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child:
                        /*TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),*/
                        Center(
                          child: Text(
                      '${widget.cnt}',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 36,
                          color: Colors.white,
                      ),
                    ),
                        )),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: iconWidth,
                        child: InkWell(
                          onTap: widget.increment,
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        width: iconWidth,
                        color: Color(0xff1F3A61),
                      ),
                      Container(
                        width: iconWidth,
                        child: InkWell(
                          onTap: widget.decrement,
                          child: Icon(
                            Icons.remove,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5 + 16,
            child: Text(
              'Seconds',
              style: textStyle.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Color(0xff076AFD),
            ),
            child: FlatButton(
              onPressed: widget.StartTimer,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: Text(
                  'Set Time',
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
