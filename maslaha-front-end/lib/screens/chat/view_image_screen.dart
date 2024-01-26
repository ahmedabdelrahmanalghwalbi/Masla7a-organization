import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageScreen extends StatelessWidget {
  static const routeName = '/image-view';

  const ViewImageScreen({required this.image, required this.receiveTime});
  final ImageProvider<Object> image;
  final String receiveTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          title: Text('Image sent at $receiveTime')),
      body: PhotoView(
        imageProvider: image,
      ),
    );
  }
}
