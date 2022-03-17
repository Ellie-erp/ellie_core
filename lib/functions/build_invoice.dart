import 'dart:typed_data' show Uint8List;

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

final _dateFormatter = DateFormat('dd/MM/yyyy');

/// Create a invoice template.
///
/// For an example, try [buildInvoiceExample].
///
/// For data, the format should be:
/// [
///   [
///     '11010',
///     '西班牙Batalle豬排500g',
///     '22',
///     '23',
///     '150.0/KG',
///     '1050.0'
///   ]
/// ]
///
Future<Uint8List> buildInvoice(PdfPageFormat format,
    {required String orderID,
    required DateTime createDate,
    required String customerName,
    required String shipAddress,
    required String paymentMethod,
    required DateTime shipDate,
    required String shipMethod,
    String? comment,
    required List<List<dynamic>> data,
    required num subTotalPrice,
    required num discount,
    required num freight,
    required totalPrice}) async {
  const title = 'P&J Food HK Limited Invoice';

  final themeData = ThemeData.withFont(
    base: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    bold: await PdfGoogleFonts.shipporiMinchoB1Bold(),
    italic: await PdfGoogleFonts.shipporiMinchoB1Regular(),
    boldItalic: await PdfGoogleFonts.shipporiMinchoB1Bold(),
  ).copyWith(
      defaultTextStyle: const TextStyle(fontSize: 10),
      textAlign: TextAlign.left);

  final pdf =
      Document(theme: themeData, title: title, version: PdfVersion.pdf_1_4);

  final titleTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  Widget header(Context context) => Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'P&J Food HK Limited',
            style: titleTextStyle,
          ),
          Text('Room 516, Sun Fung Centre, 88 Kwai Shui Road,'),
          Text(
            'Kwai Chung, Hong Kong',
          ),
          Text('Tel: 2418-0400'),
        ]),
        Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: 300,
                child: Table.fromTextArray(
                    columnWidths: {
                      0: const FixedColumnWidth(50),
                      1: const FixedColumnWidth(50),
                      2: const FixedColumnWidth(50),
                    },
                    cellAlignment: Alignment.center,
                    headers: ['INVOICE NO.', 'INVOICE DATE', 'PAGE NO.'],
                    data: [
                      [
                        orderID,
                        _dateFormatter.format(createDate),
                        '${context.pageNumber} of ${context.pagesCount}'
                      ]
                    ])))
      ]);

  pdf.addPage(MultiPage(
      pageFormat: format,
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      header: header,
      build: (Context context) => [
            Container(height: 20),
            Text('''
TO: $customerName
        $shipAddress
'''),
            Container(height: 10),
            SizedBox(
                width: 150,
                child: Table.fromTextArray(
                    headers: ['PAYMENT METHOD'],
                    cellAlignment: Alignment.center,
                    data: [
                      [paymentMethod]
                    ])),
            Container(height: 5),
            Table.fromTextArray(
                columnWidths: {
                  0: const FixedColumnWidth(32.5),
                  // 1: const FixedColumnWidth(500),
                },
                headers: ['SHIP DATE', 'SHIP METHOD'],
                cellAlignment: Alignment.center,
                data: [
                  [_dateFormatter.format(shipDate), shipMethod]
                ]),
            Container(height: 10),
            Table.fromTextArray(
                columnWidths: {
                  0: const FixedColumnWidth(40),
                  1: const FixedColumnWidth(130),
                  2: const FixedColumnWidth(40),
                  3: const FixedColumnWidth(40),
                  4: const FixedColumnWidth(50),
                  5: const FixedColumnWidth(50),
                },
                cellAlignment: Alignment.center,
                headers: [
                  'PLU',
                  'DESCRIPTION',
                  'ORDERED',
                  'SHIPPED',
                  'UNIT PRICE',
                  'EXTENDED PRICE'
                ],
                data: data),
            Container(height: 5),
            SizedBox(
                height: 100,
                child: Row(children: [
                  Container(
                      width: 325,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('COMMENT')]))),
                  Container(
                      width: 100,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SUB-TOTAL'),
                                Text('DISCOUNT'),
                                Text('FREIGHT'),
                                Text('TOTAL')
                              ]))),
                  Container(
                      width: 130,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text('HKD'),
                                  Spacer(),
                                  Text(subTotalPrice.toStringAsFixed(1))
                                ]),
                                Row(children: [
                                  Text('HKD'),
                                  Spacer(),
                                  Text('-' + discount.toStringAsFixed(1))
                                ]),
                                Row(children: [
                                  Text('HKD'),
                                  Spacer(),
                                  Text(freight.toStringAsFixed(1))
                                ]),
                                Row(children: [
                                  Text('HKD'),
                                  Spacer(),
                                  Text(totalPrice.toStringAsFixed(1))
                                ]),
                              ])))
                ]))
          ]));
  return pdf.save();
}

Future<Uint8List> buildInvoiceExample(PdfPageFormat format) async =>
    await buildInvoice(format,
        orderID: '2dGmWpEQMUX30OUwRFKW',
        createDate: DateTime(2022, 2, 3),
        customerName: 'Fan Chung Chit',
        shipAddress: 'Room 516, Sun Fung Centre, Kwai Chung',
        paymentMethod: 'Credit Card',
        shipDate: DateTime.now(),
        shipMethod: 'Local',
        data: [
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
          ['11021', '西班牙Batalle豬排500g', '22', '23', '150.0/KG', '1050.0'],
        ],
        subTotalPrice: 20493,
        discount: 100,
        freight: 88,
        totalPrice: 20581);
