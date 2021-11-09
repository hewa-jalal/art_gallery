import 'package:art_gallery/core/failures/failures.dart';
import 'package:art_gallery/data/models/image_model.dart';
import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:art_gallery/domain/repositories/image_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  final ImageRepository imageRepository;

  var imageList = <ImageEntity>[].obs;
  var progress = 0.0.obs;

  @override
  void onInit() {
    print('controller init');
    getImages();
    super.onInit();
  }

  ImageController({required this.imageRepository});

  void getImages() async {
    var either = await imageRepository.getImages();
    either.fold(
      (failure) => ServerFailure(),
      (images) {
        imageList.value = images;
      },
    );
  }

  void uploadImage({
    required String imageName,
    required String artistName,
  }) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final firestore = FirebaseFirestore.instance;

    if (result != null) {
      final uploadFile = result.files.single.bytes!;

      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('images/${result.files.single.name}');

      final uploadTask = firebaseStorageRef.putData(
        uploadFile,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      uploadTask.whenComplete(() async {
        final downUrl = await firebaseStorageRef.getDownloadURL();

        final imageModel = ImageModel(
          // name: result.files.single.name,
          name: imageName,
          artistName: artistName,
          downloadUrl: downUrl,
        );

        firestore.collection('images').add(imageModel.toJson());
        // to make the upload bar dissapear again
        progress.value = 0;

        // to refresh the images
        getImages();
      });

      uploadTask.snapshotEvents.listen((event) {
        progress.value =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                    100)
                .roundToDouble();
      });
    } else {
      // User canceled the picker
    }
  }
}
