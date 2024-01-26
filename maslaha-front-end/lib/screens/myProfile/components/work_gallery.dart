import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class MyWorkGallery extends StatefulWidget {
  List gallery;
  MyWorkGallery({required this.gallery});
  @override
  _MyWorkGalleryState createState() => _MyWorkGalleryState();
}

class _MyWorkGalleryState extends State<MyWorkGallery> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: getProportionateScreenWidth(350),
        height: getProportionateScreenHeight(180),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Gallery',
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: .8),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View all >",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(12),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: .8),
                  ),
                ),
              ],
            ),
            Container(
              width: getProportionateScreenWidth(350),
              height: getProportionateScreenHeight(100),
              child: widget.gallery.length != 0
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.gallery.map((image) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(10)),
                          child: Container(
                            width: getProportionateScreenWidth(120),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      }).toList())
                  : Center(
                      child: Text(
                        "No gallery photos yet ...!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
