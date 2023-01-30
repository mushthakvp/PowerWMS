import 'package:flutter/material.dart';
import 'package:scanner/util/color_const.dart';

extension CustomTextStyle on TextStyle {
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w900);

  TextStyle get s10 => copyWith(fontSize: 10);

  TextStyle get s12 => copyWith(fontSize: 12);

  TextStyle get s13 => copyWith(fontSize: 13);

  TextStyle get s14 => copyWith(fontSize: 14);

  TextStyle get s15 => copyWith(fontSize: 15);

  TextStyle get s16 => copyWith(fontSize: 16);

  TextStyle get s42 => copyWith(fontSize: 42);

  TextStyle get s17 => copyWith(fontSize: 17);

  TextStyle get s18 => copyWith(fontSize: 18);

  TextStyle get s20 => copyWith(fontSize: 20);

  TextStyle get s22 => copyWith(fontSize: 22);

  TextStyle get s26 => copyWith(fontSize: 26);

  TextStyle get s30 => copyWith(fontSize: 30);

  TextStyle get primaryColor => copyWith(
        color: AppColors.primary,
      );

  TextStyle get error => copyWith(
        color: const Color(0xFFFF2727),
      );

  TextStyle get black => copyWith(
        color: const Color(0xFF000000),
      );

  TextStyle get lightGrey => copyWith(
        color: const Color(0xFF999999),
      );

  TextStyle get black60 => copyWith(
        color: const Color(0x99000000),
      );

  TextStyle get white => copyWith(
        color: const Color(0xFFFFFFFF),
      );
}
