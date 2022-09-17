import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({Key? key, this.docid, this.list}) : super(key: key);
  final docid;
  final list;
  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  var title, node, imageURL;
  File? file;
  GlobalKey<FormState> k = GlobalKey<FormState>();
  CollectionReference notesRef = FirebaseFirestore.instance.collection('nodes');
  addNodes(BuildContext context) async {
    var form = k.currentState;
    if (file == null) {
      if (form!.validate()) {
        showLoading(context);
        form.save();
        await notesRef.doc(widget.docid).update({
          'title': title,
          'note': node,
        }).then((value) {
          Get.offNamedUntil('/home', (route) => false);
        }).catchError((onError) {
          print(onError);
        });
      }
    } else {
      if (form!.validate()) {
        showLoading(context);
        form.save();

        await ref.putFile(file!);
        imageURL = await ref.getDownloadURL();
        await notesRef.doc(widget.docid).update({
          'title': title,
          'note': node,
          'imageURL': imageURL,
        }).then((value) {
         Get.offNamedUntil('/home', (route) => false);
        }).catchError((onError) {
          print(onError);
        });
      }
      Navigator.of(context).popAndPushNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            addNodes(context);
          },
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Edit nodes"),
        ),
        body: Container(
          child: Column(children: [
            Form(
                key: k,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.list?["title"],
                      validator: (value) {
                        if (value!.length > 20) {
                          return 'Text must not exceed 20 characters';
                        }
                        if (value.length < 2) {
                          return 'The text must not be less than 2 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) => title = newValue,
                      maxLength: 20,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Title Node",
                          prefixIcon: Icon(Icons.title)),
                    ),
                    TextFormField(
                      initialValue: widget.list?["note"],
                      validator: (value) {
                        if (value!.length > 255) {
                          return 'Text must not exceed 255 characters';
                        }
                        if (value.length < 10) {
                          return 'The text must not be less than 10 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) => node = newValue,
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 255,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Title Node",
                          prefixIcon: Icon(Icons.note_add)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () {
                        showModa(context);
                      },
                      child: const Text("Edit photoe"),
                    )
                  ],
                ))
          ]),
        ));
  }

  Future<dynamic> showModa(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Container(
                    child: const Text(
                  "Edit image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    pickImage(context);
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(Icons.photo, size: 30),
                          SizedBox(
                            width: 20,
                          ),
                          Text("From Gallery", style: TextStyle(fontSize: 20)),
                        ],
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    pickImageCamera(context);
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "From Comera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                      )),
                ),
              )
            ]),
          );
        });
  }

  Future pickImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
      var rend = Random().nextInt(1000000);
      var imageName = '$rend${basename(image.path)}';
      ref = FirebaseStorage.instance.ref('images').child(imageName);
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  Future pickImageCamera(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      var rend = Random().nextInt(1000000);
      var imageName = '$rend${basename(image.path)}';
      ref = FirebaseStorage.instance.ref('images').child(imageName);
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  var ref;
}
