import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XmasColors {
  static const bg = Color(0xFFFFFBF6);
  static const red = Color(0xFFB71C1C);
  static const green = Color(0xFF1B5E20);
  static const dark = Color(0xFF212121);
}

class XmasText {
  static final title = GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: XmasColors.red,
  );
  static final subtitle = GoogleFonts.poppins(
    fontSize: 18,
    color: XmasColors.dark,
  );
  static final question = GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static final answer = GoogleFonts.roboto(
    fontSize: 18,
    color: Colors.white,
  );
  static final score = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: XmasColors.green,
  );
}
