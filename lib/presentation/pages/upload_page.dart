import 'package:art_gallery/presentation/controllers/image_controller.dart';
import 'package:art_gallery/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final imagesController = Get.find<ImageController>();

  var imageName = '';
  var artistName = '';

  @override
  Widget build(BuildContext context) {
    var isFieldsValid = imageName.isNotEmpty && artistName.isNotEmpty;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: InkWell(
            onTap: () => Get.off(HomePage()),
            child: Image.asset(
              'assets/images/logo.png',
              height: 260.h,
              fit: BoxFit.cover,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Obx(
                () => imagesController.progress.value == 0
                    ? Container()
                    : LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        width: 0.8.sw,
                        lineHeight: 6.0,
                        percent: imagesController.progress.value / 100,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue[800],
                      ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Image name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => imageName = val),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Artist name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => artistName = val),
              ),
              SizedBox(
                height: 0.15.sh,
                width: 0.5.sw,
                child: ElevatedButton(
                  onPressed: !isFieldsValid
                      ? null
                      : () {
                          imagesController.uploadImage(
                            imageName: imageName,
                            artistName: artistName,
                          );
                        },
                  child: Icon(
                    Icons.upload,
                    size: 60.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
