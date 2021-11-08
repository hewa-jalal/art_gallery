import 'package:art_gallery/data/datasources/image_remote_data_source.dart';
import 'package:art_gallery/data/repositories/image_repository_firebase.dart';
import 'package:art_gallery/home_page.dart';
import 'package:art_gallery/presentation/controllers/image_controller.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final slidesController = Get.put(ImageController(
    imageRepository: ImageFirebaseRepository(
      imageRemoteDataSource: FirebaseImageRemoteDataSource(),
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
