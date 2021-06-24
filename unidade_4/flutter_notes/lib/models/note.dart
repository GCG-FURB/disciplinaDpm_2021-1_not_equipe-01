import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Note extends ChangeNotifier {
  String id;
  final String title;
  final String content;
  final String imagePath;
  final String date;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  CollectionReference get _mainCollection => firestore.collection('notes');

  DocumentReference get firestoreRef => firestore.doc('notes/$id');

  Reference get storageRef => storage.ref().child('notes').child(id);

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Note({this.id, this.title, this.content, this.imagePath, this.date});

/*  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(id);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }*/

  /* factory Note.fromDocument(DocumentSnapshot document) {
    return Note(
        _id = document.id as int;
        _title = document['title'] as String;
        _content = document['content'] as String;
        _imagePath = document['imagePath'] as String;
    );
  } */

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
        id: id,
        title: map['title'] as String,
        content: map['content'] as String,
        imagePath: map['imagePath'] as String,
        date: map['date']);
  }

  factory Note.fromDocument(DocumentSnapshot doc, String id) {
    return Note(
        id: id,
        title: doc.data()['title'].toString(),
        content: doc.data()['content'].toString(),
        imagePath: doc.data()['imagePath'].toString(),
        date: doc.data()['date'].toString());
  }

  Future<void> deleteItem(id) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(id).collection('notes').doc(id);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'date': date
    };

    print(data);
    if (id == null) {
      final doc = await firestore.collection('notes').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
    loading = false;
  }

  @override
  String toString() {
    return 'Note{title: $title, content: $content, imagePath: $imagePath}';
  }
}
