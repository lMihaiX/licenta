import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addpost.dart';
import 'editpost.dart';

class posts extends StatefulWidget {
  final DocumentSnapshot doc;
  posts({required this.doc});
  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {
  DateFormat _format = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => addnote(
                        doc: widget.doc,
                      )));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text('Postări'),
      ),
      body: StreamBuilder(
        stream: widget.doc.reference.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.docs.length == 0
              ? Center(
                  child: Text(
                    'Nu s-au găsit postări',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        key: UniqueKey(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  editnote(doc: snapshot.data!.docs[index]),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 3,
                                right: 3,
                              ),
                              child: ListTile(
                                trailing: SizedBox(
                                  height: 50,
                                  child: Column(children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return editnote(
                                              doc: snapshot.data!.docs[index]);
                                        }));
                                      },
                                      child: Icon(Icons.edit),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Sigur vrei să ștergi această postare?'),
                                                actions: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Anulare'), //No
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .delete()
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text('Șterge'), //yes
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Icon(Icons.delete),
                                    ),
                                  ]),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(_format.format(DateTime.parse(
                                    snapshot
                                        .data!.docChanges[index].doc['date']))),
                                title: Text(
                                  snapshot.data!.docChanges[index].doc['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
