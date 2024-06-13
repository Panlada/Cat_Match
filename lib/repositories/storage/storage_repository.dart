import 'dart:io';

import '/repositories/database/database_repository.dart';
import '/repositories/storage/base_storage_reporsitory.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '/models/models.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // upload image to firebase storage
  @override
  Future<void> uploadImage(User user, XFile image) async {
    try {
      await storage
          .ref('${user.id}/${image.name}')
          .putFile(
            File(image.path),
          )
          .then(
            (p0) => DatabaseRepository().updateUserPictures(user, image.name),
          );
    } catch (_) {}
  }
  // upload image to firebase storage

  // delete image from firebase storage
  @override
  Future<void> deleteImage(User user, String imageUrl) async {
    // Extract the path of the file from the URL
    String fileName = getFileNameFromUrl(imageUrl);
    bool imageExiest = await checkIfImageExists(user.id, fileName);

    try {
      firebase_storage.Reference imageReference =
          storage.ref('${user.id}/').child(fileName);

      DatabaseRepository().deleteUserPicture(user, imageReference.name);

      if (imageExiest) {
        await imageReference.delete();
      }
    } catch (_) {}
  }
  // delete image from firebase storage

  // get download url from firebase store image
  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL =
        await storage.ref('${user.id}/$imageName').getDownloadURL();

    return downloadURL;
  }
  // get download url from firebase store image

  // helper: filename parser
  String getFileNameFromUrl(String imageUrl) {
    Uri uri = Uri.parse(imageUrl);
    String path = uri.path;
    // Decode the URI-encoded path to handle special characters correctly
    path = Uri.decodeComponent(path);
    List<String> pathSegments = path.split('/');
    String lastSegment = pathSegments.last;
    // If the last segment contains a query parameter, split it to remove the query part
    if (lastSegment.contains('?')) {
      return lastSegment.split('?').first;
    }
    return lastSegment;
  }
  // helper: filename parser

  // helper: image exist or not
  Future<bool> checkIfImageExists(String? userId, String fileName) async {
    try {
      final ref = storage.ref('$userId/').child(fileName);
      final result = await ref.getMetadata();
      // ignore: unnecessary_null_comparison
      return result != null; // If result is not null, image exists
    } catch (e) {
      return false; // Image doesn't exist or error occurred
    }
  }
  // helper: image exist or not
}
