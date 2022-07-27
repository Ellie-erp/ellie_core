import 'package:audio_session/audio_session.dart';
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
  bool checkPrice;
  Function(OrderItem orderItem, num? weight) onItemFound;
  Function(Item item, num? weight, num? price) onAddItem;
  OrderItem? selectedItem;

  ScannerDecoder({
    required this.items,
    required this.orderItems,
    required this.onItemFound,
    required this.onAddItem,
    this.checkPrice = false,
    this.selectedItem,
  });

  _handleUpcEan(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      if (selectedItem != null && matchOrderItem(selectedItem!, code)) {
        await onItemFound(selectedItem!, null);
      } else if (orderItems
          .any((orderItem) => matchOrderItem(orderItem, code))) {
        final orderItem = orderItems
            .firstWhere((orderItem) => matchOrderItem(orderItem, code));
        await onItemFound(orderItem, null);
      } else if (items.any((item) => matchItem(item, code))) {
        final item = items.firstWhere((item) => matchItem(item, code));
        await onAddItem(item, null, null);
      } else {
        throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
      }
    } else {
      throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
    }
  }

  _handleNormal(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      final plu = code.substring(2, 7);
      final amount =
          num.parse('${code.substring(7, 10)}.${code.substring(10, 12)}');
      final weight =
          num.parse('${code.substring(12, 14)}.${code.substring(14, 17)}');

      final price = amount / weight;

      if (selectedItem != null && matchOrderItem(selectedItem!, code)) {
        await onItemFound(selectedItem!, weight);
      } else if (orderItems.any((orderItem) =>
          orderItem.plu == plu &&
          (checkPrice
              ? orderItem.unitPrice.toStringAsFixed(1) ==
                  price.toStringAsFixed(1)
              : true))) {
        final orderItem = orderItems.firstWhere((orderItem) =>
            orderItem.plu == plu &&
            (checkPrice
                ? orderItem.unitPrice.toStringAsFixed(1) ==
                    price.toStringAsFixed(1)
                : true));
        await onItemFound(orderItem, weight);
      } else if (items.any((item) => item.plu == plu)) {
        final item = items.firstWhere((item) => item.plu == plu);
        await onAddItem(item, weight, num.parse(price.toStringAsFixed(1)));
      } else {
        throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
      }
    } else {
      throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
    }
  }

  _handleOther(ScannedData scannedData) async {
    final code = scannedData.code?.trim();
    if (code != null) {
      if (selectedItem != null && matchOrderItem(selectedItem!, code)) {
        await onItemFound(selectedItem!, null);
      } else if (orderItems
          .any((orderItem) => matchOrderItem(orderItem, code))) {
        final orderItem = orderItems
            .firstWhere((orderItem) => matchOrderItem(orderItem, code));
        await onItemFound(orderItem, null);
      } else if (items.any((item) => matchItem(item, code))) {
        final item = items.firstWhere((item) => matchItem(item, code));
        await onAddItem(item, null, null);
      } else {
        throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
      }
    } else {
      throw 'Product not found. Code type: ${scannedData.codeType}. Code: $code';
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
  const Scanner({
    Key? key,
    required this.onDecoded,
    required this.child,
    this.debug,
    this.onScannerError,
    this.onError,
  }) : super(key: key);

  final Function(ScannedData scannedData) onDecoded;
  final Widget child;
  final ScannedData? debug;
  final Function(Exception error)? onScannerError;
  final Function(String error)? onError;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner>
    with WidgetsBindingObserver
    implements ScannerCallback {
  final HoneywellScanner honeywellScanner = HoneywellScanner();
  bool isSupported = false;

  final AudioPlayer correctPlayer = AudioPlayer();
  final AudioPlayer errorPlayer = AudioPlayer();

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
      await setPlayer();
      updateScanProperties();
      await honeywellScanner.startScanner();
    }
    if (mounted) setState(() {});
  }

  Future<void> setPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    await correctPlayer.setAsset('assets/audio/correct.mp3');
    await errorPlayer.setAsset('assets/audios/error.mp3');
  }

  Future<void> play(AudioPlayer player) async {
    final playing = player.playerState.playing;
    if (playing != true) {
      return player.play();
    } else {
      return player.seek(Duration.zero);
    }
  }

  Future<void> playCorrectSound() async {
    return play(correctPlayer);
  }

  Future<void> playErrorSound() async {
    return play(errorPlayer);
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
      if (widget.onError != null) widget.onError!(e.toString());
      rethrow;
    }
  }

  @override
  void onDecoded(ScannedData? scannedData) async {
    if (scannedData != null) {
      await decode(scannedData);
    }
  }

  @override
  void onError(Exception error) {
    if (widget.onScannerError != null) {
      widget.onScannerError!(error);
    }
  }

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
        correctPlayer.stop();
        errorPlayer.stop();
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
      correctPlayer.dispose();
      errorPlayer.dispose();
    }
    super.dispose();
  }
}
