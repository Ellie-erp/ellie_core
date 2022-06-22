import 'package:flutter/material.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:just_audio/just_audio.dart';

import '../ellie_core.dart';

enum BarcodeType {
  upcA,
  ean13,
  code128,
  interleaved,
}

extension BarcodeTypeExtension on BarcodeType {
  String get name {
    switch (this) {
      case BarcodeType.upcA:
        return 'UPC-A';
      case BarcodeType.ean13:
        return 'EAN-13 / Bookland EAN';
      case BarcodeType.code128:
        return 'Code 128';
      case BarcodeType.interleaved:
        return 'Interleaved 2 of 5';
    }
  }
}

String removeCheckDigit(String? code) {
  if (code == null) {
    return '';
  } else {
    return code.substring(0, code.length - 1);
  }
}

bool matchOrderItem(OrderItem orderItem, String code) {
  return orderItem.plu == code ||
      removeCheckDigit(orderItem.barcode) == removeCheckDigit(code);
}

bool matchItem(Item item, String code) {
  return item.plu == code ||
      removeCheckDigit(item.barcode) == removeCheckDigit(code);
}

class ScannerDecoder {
  List<Item> items;
  List<OrderItem> orderItems;
  Function(OrderItem orderItem, num? weight) onItemFound;
  Function(Item item, num? weight) onAddItem;

  ScannerDecoder({
    required this.items,
    required this.orderItems,
    required this.onItemFound,
    required this.onAddItem,
  });

  _handleUpcEan(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      if (orderItems.any((orderItem) => matchOrderItem(orderItem, code))) {
        final orderItem = orderItems
            .firstWhere((orderItem) => matchOrderItem(orderItem, code));
        await onItemFound(orderItem, null);
      } else if (items.any((item) => matchItem(item, code))) {
        final item = items.firstWhere((item) => matchItem(item, code));
        await onAddItem(item, null);
      } else {
        throw 'error';
      }
    } else {
      throw 'error';
    }
  }

  _handleNormal(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      final plu = code.substring(2, 7);
      // final price =
      //     num.parse('${code.substring(7, 10)}.${code.substring(10, 12)}');
      final weight =
          num.parse('${code.substring(12, 14)}.${code.substring(14, 17)}');

      if (orderItems.any((orderItem) => orderItem.plu == plu)) {
        final orderItem =
            orderItems.firstWhere((orderItem) => orderItem.plu == plu);
        await onItemFound(orderItem, weight);
      } else if (items.any((item) => item.plu == plu)) {
        final item = items.firstWhere((item) => item.plu == plu);
        await onAddItem(item, weight);
      } else {
        throw 'error';
      }
    } else {
      throw 'error';
    }
  }

  _handleOther(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      if (orderItems.any((orderItem) => matchOrderItem(orderItem, code))) {
        final orderItem = orderItems
            .firstWhere((orderItem) => matchOrderItem(orderItem, code));
        await onItemFound(orderItem, null);
      } else if (items.any((item) => matchItem(item, code))) {
        final item = items.firstWhere((item) => matchItem(item, code));
        await onAddItem(item, null);
      } else {
        throw 'error';
      }
    } else {
      throw 'error';
    }
  }

  onDecoded(ScannedData scannedData) async {
    if (scannedData.codeType == BarcodeType.upcA.name ||
        scannedData.codeType == BarcodeType.ean13.name) {
      /// Handle UPC-A and EAN-13 data, which will ignore check digit.
      await _handleUpcEan(scannedData);
    } else if (scannedData.codeType == BarcodeType.interleaved.name &&
        scannedData.code?.length == 18) {
      /// Handle normal barcode.
      await _handleNormal(scannedData);
    } else {
      /// Handle other barcode.
      await _handleOther(scannedData);
    }
  }
}

class Scanner extends StatefulWidget {
  const Scanner(
      {Key? key, required this.onDecoded, required this.child, this.debug})
      : super(key: key);

  final Function(ScannedData scannedData) onDecoded;
  final Widget child;
  final ScannedData? debug;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner>
    with WidgetsBindingObserver
    implements ScannerCallback {
  final HoneywellScanner honeywellScanner = HoneywellScanner();
  bool isSupported = false;

  final AudioPlayer player = AudioPlayer();

  Future<void> playCorrectSound() async {
    await player.setAsset('assets/audios/correct.wav');
    return player.play();
  }

  Future<void> playErrorSound() async {
    await player.setAsset('assets/audios/error.wav');
    return player.play();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    honeywellScanner.scannerCallback = this;
    init();
  }

  Future<void> init() async {
    isSupported = await honeywellScanner.isSupported();
    if (isSupported) {
      updateScanProperties();
      await honeywellScanner.startScanner();
    }
    if (mounted) setState(() {});
  }

  void updateScanProperties() {
    List<CodeFormat> codeFormats = [];
    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
    Map<String, dynamic> properties = {
      ...CodeFormatUtils.getAsPropertiesComplement(codeFormats),
      'DEC_CODABAR_START_STOP_TRANSMIT': true,
      'DEC_EAN13_CHECK_DIGIT_TRANSMIT': true,
      'DEC_UPCA_CHECK_DIGIT_TRANSMIT': true,
    };
    honeywellScanner.setProperties(properties);
  }

  decode(ScannedData scannedData) async {
    try {
      await widget.onDecoded(scannedData);
      playCorrectSound();
    } catch (e) {
      playErrorSound();
    }
  }

  @override
  void onDecoded(ScannedData? scannedData) async {
    if (scannedData != null) {
      await decode(scannedData);
    }
  }

  @override
  void onError(Exception error) {}

  Widget get debugWidget {
    return Material(
      child: IconButton(
          onPressed: () {
            decode(widget.debug!);
          },
          icon: const Icon(Icons.bug_report)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debug != null) {
      return Stack(
        children: [widget.child, Center(child: debugWidget)],
      );
    } else {
      return widget.child;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        honeywellScanner.resumeScanner();
        break;
      case AppLifecycleState.inactive:
        honeywellScanner.pauseScanner();
        break;
      case AppLifecycleState
          .paused: //AppLifecycleState.paused is used as stopped state because deactivate() works more as a pause for lifecycle
        honeywellScanner.pauseScanner();
        break;
      case AppLifecycleState.detached:
        honeywellScanner.pauseScanner();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    if (isSupported) {
      honeywellScanner.stopScanner();
      player.dispose();
    }
    super.dispose();
  }
}
