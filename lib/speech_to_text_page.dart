import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";
  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() => _isAvailable = result));
    _speechRecognition.setRecognitionStartedHandler(
        () => setState(() => _isListening = true));
    _speechRecognition.setRecognitionResultHandler(
        (String speech) => setState(() => resultText = speech));
    _speechRecognition.setRecognitionCompleteHandler(
        () => setState(() => _isListening = false));
    _speechRecognition
        .activate()
        .then((result) => setState(() => _isAvailable = result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                    mini: true, child: Icon(Icons.cancel), onPressed: () {
                      if (_isListening) {
                        _speechRecognition.cancel().then((result)=>setState((){
                          _isListening = result;
                          resultText = "";
                        }));
                      }
                    }),
                FloatingActionButton(
                    child: Icon(Icons.mic),
                    onPressed: () {
                      if (_isAvailable && !_isListening) {
                        _speechRecognition
                            .listen(locale: "en_US")
                            .then((result) => print(result));
                      }
                    }),
                FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.stop),
                    onPressed: () {
                      if (_isListening) {
                        _speechRecognition.stop().then(
                            (result) => setState(() => 
                            _isListening = result));
                      }
                    }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black45),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(resultText),
              ),
            )
          ],
        ),
      ),
    );
  }
}
