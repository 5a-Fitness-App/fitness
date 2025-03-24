import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                // color: Color.fromRGBO(239, 239, 239, 1),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(40, 0, 0, 0), offset: Offset(0, 1)),
                  BoxShadow(
                    color: Color.fromRGBO(239, 239, 239, 1),
                    spreadRadius: -2.0,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(40, 0, 0, 0),
                      spreadRadius: 1.0,
                      blurRadius: 5.0,
                      // offset: Offset(0, 1)
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Streak: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "You're on fire!",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CircularPercentIndicator(
                        animation: true,
                        radius: 70.0,
                        lineWidth: 15.0,
                        percent: 4 / 5,
                        center: const Text("${4 / 5 * 100}%\n daily goals met"),
                        backgroundColor:
                            const Color.fromRGBO(154, 197, 244, 0.4),
                        progressColor: const Color.fromRGBO(154, 197, 244, 1),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
