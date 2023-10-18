import 'package:flutter/material.dart';
import 'package:practiceapp/services/auth/auth_service.dart';
import 'package:practiceapp/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:practiceapp/utilities/generics/get_arguments.dart';
import 'package:practiceapp/services/cloud/firebase_cloud_storage.dart';
import 'package:practiceapp/services/cloud/cloud_note.dart';
import 'package:practiceapp/services/cloud/cloud_storage_exceptions.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _firebaseCloudStorage;
  late final TextEditingController _textEditingController;

  Future<CloudNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.noteText;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final newNote =
        await _firebaseCloudStorage.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _firebaseCloudStorage.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;

    if (note != null && text.isNotEmpty) {
      await _firebaseCloudStorage.updateNote(
        documentId: note.documentId,
        noteText: text,
      );
    }
  }

  void _textEditingControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _firebaseCloudStorage.updateNote(
        documentId: note.documentId, noteText: text);
  }

  void __setupTextEditingControllerListener() {
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.addListener(_textEditingControllerListener);
  }

  @override
  void initState() {
    _firebaseCloudStorage = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.getArgument<CloudNote>() == null
            ? const Text('New Note')
            : const Text('Update Note'),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              if (_note == null || text.isEmpty){
                await showCannotShareEmptyNoteDialog(context);
              } else{
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              __setupTextEditingControllerListener();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'Write Note Here...',
                    hintStyle: TextStyle(
                      color: Colors.red,
                    )),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
