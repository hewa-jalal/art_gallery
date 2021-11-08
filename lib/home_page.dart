import 'package:art_gallery/presentation/controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagesController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(imagesController.progress.toString() + '%')),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload),
          onPressed: () {
            imagesController.uploadImage();
          },
        ),
        body: Column(
          children: [
            Obx(
              () => LinearPercentIndicator(
                width: MediaQuery.of(context).size.width,
                lineHeight: 6.0,
                percent: imagesController.progress.value / 100,
                backgroundColor: Colors.grey,
                progressColor: Colors.red,
              ),
            ),
            Obx(
              () => Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: imagesController.imageList.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imagesController.imageList[index].downloadUrl,
                      fit: BoxFit.fill,
                    );
                  },
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
