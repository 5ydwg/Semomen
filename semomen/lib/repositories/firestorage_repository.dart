import 'package:firebase_storage/firebase_storage.dart';

class FirestorageRepository {
  void uploadImageFile(_uid, file) async {
    final ref =
        FirebaseStorage.instance.ref().child('image/profile_img/' + _uid);

    await ref.putFile(file);
  }
}
