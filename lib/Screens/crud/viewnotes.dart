import 'package:flutter/material.dart';

import '../../constants.dart';

class ViewNote extends StatefulWidget {
  final notes;
  const ViewNote({super.key, this.notes});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('View Notes'),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(
                '${widget.notes['imageURL']}',
                width: double.infinity,
                height: 300,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.notes['title'],
                style: const TextStyle(
                    fontSize: 30,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.notes['note'],
                style: const TextStyle(fontSize: 25, color: Colors.black87),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
