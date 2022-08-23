import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'Sales.dart';

///紀錄每日銷售紀錄,方便做分析,如locationId= '',全部店舖
class DailySales {
  DocumentReference? docRef;
  SalesType salesType;
  DateTime timestamp;
  DateTime saleDate;
  int numOfCompletion;
  int numOfReserve;
  int numOfCancel;
  num totalSale;
  num reservedTotal;
  num reservedTotalPaid;
  String locationId;
  String locationName;
  List<DailySalesMethod> dailySalesMethod;
  List<DailySalesItem> dailySalesItem;

  /// Storing [Sales] in this DailySales locally.
  List<Sales> sales;

  /// Storing corresponding order items locally.
  List<List<OrderItem>> itemsGroups;

  DailySales(
      {this.docRef,
      this.salesType = SalesType.RETAIL,
      required this.timestamp,
      required this.saleDate,
      this.numOfCompletion = 0,
      this.numOfReserve = 0,
      this.numOfCancel = 0,
      this.totalSale = 0,
      this.reservedTotal = 0,
      this.reservedTotalPaid = 0,
      this.locationId = '',
      this.locationName = '',
      this.dailySalesMethod = const [],
      this.dailySalesItem = const [],
      this.sales = const [],
      this.itemsGroups = const []});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'salesType': salesType.name,
        'saleDate': saleDate,
        'NumOfCompletion': numOfCompletion,
        'NumOfReserve': numOfReserve,
        'NumOfCancel': numOfCancel,
        'totalSale': totalSale,
        'reservedTotal': reservedTotal,
        'reservedTotalPaid': reservedTotalPaid,
        'locationId': locationId,
        'locationName': locationName,
        'dailySalesMethod': (dailySalesMethod).map((e) => e.toMap).toList(),
        'dailySalesItem': (dailySalesItem).map((e) => e.toMap).toList(),
      };
  factory DailySales.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailySales(
      docRef: doc.reference,
      salesType: SalesType.values.singleWhere(
          (element) => element.name == (data['salesType'] ?? 'RETAIL')),
      timestamp: data['timestamp']?.toDate(),
      saleDate: data['saleDate']?.toDate(),
      numOfCompletion: data['NumOfCompletion'] ?? 0,
      numOfReserve: data['NumOfReserve'] ?? 0,
      numOfCancel: data['NumOfCancel'] ?? 0,
      totalSale: data['totalSale'] ?? 0,
      reservedTotal: data['reservedTotal'] ?? 0,
      reservedTotalPaid: data['reservedTotalPaid'] ?? 0,
      locationId: data['locationId'] ?? '',
      locationName: data['locationName'] ?? '',
      dailySalesMethod: List<DailySalesMethod>.from(
          (data['dailySalesMethod'] ?? [])
              .map((e) => DailySalesMethod.fromMap(e))
              .toList()),
      dailySalesItem: List<DailySalesItem>.from((data['dailySalesItem'] ?? [])
          .map((e) => DailySalesItem.fromMap(e))
          .toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class DailySalesMethod {
  int numOfOrder;
  num total;
  PayMethod? payMethod;

  DailySalesMethod({
    this.numOfOrder = 0,
    this.total = 0,
    this.payMethod,
  });

  Map<String, dynamic> get toMap => {
        'numOfOrder': numOfOrder,
        'total': total,
        'payMethod': PayMethod.values.indexOf(payMethod!),
      };

  factory DailySalesMethod.fromMap(Map<String, dynamic> map) {
    return DailySalesMethod(
      numOfOrder: map['numOfOrder'] ?? 0,
      total: map['total'] ?? 0,
      payMethod: PayMethod.values.elementAt(map['payMethod'] ?? 0),
    );
  }
}

class DailySalesItem {
  String plu;
  String itemName;
  num total;
  int qty;
  num? weight;

  DailySalesItem({
    required this.plu,
    this.itemName = '',
    this.total = 0,
    this.qty = 0,
    this.weight,
  });

  Map<String, dynamic> get toMap => {
        'plu': plu,
        'itemName': itemName,
        'total': total,
        'qty': qty,
        'weight': weight,
      };

  factory DailySalesItem.fromMap(Map<String, dynamic> map) {
    return DailySalesItem(
      plu: map['plu'],
      itemName: map['itemName'] ?? '',
      total: map['total'] ?? 0,
      qty: map['qty'] ?? 0,
      weight: map['weight'] ?? 0,
    );
  }
}

extension DailySalesExtension on List<DailySales> {
  int get completed => fold(0, (p, e) => p + e.numOfCompletion);
  int get reserved => fold(0, (p, e) => p + e.numOfReserve);
  int get cancelled => fold(0, (p, e) => p + e.numOfCancel);

  num get totalAmount => fold(0, (p, e) => p + e.totalSale);
  num get reservedTotalAmount => fold(0, (p, e) => p + e.reservedTotal);
  num get reservedTotalPaid => fold(0, (p, e) => p + e.reservedTotalPaid);

  List<DailySalesMethod> get payments => PayMethod.values.map((payMethod) {
        final targetMethods = expand((sale) => sale.dailySalesMethod)
            .where((salesMethod) => salesMethod.payMethod == payMethod);
        final quantity = targetMethods.fold<int>(0, (p, e) => p + e.numOfOrder);
        final total = targetMethods.fold<num>(0, (p, e) => p + e.total);
        return DailySalesMethod(
          numOfOrder: quantity,
          total: total,
          payMethod: payMethod,
        );
      }).toList();

  List<DailySalesItem> get products {
    final itemsByPlu = groupBy<DailySalesItem, String>(
        expand((sale) => sale.dailySalesItem).toList(), (item) => item.plu);

    return itemsByPlu.entries.map((entry) {
      final plu = entry.key;
      final items = entry.value;

      final total = items.fold<num>(0, (p, e) => p + e.total);
      final qty = items.fold<int>(0, (p, e) => p + e.qty);
      num? weight;
      if (items.every((item) => item.weight != null)) {
        weight = items.fold<num>(0, (p, e) => p + e.weight!);
      }

      return DailySalesItem(
          plu: plu,
          itemName: items.first.itemName,
          total: total,
          qty: qty,
          weight: weight);
    }).toList();
  }
}
