import 'package:art_gallery/data/models/image_model.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageRemoteDataSource {
  Future<List<ImageModel>> getImages();
  Future<void> uploadImage();
}

class FirebaseImageRemoteDataSource implements ImageRemoteDataSource {
  final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/');

  @override
  Future<List<ImageModel>> getImages() async {
    final modelList = <ImageModel>[];

    final listResults = await firebaseStorageRef.listAll();

    for (var i = 0; i < listResults.items.length; i++) {
      final downloadUrl = await listResults.items[i].getDownloadURL();
      print('downloadUrl $downloadUrl');

      modelList.add(
        ImageModel(
          name: listResults.items[i].name,
          downloadUrl: downloadUrl,
        ),
      );
    }

    print('modelList $modelList');
    return modelList;
  }

  @override
  Future<double> uploadImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    var progress = 0.0;

    if (result != null) {
      final uploadFile = result.files.single.bytes!;

      final firebaseStorage = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');

      final uploadTask = firebaseStorage.putData(
        uploadFile,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      uploadTask.snapshotEvents.listen((event) {
        progress =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                    100)
                .roundToDouble();
      });

      print('progress $progress');

      return progress;
    } else {
      return 0.0;
      // User canceled the picker
    }
  }
}
