import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PowerButton extends StatefulWidget {
  PowerButton({
    this.color,
    this.onPress,
  });

  final Color color;
  final Function onPress;

  @override
  _PowerButtonState createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.4;
    return Container(
      child: ClipOval(
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.color, width: 10.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(width),
          ),
          child: ClipOval(
            child: FlatButton(
              onPressed: widget.onPress,
              child: ClipOval(
                child: Icon(
                  FontAwesomeIcons.powerOff,
                  size: width * 0.35,
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
