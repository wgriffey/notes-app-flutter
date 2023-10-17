import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practiceapp/constants/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String noteText;

  CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.noteText});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        noteText = snapshot.data()[noteTextFieldName] as String;
}
