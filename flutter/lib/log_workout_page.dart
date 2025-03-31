import 'package:flutter/material.dart';

final List<String> list = <String>['pee', 'poo'];

class LogWorkoutPage extends StatefulWidget {
  const LogWorkoutPage({super.key});

  @override
  LogWorkoutPageState createState() => LogWorkoutPageState();
}

class LogWorkoutPageState extends State<LogWorkoutPage> {
  String dropdownValue = list.first;
  Widget buildExerciseField() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: DefaultSelectionStyle.defaultColor),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              spreadRadius: 1.0,
              blurRadius: 4.0,
              offset: Offset(0, 0))
        ],
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //     color: const Color.fromARGB(255, 223, 223, 223), width: 1)
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a caption...',
              ),
            ),
          ),
          Row(children: [
            const SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
                // icon: const Icon(Icons.arrow_drop_down_outlined),
                borderRadius: BorderRadius.circular(10),
                value: dropdownValue,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
            const SizedBox(
              width: 10,
            ),
            const Text('Exercise: '),
          ]),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a caption...',
              ),
            ),
          ),
          Row(children: [
            SizedBox(width: 10),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete'))
          ]),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Row(
          //   children: [
          //     IconButton(
          //         onPressed: () {},
          //         icon: const Icon(Icons.add_photo_alternate_outlined)),
          //   ],
          // ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a caption...',
              ),
            ),
          ),
          const Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 20),
          buildExerciseField()
        ],
      ),
    );
  }
}
