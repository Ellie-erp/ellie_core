import 'package:ellie_core/ellie_core.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
          build: (format) => buildCartonLabelPdf(
              name: name,
              address: address,
              orderId: orderId,
              remark: remark,
              orderDate: orderDate,
              deliveryDate: deliveryDate)),
    );
  }
}
