// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:intl/intl.dart' show DateFormat;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

const _cartonCount = 2;

const _name = 'Audrey Lee 大埔店';
const _address = '北角堡壘街31號';
const _orderId = 'this is order id';
String? _remark = 'Here is some remark';

final _orderDate = DateTime(2022, 5, 31);
final _deliveryDate = DateTime(2022, 6, 7);

final dateFormatter = DateFormat('dd/MM/yyyy');

Future<Uint8List> buildCartonLabelPdf({
  required String name,
  required String address,
  required String orderId,
  required String? remark,
  required DateTime orderDate,
  required DateTime deliveryDate,
  required int cartonCount,
}) async {
  final pdf = Document();

  const double width = 62;
  const double height = 100;

  const pageFormat = PdfPageFormat(width, height);
  const orientation = PageOrientation.landscape;

  final image = MemoryImage((await rootBundle.load('assets/icons/p&j_food.png'))
      .buffer
      .asUint8List());

  // final font = Font.ttf(await rootBundle.load('assets/fonts/noto_sans_hk.ttf'));
  final theme = ThemeData.withFont(
    base: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    bold: await PdfGoogleFonts.shipporiMinchoB1Bold(),
    italic: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    boldItalic: await PdfGoogleFonts.shipporiMinchoB1Bold(),
  ).copyWith(defaultTextStyle: const TextStyle(fontSize: 5));

  Widget body() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          height: 20,
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('TOTAL CTN ${cartonCount.toString().padLeft(3, '0')}')
                ])),
            SizedBox(
                width: 20,
                child: BarcodeWidget(data: orderId, barcode: Barcode.qrCode()))
          ])),
      Text('ADDRESS: $address'),
      Spacer(),
      if (remark?.isNotEmpty ?? false) Text('REMARK: $remark'),
      SizedBox(
          height: 20,
          child: Row(children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('ORDER DATE: ${dateFormatter.format(orderDate)}'),
                  Text('DELIVERY DATE: ${dateFormatter.format(deliveryDate)}'),
                  Text('ID: $orderId', style: const TextStyle(fontSize: 4))
                ])),
            SizedBox(width: 20, child: Image(image))
          ]))
    ]);
  }

  Widget build(Context context) {
    return body();
  }

  pdf.addPage(Page(
      theme: theme,
      pageFormat: pageFormat,
      orientation: orientation,
      build: build));

  return pdf.save();
}

Future<Uint8List> buildCartonLabelPdfExample(PdfPageFormat format) {
  return buildCartonLabelPdf(
      name: _name,
      address: _address,
      orderId: _orderId,
      remark: _remark,
      orderDate: _orderDate,
      deliveryDate: _deliveryDate,
      cartonCount: _cartonCount);
}
