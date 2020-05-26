// // it is a comment (App 1------ playing audio via assets folder)
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audio_cache.dart';

// void main() {
//  runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Voices Demo',
//      home:Scaffold(
//        backgroundColor: Colors.black87,
//        body: SafeArea(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              FlatButton(
//                onPressed: () {
//                  final player = AudioCache();
//                  player.play('click.mp3');
//                },
//                onLongPress: (){
//                  print("longpress");
//                },
//                textColor: Colors.red,
//                child: Text(
//                  "Press me to hear a Sound",
//                  style: TextStyle(fontSize: 20.0),
//                ),
//              ),
//              FlatButton(
//                onPressed: () {
//                  final player = AudioCache();
//                  player.play('yes.mp3');
//                },
//                onLongPress: (){
//                  print("longpress2");
//                },
//                textColor: Colors.green,
//                child: Text(
//                  "Press me to hear a Sound",
//                  style: TextStyle(fontSize: 20.0),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),

//    );
//  }
// }

// it is a comment (App 2------ hindi speech recognation)
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      //directly assigning hindi for speech recognation...change which language to choose from here
      _currentLocaleId = 'hi_IN';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = !hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hindi Speech Recognation'),
          backgroundColor: Colors.black,
        ),
        body: Column(children: [
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Press Me, then press mike'),
                      color: Colors.blue,
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                    FlatButton(
                      //prints the language of recognation
                      child: Text(_currentLocaleId),
                      color: Colors.purpleAccent,

                    )
                  ],
                ),
                //start stop and cancel buttons of the speech recognation...these help to fine control the speech recognation...we have toggled the start and stop button together
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    FlatButton(
//                      child: Text('Start'),
//                      onPressed: startListening,
//                    ),
//                    FlatButton(
//                      child: Text('Stop'),
//                      onPressed: stopListening,
//                    ),
//                    FlatButton(
//                      child: Text('cancel'),
//                      onPressed: cancelListening,
//                    ),
//                  ],
//                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 1.5,
                                    color: Colors.greenAccent.withOpacity(0.5))
                              ],
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.mic),
                                onPressed: speech.isListening ? stopListening :  startListening,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 2,
                  child: Divider(
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    //this checks weather the word we have spoken matches with these two words or not...if matches it shows a tick icon or else a wrong icon
                    child: lastWords=='वर्णमाला '||lastWords=='समय '? Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24.0,
                    ) : Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 24.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    //this checks weather the word we have spoken matches with these two words or not...if matches it shows a tick icon or else a wrong icon
                    child: Text(
                      "try speaking   'वर्णमाला'   or   'समय'"
                    ),
                  ),
                ),
                Center(
                  //prints if there is any error ...with the error code
                  child: Text(lastError),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
                  : Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
  }

//the functions running our appm are defined here!
  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} "
      //we need to check the validsation of a word so we only print the word
//          "- ${result.finalResult}"
      ;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

//this function is disabled as we hardcoded the language as hindi
  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
 }