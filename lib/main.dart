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

//stateful widget since we are
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
  int _hoveredIndex = -1; //hold

  double _rabbitOpacity = 0.0;
  List<bool> clickedContainers = List.generate(
      9, (index) => false); //tracks clicked ou pas pour l'animation

  void _randomizeLeLapinou() {
    rabbitPosition = Random().nextInt(9);
  }

  void _incrementCounter() {
    setState(() {
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
              //use item builder to create a mouse region
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
                          //snackbar
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Ta trouver le lapinou woohoo !'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ));
                          //animate le lapinou
                          _rabbitOpacity = 1.0;
                          //buncha code to animate the rabbit easing in n out
                          Future.delayed(Duration(seconds: 1), () {
                            //hide rabbit icon after 1s
                            _rabbitOpacity = 0.0;
                            _randomizeLeLapinou();
                            //reset list
                            clickedContainers =
                                List.generate(9, (index) => false);
                          });
                        } else {
                          clickedContainers[index] = true;
                          print(clickedContainers);
                          attempts++;
                        }
                      });
                    },
                    child: Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.all(8.0),
                        color: index == _hoveredIndex
                            ? Colors.red[100] //if we hovering then red
                            : clickedContainers[
                                    index] //else if clickedContainer
                                ? Colors.yellow[100] //then yellow
                                : Colors.blue[100], // else standar d blue
                        //if showRabbit bool is true and index on rabbit show the rabbit
                        child: Center(
                          child: showRabbit && index == rabbitPosition
                              ? RabbitIcon(opacity: showRabbit ? 1 : _rabbitOpacity) //if we are allowed to show the rabbit then
                              : clickedContainers[index]
                                  ? sadEmoji()
                                  : null,
                        ),
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
                onPressed: () {
                  setState(() {
                    attempts = 0;
                    found = 0;
                  });
                },
                child: Text("Reset counter"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showRabbit = !showRabbit;
                  });
                },
                child: Text("show solution"),
              ),
            ],
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

class RabbitIcon extends StatelessWidget {
  final double opacity;

  RabbitIcon({required this.opacity});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 300),
      child: Icon(
        Icons.pets,
        size: 50,
        color: Colors.lightGreen,
      ),
    );
  }
}

class sadEmoji extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Icon(
      Icons.sentiment_dissatisfied,
      size: 50.0,
      color: Colors.red,
    );
  }
}
