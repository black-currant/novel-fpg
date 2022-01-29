import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ImagePage extends StatelessWidget {
  final String imageUrl;

  const ImagePage({Key? key, required this.imageUrl}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: ExtendedImage.network(
        imageUrl,
        fit: BoxFit.contain,
        //enableLoadState: false,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) {
          return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.black,
        ),
        body: _buildBody(context));
  }
}
