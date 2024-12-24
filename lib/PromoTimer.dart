import 'dart:async';
import 'package:flutter/material.dart';

class PromoTimer extends StatefulWidget {
  final String endTime;
  final double fontSize;

  const PromoTimer({
    Key? key,
    required this.endTime,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  _PromoTimerState createState() => _PromoTimerState();
}

class _PromoTimerState extends State<PromoTimer> {
  Timer? _timer;
  late Duration _remainingTime;
  final Color timerRed = const Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void _initTimer() {
    List<String> timeParts = widget.endTime.split(':');
    _remainingTime = Duration(
      hours: int.parse(timeParts[0]),
      minutes: int.parse(timeParts[1]),
      seconds: int.parse(timeParts[2]),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes.remainder(60);
    int seconds = _remainingTime.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: timerRed.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: widget.fontSize + 2,
          ),
          const SizedBox(width: 4),
          _buildTimeUnit(_formatNumber(hours), 'h'),
          _buildSeparator(),
          _buildTimeUnit(_formatNumber(minutes), 'm'),
          _buildSeparator(),
          _buildTimeUnit(_formatNumber(seconds), 's'),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String unit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: widget.fontSize - 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}