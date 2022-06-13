import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ClientType {
  PERSONAL,
  BUSINESS,
  STAFF,
}

class Client {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String name;
  String? address;
  String? tel;
  String? companyName;
  String? note;
  String? salesId;
  String? salesName;
  ClientType clientType;
  String get clientTypeName => describeEnum(clientType);

  Client(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.name,
      this.address,
      this.tel,
      this.companyName,
      this.note,
      this.salesId,
      this.salesName,
      required this.clientType});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'name': name,
        'address': address,
        'tel': tel,
        'companyName': companyName,
        'note': note,
        'salesId': salesId,
        'salesName': salesName,
        'clientType': ClientType.values.indexOf(clientType),
      };
  factory Client.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Client(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      name: doc.data()!['name'],
      address: doc.data()!['address'],
      tel: doc.data()!['tel'],
      companyName: doc.data()!['companyName'],
      salesId: doc.data()!['salesId'],
      salesName: doc.data()!['salesName'],
      clientType: ClientType.values.elementAt(doc.data()!['clientType'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
