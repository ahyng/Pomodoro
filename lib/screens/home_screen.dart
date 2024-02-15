import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  static const fiveMinutes = 300;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;
  bool working = true;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        working ? totalPomodoros += 1 : null;
        totalSeconds = working ? fiveMinutes : twentyFiveMinutes;
        working = !working;
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void reset() {
    timer.cancel();
    setState(() {
      isRunning = false;
      working = true;
      totalPomodoros = 0;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return (duration.toString().split('.').first.substring(2, 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: working
          ? Theme.of(context).colorScheme.background
          : const Color.fromARGB(255, 79, 150, 208),
      body: Column(children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              format(totalSeconds),
              style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 89,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 120,
                  color: Theme.of(context).cardColor,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: Icon(isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                  child: Text(
                    'reset',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge!.color,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
