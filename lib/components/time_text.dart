import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimeText extends StatefulWidget {
  final DateTime date;
  final TextStyle style;

  TimeText(this.date, {this.style, Key key}) : super(key: key);

  @override
  _TimeTextState createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  late Timer _timer;
  late Duration _duration;

  int diffMinutes() {
    final now = DateTime.now();
    return now.difference(widget.date).inMinutes;
  }

  @override
  void initState() {
    super.initState();
    _duration = DateTime.now().difference(widget.date);
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _duration = DateTime.now().difference(widget.date);
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimeText oldWidget) {
    if (oldWidget.date.compareTo(widget.date) != 0) updateTimer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final diff = diffMinutes();
    String label;
    if (diff < 60) {
      label = "${diff}m";
    } else if (diff < 60 * 24) {
      label = "${diff ~/ 60}h";
    } else {
      label = "${diff ~/ (60 * 24)}d";
    }
    return Text(label, style: widget.style);
  }
}
