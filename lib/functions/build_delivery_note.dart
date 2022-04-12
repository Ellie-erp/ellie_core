import 'dart:typed_data' show Uint8List;

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

final _dateFormatter = DateFormat('dd/MM/yyyy');

/// Create a delivery note template with data.
///
/// You can check [buildDeliveryNoteExample] for example.
///
/// Data should be in List<List<dynamic>>, for example:
/// [
///   [
///      '11010',
///      '西班牙Batalle豬排(500g)',
///      '\$250/KG',
///      '29',
///      '28',
///      '32.223KG',
///      '\$8055.7'
///   ]
/// ]
Future<Uint8List> buildDeliveryNote(
  PdfPageFormat format, {
  required String orderId,
  required String name,
  required DateTime createDate,
  required DateTime deliveryDate,
  required String address,
  String? remark,
  required List<List<dynamic>> data,
  required int totalOrderQuantity,
  required int totalShippedQuantity,
}) async {
  const title = 'P&J Food Delivery Note';

  final themeData = ThemeData.withFont(
    base: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    bold: await PdfGoogleFonts.shipporiMinchoB1Bold(),
    italic: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    boldItalic: await PdfGoogleFonts.shipporiMinchoB1Bold(),
  ).copyWith(defaultTextStyle: const TextStyle(fontSize: 14));

  final pdf =
      Document(title: title, theme: themeData, version: PdfVersion.pdf_1_4);

  final titleTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  Widget header(Context context) => Row(children: [
        Text('P&J Food 送貨單'),
        Spacer(),
        Text('${context.pageNumber}/${context.pagesCount}')
      ]);

  Widget footer(Context context) => SizedBox(
      width: 200,
      height: 40,
      child: BarcodeWidget(barcode: Barcode.code128(), data: orderId));

  pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      pageFormat: format,
      header: header,
      footer: footer,
      build: (Context context) {
        return [
          Row(children: [
            Text('落單日期: ${_dateFormatter.format(createDate)}'),
            Spacer(),
            Text('送貨日期: ${_dateFormatter.format(DateTime.now())}')
          ]),
          Row(children: [
            Text('名稱: $name'),
            Spacer(),
            Text('預計送貨日期: ${_dateFormatter.format(deliveryDate)}')
          ]),
          Row(children: [Text('地址: $address')]),
          remark != null && remark.isNotEmpty
              ? Row(children: [Text('備註: $remark')])
              : Container(),
          Table.fromTextArray(headers: [
            'PLU',
            '貨品名稱',
            '價錢',
            '落單數量',
            '送貨數量',
            '重量',
          ], columnWidths: {
            0: const FixedColumnWidth(20),
            1: const FixedColumnWidth(120),
            2: const FixedColumnWidth(20),
            3: const FixedColumnWidth(20),
            4: const FixedColumnWidth(20),
            5: const FixedColumnWidth(30),
          }, cellAlignment: Alignment.center, data: data),
          Row(children: [
            SizedBox(width: 400),
            Text('總落單件數:', style: titleTextStyle),
            Spacer(),
            Text('$totalOrderQuantity', style: titleTextStyle)
          ]),
          Row(children: [
            SizedBox(width: 400),
            Text('總送貨件數:', style: titleTextStyle),
            Spacer(),
            Text('$totalShippedQuantity', style: titleTextStyle)
          ]),
        ];
      }));

  return pdf.save();
}

Future<Uint8List> buildDeliveryNoteExample(PdfPageFormat format) =>
    buildDeliveryNote(
      format,
      orderId: '2dGmWpEQMUX30OUwRFKW',
      shopName: 'P&J Food 新豐中心店鋪',
      createDate: DateTime(2022, 2, 12, 14, 54, 23),
      shopAddress: '葵涌,國瑞路88號,新豐中心5樓16室',
      remark: '請帶2卷收據紙',
      data: [
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/PC',
          '29',
          '28',
          '32.223KG',
        ],
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/KG',
          '29',
          '28',
          '32PCS',
        ],
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/KG',
          '29',
          '28',
          '32.223KG',
        ],
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/KG',
          '29',
          '28',
          '32.223KG',
        ],
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/KG',
          '29',
          '28',
          '32.223KG',
        ],
        [
          '11010',
          '西班牙Batalle豬排(500g)',
          '\$250/KG',
          '29',
          '28',
          '32.223KG',
        ],
      ],
      totalOrderQuantity: 230,
      totalShippedQuantity: 220,
    );
