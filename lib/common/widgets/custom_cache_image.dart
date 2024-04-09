import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/values/assets/photos.dart';

class CustomCacheImage extends StatelessWidget {
  final String? imageUrl;
  final bool isCircle;
  final double radius;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final bool isHeader;
  final String headerImagePath;
  final String? errorImagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double resize;
  final Color? color;
  final BoxBorder? boxBorder;
  final ExtendedImageMode? extendedImageMode;
  final BorderRadius? borderRadius;
  final Function()? onTap;

  const CustomCacheImage({
    super.key,
    this.imageUrl,
    this.isCircle = false,
    this.radius = 0,
    this.borderRadius,
    this.errorImagePath,
    this.isHeader = false,
    this.headerImagePath = gbImages.default_avatar,
    this.placeHolder,
    this.errorWidget,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.boxBorder,
    this.extendedImageMode,
    this.resize = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCacheImageField(),
    );
  }

  Widget? loadStateChanged(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (placeHolder != null) {
          return placeHolder!;
        } else if (isHeader) {
          return getAssetsImage(
            headerImagePath,
            fit,
            width: width,
            height: height,
          );
        } else {
          return const SizedBox.shrink();
        }
      case LoadState.completed:
        return state.completedWidget;
      case LoadState.failed:
        if (errorWidget != null) {
          return errorWidget!;
        } else if (isHeader) {
          return getAssetsImage(headerImagePath, BoxFit.contain,
              width: width, height: height);
        } else if (errorImagePath != null) {
          return getAssetsImage(errorImagePath!, BoxFit.contain,
              width: width, height: height);
        } else {
          return getImagePlaceHolder();
        }
    }
  }

  Widget _buildCacheImageField() {
    final String fullImageUrl =
        (imageUrl != null && resize > 0 ? "$imageUrl?w=$resize" : imageUrl) ??
            '';
    BorderRadius? borderRadius =
        radius != 0 ? BorderRadius.all(Radius.circular(radius)) : null;
    if (fullImageUrl.isNotEmpty) {
      if (fullImageUrl.startsWith("http")) {
        return ExtendedImage.network(
          fullImageUrl,
          borderRadius: this.borderRadius ?? borderRadius,
          enableLoadState: true,
          loadStateChanged: loadStateChanged,
          height: height,
          width: width,
          fit: fit,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          border: boxBorder,
          mode: extendedImageMode ?? ExtendedImageMode.none,
          cache: true,
        );
      } else if (fullImageUrl.contains('assets/images/')) {
        return ExtendedImage.asset(
          fullImageUrl,
          borderRadius: this.borderRadius ?? borderRadius,
          enableLoadState: true,
          loadStateChanged: loadStateChanged,
          height: height,
          width: width,
          color: color,
          border: boxBorder,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          fit: fit,
        );
      } else {
        return ExtendedImage.file(
          File(fullImageUrl),
          borderRadius: this.borderRadius ?? borderRadius,
          enableLoadState: true,
          loadStateChanged: loadStateChanged,
          height: height,
          width: width,
          border: boxBorder,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          fit: fit,
        );
      }
    } else {
      if (isHeader) {
        return getAssetsImage(
          headerImagePath,
          BoxFit.contain,
          width: width,
          height: height,
        );
      } else {
        return getImagePlaceHolder();
      }
    }
  }

  Image getFileImage(File file, BoxFit boxFit) {
    return Image.file(file, fit: boxFit);
  }

  Image getAssetsImage(String imageName, BoxFit fit, {width, height, color}) {
    return Image.asset(
      imageName,
      fit: fit,
      width: width,
      height: height,
      color: color,
    );
  }

  getImagePlaceHolder() {
    return SizedBox(
        // color: Colors.grey[300],
        width: width ?? 50,
        height: height ?? 50,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          width: 50,
          height: 50,
          child: const Icon(
            Icons.question_mark,
          ),
        ));
  }
}
