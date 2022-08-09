import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

enum PCMType {
  SUPPILER,
  MARKET,
}

enum Term {
  NONE,
  CIF,
  CNF,
  CFR,
  DAT,
  DDP,
  DAP,
  EXW,
  FOB,
  FCA,
}

class PCMSuppiler {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  PCMType pcmType;
  String get PCMTypeName => describeEnum(pcmType);
  String name;
  String? brand;
  String? website;
  Country origin;
  String get originName => describeEnum(origin);
  Term term;
  String? address;
  List<Contact>? contact;
  String get termName => describeEnum(term);
  Currency currency;
  String get currencyName => describeEnum(currency);
  List<History>? history;
  String? staffAddressbookId;
  String? defaultRecipientAddressbookId;
  num defaultDepositRate;
  List<String> categoriesIds;

  PCMSuppiler(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.name,
      this.brand,
      required this.origin,
      required this.term,
      this.address,
      this.contact,
      required this.currency,
      this.website,
      required this.pcmType,
      this.history,
      this.defaultRecipientAddressbookId = '',
      this.staffAddressbookId = '',
      this.defaultDepositRate = 1,
      this.categoriesIds = const []});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'pcmType': PCMType.values.indexOf(pcmType),
        'name': name,
        'brand': brand,
        'website': website,
        'origin': Country.values.indexOf(origin),
        'address': address,
        'term': Term.values.indexOf(term),
        'contact': (contact ?? []).map((e) => e.toMap).toList(),
        'currency': Currency.values.indexOf(currency),
        'history': (history ?? []).map((e) => e.toMap).toList(),
        'staffAddressbookId': staffAddressbookId,
        'defaultRecipientAddressbookId': defaultRecipientAddressbookId,
        'defaultDepositRate': defaultDepositRate,
        'categoriesIds': categoriesIds,
      };
  factory PCMSuppiler.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PCMSuppiler(
        docRef: doc.reference,
        createDate: doc.data()!['createDate']?.toDate(),
        updateDate: doc.data()!['updateDate']?.toDate(),
        name: doc.data()!['name'],
        website: doc.data()!['website'],
        brand: doc.data()!['brand'] ?? '',
        pcmType: PCMType.values.elementAt(doc.data()!['pcmType'] ?? 0),
        currency: Currency.values.elementAt(doc.data()!['currency'] ?? 0),
        origin: Country.values.elementAt(doc.data()!['origin'] ?? 0),
        address: doc.data()!['address'] ?? '',
        term: Term.values.elementAt(doc.data()!['term'] ?? 0),
        contact: List<Contact>.from((doc.data()!['contact'] ?? [])
            .map((e) => Contact.fromMap(e))
            .toList()),
        history: List<History>.from((doc.data()!['history'] ?? [])
            .map((e) => History.fromMap(e))
            .toList()),
        staffAddressbookId: doc.data()?['staffAddressbookId'] ?? '',
        defaultRecipientAddressbookId:
            doc.data()?['defaultRecipientAddressbookId'] ?? '',
        defaultDepositRate: doc.data()?['defaultDepositRate'] ?? 1,
        categoriesIds: ((doc.data()?['categoriesIds'] as List?) ?? []).cast<String>());
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class Contact {
  DateTime createDate;
  String? name;
  String? email;
  String? tel;

  Contact({required this.createDate, this.name, this.email, this.tel});

  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'name': name,
        'email': email,
        'tel': tel,
      };

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      createDate: map['createDate']?.toDate(),
      name: map['name'],
      email: map['email'],
      tel: map['tel'],
    );
  }
}

class History {
  DateTime timestamp;
  String? remark;

  History({
    required this.timestamp,
    this.remark,
  });

  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'remark': remark,
      };

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      timestamp: map['timestamp']?.toDate(),
      remark: map['remark'],
    );
  }
}
