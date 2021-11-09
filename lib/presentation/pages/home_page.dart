import 'package:art_gallery/domain/entities/image_entity.dart';
import 'package:art_gallery/presentation/controllers/image_controller.dart';
import 'package:art_gallery/presentation/pages/upload_page.dart';
import 'package:art_gallery/presentation/pages/view_all_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagesController = Get.find<ImageController>();
  var query = '';
  List<ImageEntity> searchImagesList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    setState(() {
      this.searchImagesList = imagesController.imageList;
    });
  }

  void searchMember(String query) {
    final searchedMembers = imagesController.imageList.where((image) {
      final imageLower = image.name.toLowerCase();
      final searchLower = query.toLowerCase();

      return imageLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.searchImagesList = searchedMembers;
    });
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search for an image',
        onChanged: searchMember,
      );

  @override
  Widget build(BuildContext context) {
    final imageList = imagesController.imageList;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Image.asset(
            'assets/images/logo.png',
            height: 260.h,
            fit: BoxFit.cover,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => Get.to(UploadPage()),
              child: Text('Upload Image'),
            ),
            TextButton(
              onPressed: () => Get.to(ViewAllPage()),
              child: Text('View all'),
            ),
          ],
        ),
        body: Center(
          child: Obx(
            () => imageList.isEmpty
                ? CircularProgressIndicator()
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 0.8.sh,
                      autoPlay: true,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: imageList.map(
                      (element) {
                        return Image.network(
                          element.downloadUrl,
                        );
                      },
                    ).toList(),
                  ),

            // : CarouselSlider(
            //     options: CarouselOptions(
            //       height: 0.8.sh,
            //       autoPlay: true,
            //       viewportFraction: 1,
            //       scrollDirection: Axis.horizontal,
            //     ),
            //     items: imageList.map((element) {
            //       return Center(
            //         child: GridView.count(
            //           shrinkWrap: true,
            //           crossAxisCount: 2,
            //           scrollDirection: Axis.horizontal,
            //           children: imageList.map(
            //             (element) {
            //               return Image.network(
            //                 element.downloadUrl,
            //                 fit: BoxFit.fill,
            //                 alignment: Alignment.center,
            //               );
            //             },
            //           ).toList(),
            //         ),
            //       );
            //     }).toList(),
            //   ),

            // CarouselSlider(
            //     options: CarouselOptions(
            //       height: 0.8.sh,
            //       autoPlay: true,
            //       viewportFraction: 1,
            //       scrollDirection: Axis.horizontal,
            //     ),
            //     items: imageList
            //         .map(
            //           (element) => StaggeredGridView.countBuilder(
            //             crossAxisCount: 4,
            //             itemCount: imageList.length,
            //             itemBuilder: (context, index) {
            //               final image = searchImagesList[index];
            //               return HoverWidget(
            //                 onHover: (p) {},
            //                 child: Image.network(
            //                   image.downloadUrl,
            //                   fit: BoxFit.fill,
            //                 ),
            //                 hoverChild: Stack(
            //                   children: [
            //                     Positioned.fill(
            //                       child: Image.network(
            //                         image.downloadUrl,
            //                         fit: BoxFit.fill,
            //                       ),
            //                     ),
            //                     Container(
            //                       color: Colors.black.withOpacity(0.45),
            //                     ),
            //                     Positioned.fill(
            //                       child: Center(
            //                         child: Text(
            //                           image.name,
            //                           style: TextStyle(
            //                             fontSize: 34.sp,
            //                             color: Colors.white,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               );
            //             },
            //             staggeredTileBuilder: (index) =>
            //                 StaggeredTile.count(1, 1),
            //             mainAxisSpacing: 4.0,
            //             crossAxisSpacing: 4.0,
            //           ),
            //         )
            //         .toList(),
            //   ),
          ),
        ),
      ),
    );
  }
}

class CustomGridWidget extends StatelessWidget {
  const CustomGridWidget({
    Key? key,
    required this.imageList,
    required this.searchImagesList,
  }) : super(key: key);

  final RxList<ImageEntity> imageList;
  final List<ImageEntity> searchImagesList;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 4,
      itemBuilder: (context, index) {
        final image = searchImagesList[index];
        return HoverWidget(
          onHover: (p) {},
          child: Image.network(
            image.downloadUrl,
            fit: BoxFit.fill,
          ),
          hoverChild: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  image.downloadUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.45),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    image.name,
                    style: TextStyle(
                      fontSize: 34.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  final String hintText;
  final ValueChanged<String> onChanged;
  final String text;

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 52,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 9, bottom: 9),
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class AnimSearchWidget extends StatefulWidget {
  @override
  _AnimSearchWidgetState createState() => _AnimSearchWidgetState();
}

int toggle = 0;

class _AnimSearchWidgetState extends State<AnimSearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _con;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _con = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 375),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF2F3F7),
        child: Center(
          child: Container(
            height: 100.0,
            width: 250.0,
            alignment: Alignment(-1.0, 0.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 375),
              height: 48.0,
              width: (toggle == 0) ? 48.0 : 250.0,
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: -10.0,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 375),
                    top: 6.0,
                    right: 7.0,
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: (toggle == 0) ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F3F7),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: AnimatedBuilder(
                          child: Icon(
                            Icons.mic,
                            size: 20.0,
                          ),
                          builder: (context, widget) {
                            return Transform.rotate(
                              angle: _con.value * 2.0 * pi,
                              child: widget,
                            );
                          },
                          animation: _con,
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 375),
                    left: (toggle == 0) ? 20.0 : 40.0,
                    curve: Curves.easeOut,
                    top: 11.0,
                    child: AnimatedOpacity(
                      opacity: (toggle == 0) ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        height: 23.0,
                        width: 180.0,
                        child: TextField(
                          controller: _textEditingController,
                          cursorRadius: Radius.circular(10.0),
                          cursorWidth: 2.0,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Search...',
                            labelStyle: TextStyle(
                              color: Color(0xff5B5B5B),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    child: IconButton(
                      splashRadius: 19.0,
                      icon: Image.network(
                        'https://www.flaticon.com/svg/static/icons/svg/709/709592.svg',
                        height: 18.0,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (toggle == 0) {
                              toggle = 1;
                              _con.forward();
                            } else {
                              toggle = 0;
                              _textEditingController.clear();
                              _con.reverse();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
