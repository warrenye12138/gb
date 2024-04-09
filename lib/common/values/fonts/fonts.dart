import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fonts {
  getfonts(String fontsName,double fontSize,{Color? color}) {
    switch (fontsName) {
      case 'LongCang':
        return GoogleFonts.longCang(fontSize: fontSize,textStyle: TextStyle(color:color));
      case 'MaShanZheng':
        return GoogleFonts.maShanZheng(fontSize: fontSize,textStyle: TextStyle(color:color));
      case 'ZCOOLKuaiLe':
        return GoogleFonts.zcoolKuaiLe(fontSize: fontSize,textStyle: TextStyle(color:color));
      case 'ZhiMangXing':
        return GoogleFonts.zhiMangXing(fontSize: fontSize,textStyle: TextStyle(color:color));
    }
  }
}
