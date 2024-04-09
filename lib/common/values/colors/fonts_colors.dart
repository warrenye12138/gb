import 'package:flutter/material.dart';

class ThemeColors {
  Color? getColors(String color) {
    switch (color) {
      case 'White':
        return Colors.white;
      case 'MainBlue':
        return Colors.blue[200];
      case 'Deepblue':
        return Colors.blue[300];
      case 'HindGrey':
        return Colors.grey.withAlpha(80);
    }
    return null;
  }
}
