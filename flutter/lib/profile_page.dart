import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool dashBoardMode = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(220, 220, 220, 1),
                // boxShadow: [
                //   BoxShadow(
                //       color: Color.fromARGB(40, 0, 0, 0), offset: Offset(0, 1)),
                //   BoxShadow(
                //     color: Color.fromRGBO(239, 239, 239, 1),
                //     spreadRadius: -2.0,
                //     blurRadius: 5.0,
                //   ),
                // ],
              ),
              // padding: const EdgeInsets.all(25),
              child: Column(children: [
                const SizedBox(height: 25),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
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
                          offset: Offset(0, 1))
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.cyan
                              // image: DecorationImage(
                              //   image: AssetImage('assets/images/profile.jpg'),
                              //   fit: BoxFit.fill,
                              // ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UserName",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Biography",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dashBoardMode = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.06),
                        backgroundColor: dashBoardMode
                            ? const Color.fromARGB(100, 255, 255, 255)
                            : Colors.white,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)))),
                    child: const Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dashBoardMode = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.06),
                        backgroundColor: dashBoardMode
                            ? Colors.white
                            : const Color.fromARGB(127, 255, 255, 255),
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)))),
                    child: const Text(
                      'My Posts',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ]),
              ]))
        ],
      ),
    );
  }
}
