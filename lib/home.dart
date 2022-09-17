import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Screens/crud/editNites.dart';
import 'Screens/crud/viewnotes.dart';
import 'constants.dart';
import 'dart:io';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference noteRef = FirebaseFirestore.instance.collection('nodes');
  @override
  void initState() {
    getImagesAndFolderName();
    // TODO: implement initState
    super.initState();
  }

  File? file;

  var imagePicker = ImagePicker();
  pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      uploadFiles();
      setState(() => file = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);
      uploadFiles();
      setState(() => file = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  uploadFiles() async {
    if (file != null) {
      file = File(file!.path);
      var random = Random().nextInt(100000000);
      var nameImage = basename(file!.path);
      nameImage = '$random$nameImage';

      final storageRef =
          FirebaseStorage.instance.ref('images/part1/$nameImage');

      await storageRef.putFile(file!);

      var url = storageRef.getDownloadURL();

      print('$url');
    }
  }

  getImagesAndFolderName() async {
    var ref = await FirebaseStorage.instance
        .ref('images')
        .list(const ListOptions(maxResults: 2));
    for (var element in ref.items) {
      print(element.fullPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offNamedUntil('/welcome', (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
          backgroundColor: kPrimaryColor,
          title: const Text("my note"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed("addNodes");
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: noteRef
                .where(
                  'userID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) async {
                        await noteRef
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                        FirebaseStorage.instance
                            .refFromURL(snapshot.data!.docs[index]['imageURL']);
                      },
                      key: UniqueKey(),
                      child: ListNotes(
                        notes: snapshot.data!.docs[index],
                        docid: snapshot.data!.docs[index].id,
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final docid;
  final notes;
  const ListNotes({
    Key? key,
    this.docid,
    this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ViewNote(notes: notes);
          },
        ));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(flex: 1, child: Image.network(notes['imageURL'])),
            Expanded(
              flex: 3,
              child: ListTile(
                trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditNotes(
                          docid: docid,
                          list: notes,
                        ),
                      ));
                    },
                    icon: const Icon(Icons.edit)),
                title: Text("${notes['title']}"),
                subtitle: Text(
                  notes['note'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
