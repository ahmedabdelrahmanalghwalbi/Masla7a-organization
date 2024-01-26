import 'package:flutter/widgets.dart';

class CategoryID with ChangeNotifier {
  var categoryID = '';

  updateCatID(String catID) {
    this.categoryID = catID;

    notifyListeners();
  }
}
