import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb/common/widgets/custom_widget.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ShowBigPhotosWidget {
  static showImages(
    BuildContext context, {
    required List<String> images,
    int currentIndex = 0,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (context) {
          return ShowBigPhoto(images: images, currentIndex: currentIndex);
        });
  }
}

class ShowBigPhoto extends StatefulWidget {
  final List<String> images;
  final int currentIndex;

  const ShowBigPhoto({
    super.key,
    required this.images,
    this.currentIndex = 0,
  });

  @override
  State<ShowBigPhoto> createState() => _ShowBigPhotoState();
}

class _ShowBigPhotoState extends State<ShowBigPhoto> {
  PageController? pageController;

  int _index = 0;

  @override
  void initState() {
    _index = widget.currentIndex;
    pageController = PageController(initialPage: _index);
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            (widget.images.isNotEmpty)
                ? PhotoViewGallery.builder(
                    pageController: pageController,
                    gaplessPlayback: true,
                    wantKeepAlive: true,
                    onPageChanged: _onPageChanged,
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                    itemCount: widget.images.length,
                    builder: (context, index) {
                      return widget.images[index].startsWith('http')
                          ? PhotoViewGalleryPageOptions(
                              imageProvider: 
                              NetworkImage(
                                widget.images[index],
                              ),
                              initialScale: PhotoViewComputedScale.contained,
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.contained * 2,
                            )
                          : widget.images[index].startsWith('asset')
                              ? PhotoViewGalleryPageOptions(
                                  imageProvider:
                                      AssetImage(widget.images[index]),
                                  initialScale:
                                      PhotoViewComputedScale.contained,
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 2,
                                )
                              : widget.images[index].startsWith('file')
                                  ? PhotoViewGalleryPageOptions(
                                      imageProvider: FileImage(
                                          File(widget.images[index])),
                                      initialScale:
                                          PhotoViewComputedScale.contained,
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale:
                                          PhotoViewComputedScale.contained * 2,
                                    )
                                  : PhotoViewGalleryPageOptions(
                                      imageProvider: null);
                    },
                    loadingBuilder: (context, event) => Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )),
                  )
                : Container(),
            Positioned(
              top: 15,
              right: 15,
              child: SafeArea(
                child: ClipOval(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            widget.images.length > 1
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: SimpleText(
                      text: '${_index + 1} / ${widget.images.length}',
                      textColor: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _onPageChanged(int index) {
    setState(() {
      _index = index;
    });
  }
}
