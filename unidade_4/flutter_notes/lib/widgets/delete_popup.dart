import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/note_provider.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:provider/provider.dart';

class DeletePopUp extends StatelessWidget {
  final Note selectedNote;

  DeletePopUp(this.selectedNote);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Deletar?'),
      content: Text('Você deseja realmente deletar a nota?'),
      actions: [
        TextButton(
          child: Text('Sim'),
          onPressed: () {
            Provider.of<NoteProvider>(context, listen: false)
                .deleteNote(selectedNote.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        TextButton(
          child: Text('Não'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
