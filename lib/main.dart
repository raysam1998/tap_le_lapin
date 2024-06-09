import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tape le putain de lapin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  //gamestate variables
  int rabbitPosition = 4;
  int attempts = 0;
  int found = 0;
  bool showRabbit = true;
  bool _isHovered = false;
  int _hoveredIndex = -1;

  void _randomizeLeLapinou(){
    rabbitPosition = Random().nextInt(9);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap le rabbit"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //display the button grid
          Expanded(
              child: Container(
                width: 300,
                height: 300,
                child: GridView.builder(
                            //crossAxis of 3 to have a 3 x 3 grid
                            gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                //return gesture detector w the stylyzed aspect as return
                return MouseRegion(
                  onEnter: (event) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                    
                  },
                  onExit: (event) {
                    setState(() {
                      _hoveredIndex = -1;
                    });
                    
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (index == rabbitPosition) {
                          found++;
                          _randomizeLeLapinou();
                        } else {
                          attempts++;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.all(8.0),
                      color: index == _hoveredIndex ?  Colors.red[100] : Colors.blue[100],
                      //if showRabbit bool is true and index on rabbit show the rabbit
                      child: Center(
                        child: showRabbit && index == rabbitPosition
                            ? Icon(
                                Icons.pets,
                                size: 10.0,
                                color: Colors.lightGreenAccent,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
                            },
                          ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text("Tentatives :$attempts"),
              Text("Victoires :$found"),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed :() {
                  setState(() {
                    attempts = 0;
                    found = 0;
                  });
                },
                child: Text("Reset counter"),
                ),
                ElevatedButton(
                onPressed :() {
                  setState(() {
                    showRabbit = !showRabbit;
                  });
                },
                child: Text("toggle rabbit"),
                ),
            ],
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
