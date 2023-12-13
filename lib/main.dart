import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  bool isRunning = false;
  bool isPaused = false;
  bool isSoundEnabled = false; // Added for controlling sound
  int maxTimeInSeconds = 30;
  int currentTimeInSeconds = 30; // Initial time
  int timerCompletionCount = 0; // Number of times the timer has completed
  List<String> dotStatements = [
    'Nom nom :)',
    'BreakTime ',
    'Finish Your Meal',
  ];
  List<String> dotSubStatements = [
    'You have 10 minutes to eat before the pause. Focus on eating slowly ',
    'Take a five-minute break to check in on your fitness level of fullness ',
    'You can eat until you feel full',
  ];
  int activeDotIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDot(0),
              SizedBox(width: 8),
              buildDot(1),
              SizedBox(width: 8),
              buildDot(2),
            ],
          ),
          SizedBox(height: 20),
          Text(
            dotStatements[timerCompletionCount],
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Silkscreen-Regular'),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Text(
                dotSubStatements[timerCompletionCount],
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab-Regular'),
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: 245,
            height: 245,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(''),)
                ),

                Positioned(
                  top: 7.8,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      value: currentTimeInSeconds / maxTimeInSeconds,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                      backgroundColor: Colors.white,
                      strokeWidth: 10,
                    ),
                  ),
                ),
                Text(
                  formatTime(currentTimeInSeconds),
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      '\n\n\n minutes remaining',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Switch(
                  value: isSoundEnabled,
                  onChanged: (value) {
                    setState(() {
                      isSoundEnabled = value;
                    });
                  },
                  activeTrackColor: Colors.grey,
                  activeColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashRadius: 14,
                  overlayColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              Text(
                'Enable Sound ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),

          Visibility(
              visible: !isRunning,
              child: SizedBox(
                width: 300, // Width of the ElevatedButton
                child: ElevatedButton(
                  onPressed: () {
                    startStopwatch();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // Adjust the elevation value as needed
                    primary:
                        Colors.greenAccent, // Set the button's background color
                    shadowColor: Colors.black, // Set the shadow color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Adjust the border radius
                    ),
                  ),
                  child: Container(
                    height: 70,
                    child: Center(
                      child: Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Visibility(
            visible: isRunning,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      pauseStopwatch();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // Adjust the elevation value as needed
                      primary:
                          Colors.greenAccent, // Set the button's background color
                      shadowColor: Colors.lightGreen, // Set the shadow color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Adjust the border radius
                      ),
                    ),
                    child: Text(
                      'Pause',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: 300,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      resetStopwatch();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // Adjust the elevation value as needed
                      primary:
                          Colors.redAccent, // Set the button's background color
                      shadowColor: Colors.black, // Set the shadow color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Adjust the border radius
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),

        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == timerCompletionCount
            ? Color.fromARGB(255, 79, 133, 18)
            : Color.fromARGB(255, 242, 236, 236),
      ),
    );
  }

  void startStopwatch() {
    setState(() {
      isRunning = true;
      isPaused = false;
    });

    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      } else if (!isPaused && currentTimeInSeconds > 0) {
        setState(() {
          currentTimeInSeconds--;
          if (isSoundEnabled && currentTimeInSeconds <= 5) {
            playSound();
          }
          updateActiveDot();
        });
      } else if (currentTimeInSeconds <= 0) {
        playSound();
        resetStopwatch(); // Automatically reset to 30 seconds after completing to zero
        timer.cancel();
      }
    });
  }

  void pauseStopwatch() {
    setState(() {
      isPaused = true;
    });
  }

  void resetStopwatch() {
    setState(() {
      isRunning = false;
      isPaused = false;
      currentTimeInSeconds = maxTimeInSeconds;
      timerCompletionCount++; // Increment the completion count
      if (timerCompletionCount >= dotStatements.length) {
        // Reset completion count to 0 when it reaches the length of dotStatements
        timerCompletionCount = 0;
      }
    });
  }

  void updateActiveDot() {
    int totalDots = dotStatements.length;
    int secondsPerDot = maxTimeInSeconds ~/ totalDots;

    int newActiveDotIndex =
        (maxTimeInSeconds - currentTimeInSeconds) ~/ secondsPerDot;

    if (newActiveDotIndex < totalDots && newActiveDotIndex != activeDotIndex) {
      setState(() {
        activeDotIndex = newActiveDotIndex;
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void playSound() async {
    if (isSoundEnabled) {
      // Repeat the audio for the last 5 seconds
      for (int i = 0; i < 5; i++) {
        await audioPlayer.play('assets/countdown_tick.mp3');
      }
    }
  }
}
