// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellie_core/ellie_core.dart';

enum ItemSymbol {
  OPEN,
  CLOSE,
  UNDEFINED,
}

enum Status {
  sale,
  wholesale,
  shop,
  online,
}

extension SymbolColor on ItemSymbol {
  Color? get color {
    switch (this) {
      case ItemSymbol.OPEN:
        return Colors.green;
      case ItemSymbol.CLOSE:
        return Colors.red;
      default:
        return null;
    }
  }
}

extension StatusCh on Status {
  String get ch {
    switch (this) {
      case Status.sale:
        return '零售價';
      case Status.wholesale:
        return '批發價';
      case Status.online:
        return '網店價';
      case Status.shop:
        return '店鋪價';
    }
  }
}

class Item {
  final DocumentSnapshot<Map<String, dynamic>>? docSnap;

  final DocumentReference<Map<String, dynamic>>? docRef;

  List<String> images;

  /// get id
  String get id => docRef?.id ?? '';

  String? get barcode => additional['barcode'];

  final ItemSymbol symbol;

  final String plu;

  final String displayName, originalName;

  String get name => displayName.isEmpty
      ? originalName.isEmpty
          ? 'Name error'
          : originalName
      : displayName;

  final String country, brand;

  final bool isKG;

  String get unit => isKG ? 'KG' : '件';

  final num? weight;

  // final List<num> weights;

  // String get weightsString {
  //   if (weights.length > 1) {
  //     return '${(weights.first * 1000).toInt()}g - ${(weights.last * 1000).toInt()}g';
  //   }
  //   if (weights.isNotEmpty) {
  //     return '${(weights.first * 1000).toInt()}g';
  //   }
  //   return '';
  // }

  int get containsValue => additional['containsValue'] ?? 0;

  int get materialValue => additional['materialValue'] ?? 0;

  final String type;

  String get typeName => type == 'material'
      ? '原箱'
      : type == 'package'
          ? "組合商品"
          : type == 'product'
              ? "附屬商品"
              : "現成商品";

  final Map<String, bool> status;

  final Map<String, bool> subStatus;

  bool get saleUp => (subStatus['sale'] ?? true) && (status['sale'] ?? false);

  bool get wholesaleUp =>
      (subStatus['wholesale'] ?? true) && (status['wholesale'] ?? false);

  bool get onlineUp =>
      (subStatus['online'] ?? true) && (status['online'] ?? false);

  bool get shopUp => (subStatus['shop'] ?? true) && (status['shop'] ?? false);

  bool statusFromType(SalesType type) {
    switch (type) {
      case SalesType.RETAIL:
        return saleUp && symbol == ItemSymbol.OPEN;
      case SalesType.WHOLESALE:
        return wholesaleUp && symbol == ItemSymbol.OPEN;
      case SalesType.ONLINE:
        return onlineUp && symbol == ItemSymbol.OPEN;
      case SalesType.STOCKIN:
        return shopUp && symbol == ItemSymbol.OPEN;
    }
  }

  bool subStatusUp(String status) {
    switch (status) {
      case 'sale':
        return saleUp;
      case 'wholesale':
        return wholesaleUp;
      case 'online':
        return onlineUp;
      case 'shop':
        return shopUp;
      default:
        return false;
    }
  }

  bool get statusIsSubStatus =>
      !status.keys.any((element) => !subStatusUp(element));

  final Map<String, num> pricing;

  num get salePrice => pricing['sale'] ?? 0;

  num get wholesalePrice => pricing['wholesale'] ?? 0;

  num get shopPrice => pricing['shop'] ?? 0;

  num get onlinePrice => pricing['online'] ?? 0;

  num priceFromType(SalesType salesType) {
    switch (salesType) {
      case SalesType.RETAIL:
        return salePrice;
      case SalesType.WHOLESALE:
        return wholesalePrice;
      case SalesType.ONLINE:
        return onlinePrice;
      case SalesType.STOCKIN:
        return shopPrice;
    }
  }

  /// Return a nullable value of sales price.
  num? priceFromSalesType(SalesType salesType) {
    switch (salesType) {
      case SalesType.RETAIL:
        return pricing['sale'];
      case SalesType.WHOLESALE:
        return pricing['wholesale'];
      case SalesType.ONLINE:
        return pricing['online'];
      case SalesType.STOCKIN:
        return pricing['shop'];
    }
  }

  Map<String, num> customPrices;

  num customPrice(SalesType salesType, String? customPriceName) {
    final price = customPrices[customPriceName];
    if (price == null) {
      return priceFromType(salesType);
    } else {
      return price;
    }
  }

  final Map<String, int> scaleData;

  final Map<String, dynamic> additional;

  Set<String> get haveProducts =>
      Set<String>.from(additional['haveProducts'] ?? []);

  Set<String> get packageContains =>
      Set<String>.from(additional['packageContains'] ?? []);

  final DateTime createDate, lastUpdate;

  String? record, spec, remark;

  final List<String> tags;

  List<Package> packages;

  String get tagsString {
    String tagString = '';
    for (final tag in tags) {
      tagString += '#$tag';
      if (tag != tags.last) {
        tagString += ' ';
      }
    }
    return tagString;
  }

  Item(
      {this.docSnap,
      this.docRef,
      required this.images,
      required this.plu,
      required this.displayName,
      required this.originalName,
      required this.country,
      required this.brand,
      required this.isKG,
      required this.type,
      required this.weight,
      required this.status,
      required this.subStatus,
      required this.pricing,
      required this.customPrices,
      required this.scaleData,
      required this.additional,
      required this.createDate,
      required this.lastUpdate,
      required this.symbol,
      this.record,
      this.remark,
      this.spec,
      this.packages = const [],
      this.tags = const []});

  /// Give default value to a initialize
  static Item init(
      {String brand = '',
      String country = '',
      String type = 'product',
      String displayName = '',
      String originalName = ''}) {
    return Item(
        images: [],
        plu: '',
        symbol: ItemSymbol.OPEN,
        displayName: displayName,
        originalName: originalName,
        country: country,
        brand: brand,
        isKG: false,
        type: type,
        weight: 0,
        status: {},
        subStatus: {},
        pricing: {},
        customPrices: {},
        scaleData: {},
        additional: {},
        createDate: DateTime.now(),
        lastUpdate: DateTime.now());
  }

  static Item fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() ?? {};
    return Item(
        images: List<String>.from(data['images'] ?? []),
        docSnap: snapshot,
        docRef: snapshot.reference,
        plu: data['plu'] ?? 'PLU Error',
        symbol: ItemSymbol.values.elementAt(data['symbol'] ?? 0),
        displayName: data['displayName'] ?? '',
        originalName: data['originName'] ?? '',
        country: data['country'] ?? '',
        brand: data['brand'] ?? '',
        isKG: data['isKG'] ?? false,
        type: data['type'] ?? 'Unknown',
        weight: data['weight'],
        status: Map<String, bool>.from(data['status'] ?? {}),
        subStatus: Map<String, bool>.from(data['subStatus'] ?? {}),
        pricing: Map<String, num>.from(data['pricing'] ?? {}),
        customPrices: Map<String, num>.from(data['customPrices'] ?? {}),
        scaleData: Map<String, int>.from(data['scaleData'] ?? {}),
        additional: Map<String, dynamic>.from(data['additional'] ?? {}),
        createDate: data['createDate']?.toDate() ?? DateTime(0),
        lastUpdate: data['lastUpdate']?.toDate() ?? DateTime(0),
        record: data['record'],
        spec: data['spec'],
        remark: data['remark'],
        packages: (data['packages'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map((e) => Package.fromMap(e))
            .toList(),
        tags: List<String>.from(data['tags'] ?? []));
  }

  // static Item fromAlgoliaSnapshot(AlgoliaObjectSnapshot snapshot) {
  //   final _data = snapshot.data;
  //   return Item(
  //       images: List<String>.from(_data['images'] ?? []),
  //       plu: _data['plu'] ?? '',
  //       symbol: Symbol.values.elementAt(_data['symbol'] ?? 0),
  //       displayName: _data['displayName'] ?? '',
  //       originalName: _data['originalName'] ?? '',
  //       country: _data['country'],
  //       brand: _data['brand'] ?? '',
  //       isKG: _data['isKG'] ?? false,
  //       type: _data['type'] ?? 'UNKNOWN',
  //       weight: _data['weight'] ?? 1,
  //       status: _data['status'] ?? {},
  //       subStatus: _data['subStatus'] ?? {},
  //       pricing: _data['pricing'] ?? {},
  //       scaleData: _data['scaleData'] ?? {},
  //       additional: _data['additional'] ?? {},
  //       createDate: _data['createDate'] ?? DateTime(0),
  //       lastUpdate: _data['lastUpdate'] ?? DateTime(0),
  //       record: _data['record'],
  //       spec: _data['spec'],
  //       remark: _data['remark'],
  //       tags: _data['tags'] ?? []);
  // }

  Future<void> turnAllStatus(bool input) async {
    final subStatus = {};
    status.forEach((key, value) => subStatus[key] = input);
    await docRef!.update({'subStatus': subStatus});
  }

  Future<void> turnStatus(String string, bool input) async {
    await docRef!.update({'subStatus.$string': input});
  }

  Future<void> save() {
    return docRef!.update({'lastUpdate': DateTime.now()});
  }
}

class Package {
  String itemId;
  String plu;
  String name;
  String description;
  int qty;
  num? value;

  Package(
      {required this.itemId,
      required this.plu,
      required this.name,
      required this.description,
      this.qty = 1,
      this.value});

  Map<String, dynamic> get toMap => {
        'itemId': itemId,
        'plu': plu,
        'name': name,
        'description': description,
        'qty': qty,
        'value': value
      }..removeWhere((key, value) => value == null);

  factory Package.fromMap(Map<String, dynamic> data) {
    return Package(
        itemId: data['itemId'],
        plu: data['plu'],
        name: data['name'],
        description: data['description'],
        qty: data['qty'],
        value: data['value']);
  }
}
