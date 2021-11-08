import 'package:art_gallery/core/failures/failures.dart';
import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:art_gallery/domain/repositories/image_repository.dart';
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

  void uploadImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

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
