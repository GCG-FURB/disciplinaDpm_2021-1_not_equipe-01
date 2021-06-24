import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notes/helper/database_helper.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:flutter_notes/utils/constants.dart';

class NoteProvider with ChangeNotifier {
  Note note;
  var _items = <Note>[];

  List<Note> get items => _items;

  Future<Note> getNote(String id) async {
/*    print("entrei em getNote");
    final item  = note.firestore.doc(id as String);
    print("getNote");
    print(item);
    return _items.firstWhere((note) => note.id == id, orElse: () => null);*/
    final snapshot = await FirebaseFirestore.instance
        .collection('notes')
        .doc(id.toString())
        .get();
    return Note.fromDocument(snapshot, id.toString());
    //return Note.fromMap(snapshot.data());
  }

  Future<void> deleteNote(String id) async {
    print("deleteNote");
    //note.deleteItem(id);
    DocumentReference documentReferencer =
        FirebaseFirestore.instance.collection('notes').doc(id);

    await documentReferencer.delete().whenComplete(() {
      print('Note item deleted from the database');
      getNotes();
    }).catchError((e) => print(e));
  }

  Future addOrUpdateNote(String id, String title, String content,
      String imagePath, EditMode editMode) async {
    note = Note(id: id, title: title, content: content, imagePath: imagePath, date: DateTime.now().toString());
    await note.save();
    notifyListeners();
    getNotes();
  }

  Future<void> getNotes() async {
    final snapshot = await FirebaseFirestore.instance.collection('notes').get();

    _items = List<Note>.from(
            snapshot.docs.map((notes) => Note.fromMap(notes.data(), notes.id)))
        .toList();

    notifyListeners();
  }
}
