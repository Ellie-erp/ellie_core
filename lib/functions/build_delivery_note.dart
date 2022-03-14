import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

final dateFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');

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
  required String shopName,
  required DateTime createDate,
  required String shopAddress,
  String? remark,
  required List<List<dynamic>> data,
  required int totalOrderQuantity,
  required int totalShippedQuantity,
}) async {
  final pdf = Document();

  final themeData = ThemeData.withFont(
    base: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    bold: await PdfGoogleFonts.shipporiMinchoB1Bold(),
    italic: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    boldItalic: await PdfGoogleFonts.shipporiMinchoB1Bold(),
  ).copyWith(defaultTextStyle: const TextStyle(fontSize: 12));

  final titleTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  Widget header(Context context) => Row(children: [
        Text('P&J Food 送貨單'),
        Spacer(),
        Text('${context.pageNumber}/${context.pagesCount}')
      ]);

  pdf.addPage(MultiPage(
      pageFormat: format,
      theme: themeData,
      header: header,
      build: (Context context) {
        return [
          Row(children: [
            Text('落單日期: ${dateFormatter.format(createDate)}'),
            Spacer(),
            Text('送貨日期: ${dateFormatter.format(DateTime.now())}')
          ]),
          Row(children: [Text('店鋪名稱: $shopName'), Spacer()]),
          Row(children: [Text('店鋪地址: $shopAddress')]),
          remark != null ? Row(children: [Text('備註: $remark')]) : Container(),
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
            SizedBox(width: 350),
            Text('總落單件數: $totalOrderQuantity', style: titleTextStyle)
          ]),
          Row(children: [
            SizedBox(width: 350),
            Text('總送貨件數: $totalShippedQuantity', style: titleTextStyle)
          ]),
        ];
      }));

  return pdf.save();
}

Future<Uint8List> buildDeliveryNoteExample(PdfPageFormat format) =>
    buildDeliveryNote(
      format,
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
