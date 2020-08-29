import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAI Command Model Trainer',
      debugShowCheckedModeBanner: false,
      home: TrainerStartScreen(),
    );
  }
}

class TrainerStartScreen extends StatefulWidget {
  @override
  _TrainerStartScreenState createState() => _TrainerStartScreenState();
}

Future<void> _showExitDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Exit Trainer ?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want close the trainer ?'),
              Text('Any progress made in training will be lost.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.green[900],
            child: Text('Yes'),
            onPressed: () {
              //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              // Currently this doesn't work with windows so using exit(0)
              exit(0);
            },
          ),
          FlatButton(
            color: Colors.green[900],
            child: Text('No, continue with training'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _TrainerStartScreenState extends State<TrainerStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        actions: [
          IconButton(
            tooltip: "Exit",
            hoverColor: Colors.red,
            splashRadius: 20.0,
            icon: Icon(Icons.close),
            onPressed: () {
              _showExitDialog(context);
            },
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: Container(
        color: Colors.green[900],
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150.0),
              Text(
                'CAI Commands Trainer',
                textScaleFactor: 6.0,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 150.0),
              OutlineButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' Begin Training Now ',
                      textScaleFactor: 1.5,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 30.0,
                    ),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => TrainingScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String status1 = 'Trainer Script is starting...';
  String status2 = '';
  String subStatus = '';
  double progressValue;

  void handleStdout(data) {
    if (data.toString().contains('CAI: TRAINER: H1: ')) {
      status1 = data.toString().substring(18);
      status2 = '';
      subStatus = '';
      //progressValue == null ? progressValue = 0.0 : progressValue += 0.2;
    }
    else if (data.toString().contains('CAI: TRAINER: H2: ')) {
      status2 = data.toString().substring(18);
    }
    else if (data.toString().contains('Listening for ')) {
      status1 = 'Speak ${data.toString().substring(14)}';
      status2 = '';
      subStatus = data;
    }
    else if (data.toString().contains('Listening again')) {
      status2 =  status2 + '& again...';
    }
    else subStatus = data;
    setState(() {});
  }

  void handleExit(exitCode) {
    status1 = (exitCode == 0) ? 'Training Complete !' : 'An unexpected error occured !';
    subStatus = '';
    progressValue = 1.0;
    setState(() {});
  }

  @override
  void initState() {
    Process.start('python', ['.\\scripts\\trainer.py'], workingDirectory: '.').then((process) {
      process.stdout.transform(utf8.decoder).listen((data) => handleStdout(data));
      process.exitCode.then((value) => handleExit(value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text(
          'CAI Commands Trainer',
          textScaleFactor: 1.5,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Exit",
            hoverColor: Colors.red,
            splashRadius: 20.0,
            icon: Icon(Icons.close),
            onPressed: () {
              _showExitDialog(context);
            },
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                status1,
                textScaleFactor: 2.0,
                style: TextStyle(
                  color: Colors.green[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              Flexible(
                child: Text(
                  status2,
                  textScaleFactor: 1.5,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                height: 10.0,
                width: 900.0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.green[900].withOpacity(0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]),
                  value: progressValue,
                ),
              ),
              SizedBox(height: 50),
              Flexible(
                child: Text(
                  subStatus,
                  textScaleFactor: 1.25,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
