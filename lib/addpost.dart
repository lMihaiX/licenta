import 'posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class addnote extends StatelessWidget {
  final DocumentSnapshot doc;
  addnote({required this.doc});
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              if (title.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Postarea nu poate fi goală'),
                  ),
                );
              } else {
                doc.reference.collection('posts').add({
                  'title': title.text,
                  'date': DateTime.now().toIso8601String()
                }).whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => posts(
                                doc: doc,
                              )));
                });
              }
            },
            child: Text(
              "Salvează",
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: title,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Postează',
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
