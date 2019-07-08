import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class StorageProvider {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getImageFilePath() {
    try {
       return FilePicker.getFilePath(type: FileType.IMAGE);
    } catch (e) {
      print("Error while picking the file: " + e.toString());
      throw e;
    }
  }

  Future<dynamic> getImageDownloadUrlFromStorage(String collectionReference, String docID)   {
    final StorageReference ref = _storage.ref().child(collectionReference).child(docID).child("1");

    return ref.getDownloadURL();

  }
  

  Future<void> uploadImageToStorageRef(String filePath, String collectionReference, String docID) {

    final StorageReference ref = _storage.ref().child(collectionReference).child(docID).child("1");

    final File file = File(filePath);

    final StorageUploadTask uploadTask = ref.putFile(
        file,
        StorageMetadata(
          contentType: "image/*",
        )
    );

    return uploadTask.onComplete; // This returns the download URL
  }

}