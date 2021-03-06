import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/note_provider.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:flutter_notes/utils/constants.dart';
import 'package:flutter_notes/widgets/delete_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

import 'note_view_screen.dart';

class NoteEditScreen extends StatefulWidget {
  static const route = '/edit-note';

  NoteEditScreen({this.selectedNote});

  final Note selectedNote;

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File _image;

  // String _currentAddress;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.selectedNote != null) {
      titleController.text = widget.selectedNote.title;
      contentController.text = widget.selectedNote.content;

      if (widget.selectedNote.imagePath != null) {
        _image = File(widget.selectedNote.imagePath);
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            color: black,
            onPressed: () {
              getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.insert_photo),
            color: black,
            onPressed: () {
              getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: black,
            onPressed: () {
              if (widget.selectedNote?.id != null) {
                _showDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                    hintText: 'Escreva o t??tulo da nota',
                    border: InputBorder.none),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: 'Escreva algo...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.isEmpty)
            titleController.text = 'Nota sem t??tulo';

          saveNote();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');

    setState(() {
      _image = tmpFile;
    });
  }

  void saveNote() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    String imagePath = _image != null ? _image.path : null;

    if (widget.selectedNote?.id != null) {
      Provider.of<NoteProvider>(
        this.context,
        listen: false,
      ).addOrUpdateNote(
          widget.selectedNote?.id, title, content, imagePath, EditMode.UPDATE);
      //Navigator.of(this.context).pop();
      Navigator.of(this.context).pushReplacementNamed(
        '/',
      );
    } else {
      // int id = DateTime.now().millisecondsSinceEpoch;
      content += "\n\n" + (await getUserLocation());

      await Provider.of<NoteProvider>(this.context, listen: false)
          .addOrUpdateNote(
              widget.selectedNote?.id, title, content, imagePath, EditMode.ADD);

      Navigator.of(this.context).pushReplacementNamed(
        '/',
      );
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(widget.selectedNote);
        });
  }

  Future<String> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine;
  }
}
