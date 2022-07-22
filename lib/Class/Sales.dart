import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

enum PayMethod {
  Cash,
  VisaCard,
  MasterCard,
  OctopusCard,
  Payme,
  AliPay,
  WechatPay,
  AE,
  BankTransferOrCheque,
  FPS,
  UnionPay,
}

extension PayMethodExt on PayMethod {
  String get displayName {
    switch (this) {
      case PayMethod.Cash:
        return 'Cash';
      case PayMethod.VisaCard:
        return 'Visa Card';
      case PayMethod.MasterCard:
        return 'Master Card';
      case PayMethod.OctopusCard:
        return 'Octopus Card';
      case PayMethod.Payme:
        return 'PayMe';
      case PayMethod.AliPay:
        return 'Alipay';
      case PayMethod.WechatPay:
        return 'WeChat Pay';
      case PayMethod.AE:
        return 'American Express Card';
      case PayMethod.BankTransferOrCheque:
        return 'Back Transfer / Cheque';
      case PayMethod.FPS:
        return 'FPS';
      case PayMethod.UnionPay:
        return 'UnionPay';
    }
  }
}

enum SalesType {
  RETAIL,
  WHOLESALE,
  ONLINE,
  STOCKIN,
}

enum SalesStatus {
  OPEN,
  COMPLETE,
  CANCEL,
  AWAIT,
  PREPARING,

  ///Ready for delivery
  RFD,

  /// For backend Colleague to create order for customer, same as await, but not will not show in client's order list before sending
  MANUAL,

  /// Only for retail sales, that order can be reserved and can be retreived later, becuause in 'Open' status, the order cannot be opened the day after
  RESERVED,
}

class Sales {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  num amount;

  SalesStatus salesStatus;
  SalesType salesType;
  String? clientId;
  String? clientName;

  String locationId;
  String? locationName;
  num deduction;
  num discount;
  num paidAmount;

  ///Show how much customer paid in reality
  PayMethod? payMethod;

  DateTime? deliveryDate;
  String? deliveryAddress;
  String? staffId;
  String? staffName;

  String? businessClientId;

  ///if wholesale, the business company name and ID will be record
  String? businessClientName;
  String? bcBranchId;

  /// if any branch exist, it will record the branch id and name.
  String? bcBranchName;

  String? remark;

  num freight;
  bool isPaid;

  /// Additional information: Number of cartons that will be delivered
  num? cartonQty;

  num get subTotal => (amount - freight + deduction) / discount;
  num get deductedAmount => amount - freight - subTotal;
  String? tel;

  String get name {
    switch (salesType) {
      case SalesType.RETAIL:
        return clientName ?? 'Retail';
      case SalesType.WHOLESALE:
        return businessClientName ?? 'Unnamed';
      case SalesType.ONLINE:
        return clientName ?? 'Unnamed';
      case SalesType.STOCKIN:
        return locationName ?? 'Unnamed';
    }
  }

  Sales(
      {this.docRef,
      required this.createDate,
      required this.amount,
      required this.salesStatus,
      this.clientName,
      this.clientId,
      required this.salesType,
      required this.locationId,
      this.locationName,
      this.deduction = 0,
      this.discount = 1,
      required this.paidAmount,
      this.payMethod,
      required this.updateDate,
      this.deliveryAddress,
      this.staffId,
      this.staffName,
      this.deliveryDate,
      this.businessClientId,
      this.businessClientName,
      this.bcBranchId,
      this.bcBranchName,
      this.remark,
      this.freight = 0,
      this.isPaid = false,
      this.cartonQty,
      this.tel});
  Map<String, dynamic> get toMap {
    final _amount = num.parse(amount.toStringAsFixed(1));
    final _paidAmount = num.parse(paidAmount.toStringAsFixed(1));
    final _isPaid = _paidAmount >= _amount;
    return {
      'createDate': createDate,
      'updateDate': updateDate,
      'amount': _amount,
      'salesStatus': SalesStatus.values.indexOf(salesStatus),
      'salesType': SalesType.values.indexOf(salesType),
      'clientId': clientId,
      'clientName': clientName,
      'locationId': locationId,
      'locationName': locationName,
      'deduction': deduction,
      'discount': discount,
      'paidAmount': _paidAmount,
      'payMethod': PayMethod.values.indexOf(payMethod!),
      'deliveryAddress': deliveryAddress,
      'staffId': staffId,
      'staffName': staffName,
      'deliveryDate': deliveryDate,
      'businessClientId': businessClientId,
      'businessClientName': businessClientName,
      'bcBranchId': bcBranchId,
      'bcBranchName': bcBranchName,
      'remark': remark,
      'freight': freight,
      'isPaid': _isPaid,
      'cartonQty': cartonQty,
      'tel': tel,
    };
  }

  factory Sales.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Sales(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate() ?? DateTime(0),
      updateDate: doc.data()?['updateDate']?.toDate() ?? DateTime(0),
      amount: doc.data()?['amount'],
      salesStatus:
          SalesStatus.values.elementAt(doc.data()?['salesStatus'] ?? 0),
      salesType: SalesType.values.elementAt(doc.data()?['salesType'] ?? 0),
      clientName: doc.data()?['clientName'],
      clientId: doc.data()?['clientId'],
      locationId: doc.data()?['locationId'],
      locationName: doc.data()?['locationName'] ?? '',
      deduction: doc.data()?['deduction'] ?? 0,
      discount: doc.data()?['discount'] ?? 1,
      paidAmount: doc.data()?['paidAmount'],
      payMethod: PayMethod.values.elementAt(doc.data()?['payMethod'] ?? 0),
      deliveryAddress: doc.data()?['deliveryAddress'] ?? '',
      staffId: doc.data()?['staffId'],
      staffName: doc.data()?['staffName'],
      deliveryDate: doc.data()?['deliveryDate']?.toDate(),
      businessClientId: doc.data()?['businessClientId'],
      businessClientName: doc.data()?['businessClientName'],
      bcBranchId: doc.data()?['bcBranchId'],
      bcBranchName: doc.data()?['bcBranchName'],
      remark: doc.data()?['remark'],
      freight: doc.data()!['freight'] ?? 0,
      isPaid: doc.data()!['isPaid'] ?? false,
      cartonQty: doc.data()!['cartonQty'] ?? 0,
      tel: doc.data()!['tel'] ?? '',
    );
  }

  Sales copy() {
    return Sales(
        docRef: docRef,
        createDate: createDate,
        updateDate: updateDate,
        amount: amount,
        salesStatus: salesStatus,
        salesType: salesType,
        clientName: clientName,
        clientId: clientId,
        locationId: locationId,
        locationName: locationName,
        deduction: deduction,
        discount: discount,
        payMethod: payMethod,
        deliveryAddress: deliveryAddress,
        staffId: staffId,
        staffName: staffName,
        deliveryDate: deliveryDate,
        businessClientId: businessClientId,
        businessClientName: businessClientName,
        bcBranchId: bcBranchId,
        bcBranchName: bcBranchName,
        remark: remark,
        freight: freight,
        isPaid: isPaid,
        cartonQty: cartonQty,
        tel: tel,
        paidAmount: paidAmount);
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

//
// enum Unit{
//   PC,
//   KG
//
// }

class OrderItem {
  DocumentReference? docRef;
  DateTime timestamp;
  String title;
  String? code;
  num unitPrice;
  Unit unit;
  String get unitName => describeEnum(unit);
  num preWeight;
  num? preQTY;
  List<num> array;
  int get qty => array.length;
  String? remark;
  String? locationId;
  String? barcode;

  String get plu => code ?? '';
  DateTime lastUpdatedDate;

  num get totalPrice =>
      List<num>.from(array).fold<num>(0, (p, e) => p + e) * unitPrice;

  String get preWeightString {
    if (preWeight == 1 && unit == Unit.PC) {
      return '';
    }
    if (preWeight > 1) {
      return num.parse(preWeight.toStringAsFixed(3)).toString() + 'kg';
    }
    return num.parse((preWeight * 1000).toStringAsFixed(0)).toString() + 'g';
  }

  String get weightString {
    if (unit == Unit.KG) {
      final _array = (array).cast<num>();

      String output = '\n[';

      for (final value in _array) {
        if (value > 1) {
          output += num.parse(value.toStringAsFixed(3)).toString() + 'kg';
        } else {
          output +=
              num.parse((value * 1000).toStringAsFixed(0)).toString() + 'g';
        }
        if (value != _array.last) {
          output += ', ';
        }
      }
      return output + ']';
    } else {
      return '';
    }
  }

  OrderItem(
      {this.docRef,
      required this.timestamp,
      required this.title,
      this.code,
      required this.unitPrice,
      required this.unit,
      this.preWeight = 1,
      this.preQTY,
      required this.array,
      this.remark,
      this.locationId,
      this.barcode})
      : lastUpdatedDate = DateTime.now();

  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'title': title,
        'code': code,
        'unitPrice': unitPrice,
        'unit': Unit.values.indexOf(unit),
        'preWeight': preWeight,
        'preQTY': preQTY,
        'array': array,
        'remark': remark,
        'locationId': locationId,
        'barcode': barcode,
        'lastUpdatedDate': DateTime.now()
      }..removeWhere((key, value) => value == null);

  factory OrderItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return OrderItem(
        docRef: doc.reference,
        timestamp: doc.data()?['timestamp']?.toDate(),
        title: doc.data()?['title'],
        code: doc.data()?['code'],
        unitPrice: doc.data()?['unitPrice'],
        unit: Unit.values.elementAt(doc.data()?['unit'] ?? 0),
        preWeight: doc.data()?['preWeight'] ?? 1,
        preQTY: doc.data()?['preQTY'],
        array: ((doc.data()?['array'] as List?) ?? []).cast<num>(),
        remark: doc.data()?['remark'] ?? '',
        locationId: doc.data()?['locationId'],
        barcode: doc.data()?['barcode']);
  }

  OrderItem copyWith({
    DocumentReference? docRef,
    DateTime? timestamp,
    String? title,
    String? code,
    num? unitPrice,
    Unit? unit,
    num? preWeight,
    num? preQTY,
    List<num>? array,
    String? remark,
    String? locationId,
    String? barcode,
  }) {
    return OrderItem(
        docRef: docRef,
        timestamp: timestamp ?? this.timestamp,
        title: title ?? this.title,
        code: code ?? this.code,
        unitPrice: unitPrice ?? this.unitPrice,
        unit: unit ?? this.unit,
        preWeight: preWeight ?? this.preWeight,
        preQTY: preQTY ?? this.preQTY,
        array: array ?? this.array,
        remark: remark ?? this.remark,
        locationId: locationId ?? this.locationId,
        barcode: barcode ?? this.barcode);
  }

  Future<void> update() async => await docRef!.update(toMap);
}

class OrderHistory {
  DocumentReference? docRef;
  DateTime timestamp;
  String text;
  String? uid;

  OrderHistory({
    this.docRef,
    required this.timestamp,
    required this.text,
    this.uid = '',
  });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'text': text,
        'uid': uid,
      };
  factory OrderHistory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return OrderHistory(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      text: doc.data()!['text'] ?? '',
      uid: doc.data()!['uid'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

enum PaymentRecordType {
  Payment,
  Change,
  CreditTransfer,
  Refund,
  CreditPayment,
}

class PaymentRecord {
  DocumentReference? docRef;
  DateTime timestamp;
  num amount;
  String? remark;
  String staffId;
  String staffName;
  PaymentRecordType paymentRecordType;

  PaymentRecord(
      {this.docRef,
      required this.timestamp,
      required this.amount,
      this.remark,
      required this.staffId,
      required this.staffName,
      required this.paymentRecordType});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'amount': amount,
        'remark': remark,
        'staffId': staffId,
        'staffName': staffName,
        'paymentRecordType':
            PaymentRecordType.values.indexOf(paymentRecordType),
      };
  factory PaymentRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PaymentRecord(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      amount: doc.data()!['amount'],
      remark: doc.data()!['remark'],
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
      paymentRecordType: PaymentRecordType.values
          .elementAt(doc.data()?['paymentRecordType'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
