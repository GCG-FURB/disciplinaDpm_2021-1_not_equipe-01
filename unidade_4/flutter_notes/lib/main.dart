import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/models/NoteController.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:flutter_notes/screens/note_view_screen.dart';
import 'package:provider/provider.dart';
import 'helper/note_provider.dart';
import 'screens/note_edit_screen.dart';
import 'screens/note_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: NoteProvider(),
      child: MaterialApp(
        title: "Flutter Notes",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => NoteListScreen(),
          NoteViewScreen.route: (context) {
            final note = ModalRoute.of(context).settings.arguments as Note;
            return NoteViewScreen(selectedNote: note);
          },
          NoteEditScreen.route: (context) {
            final note = ModalRoute.of(context).settings.arguments as Note;
            return NoteEditScreen(selectedNote: note);
          },
        },
      ),
    );
  }
}
