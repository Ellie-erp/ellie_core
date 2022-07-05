// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:pdf/widgets.dart';

Future<ThemeData> get defaultPdfTheme async {
  final emoji = Font.ttf(await rootBundle.load('assets/fonts/emoji.ttf'));
  final backup = Font.ttf(await rootBundle.load('assets/fonts/backup.ttf'));
  return ThemeData.withFont(
    base: Font.ttf(await rootBundle.load('assets/fonts/base.ttf')),
    bold: Font.ttf(await rootBundle.load('assets/fonts/bold.ttf')),
    fontFallback: [emoji, backup],
  );
}
