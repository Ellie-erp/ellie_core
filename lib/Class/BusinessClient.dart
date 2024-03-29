import 'package:cloud_firestore/cloud_firestore.dart';

enum BusinessClientType {
  Lead,
  Client,
}

enum BusinessClientStatus {
  Active,
  Inactive,
}

class BusinessClient {
  DocumentReference? docRef;
  DateTime createDate;
  String orgName;
  String orgNameEn;
  String tel;
  String address;
  DateTime updateDate;
  String? staffId;
  String? staffName;
  num credit;
  num paymentPeriod;
  String email;
  String contactName;
  BusinessClientType businessClientType;
  String remark;
  String whatsapp;
  String refNo;
  BusinessClientStatus businessClientStatus;

  BusinessClient({
    this.docRef,
    required this.createDate,
    required this.orgName,
    required this.orgNameEn,
    required this.tel,
    required this.address,
    required this.updateDate,
    this.staffName,
    this.staffId,
    required this.credit,
    required this.paymentPeriod,
    this.email = '',
    this.contactName = '',
    required this.businessClientType,
    this.remark = '',
    this.whatsapp = '',
    this.refNo = '',
    this.businessClientStatus = BusinessClientStatus.Active,
  });
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'orgName': orgName,
        'orgNameEn': orgNameEn,
        'tel': tel,
        'address': address,
        'updateDate': updateDate,
        'staffId': staffId,
        'staffName': staffName,
        'credit': credit,
        'paymentPeriod': paymentPeriod,
        'email': email,
        'contactName': contactName,
        'businessClientType':
            BusinessClientType.values.indexOf(businessClientType),
        'remark': remark,
        'whatsapp': whatsapp,
        'refNo': refNo,
        'businessClientStatus':
            BusinessClientStatus.values.indexOf(businessClientStatus),
      };
  factory BusinessClient.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BusinessClient(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      orgName: doc.data()!['orgName'],
      orgNameEn: doc.data()!['orgNameEn'],
      tel: doc.data()!['tel'],
      address: doc.data()!['address'],
      updateDate: doc.data()!['updateDate']?.toDate(),
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
      credit: doc.data()!['credit'],
      paymentPeriod: doc.data()!['paymentPeriod'] ?? 0,
      email: doc.data()!['email'] ?? '',
      contactName: doc.data()!['contactName'] ?? '',
      businessClientType: BusinessClientType.values
          .elementAt(doc.data()!['businessClientType'] ?? 0),
      remark: doc.data()!['remark'] ?? '',
      whatsapp: doc.data()!['whatsapp'] ?? '',
      refNo: doc.data()!['refNo'] ?? '',
      businessClientStatus: BusinessClientStatus.values.elementAt(
          doc.data()!['businessClientStatus'] ??
              BusinessClientStatus.Active.index),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class BCBranch {
  DocumentReference? docRef;
  String branchName;
  String tel;
  String? address;
  String? contactName;
  DateTime createDate;
  DateTime updateDate;
  String whatsapp;

  BCBranch(
      {this.docRef,
      required this.branchName,
      this.tel = '',
      this.address,
      this.contactName,
      required this.createDate,
      required this.updateDate,
      this.whatsapp = ''});
  Map<String, dynamic> get toMap => {
        'branchName': branchName,
        'tel': tel,
        'address': address,
        'contactName': contactName,
        'createDate': createDate,
        'updateDate': updateDate,
        'whatsapp': whatsapp,
      };
  factory BCBranch.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BCBranch(
      docRef: doc.reference,
      branchName: doc.data()!['branchName'],
      tel: doc.data()!['tel'] ?? '',
      address: doc.data()!['address'] ?? '',
      contactName: doc.data()!['contactName'] ?? '',
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      whatsapp: doc.data()!['whatsapp'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

///Can be used in Business Client and Location(StockIn)
enum CreditRecordType {
  Payment,
  Change,
  CreditTransfer,
  Refund,
  CreditPayment,
}

class CreditRecord {
  DocumentReference? docRef;
  DateTime timestamp;
  num amount;
  String? remark;
  String staffId;
  String staffName;
  CreditRecordType creditRecordType;
  String? orderId;
  num creditBefore;
  num creditAfter;

  CreditRecord(
      {this.docRef,
      required this.timestamp,
      required this.amount,
      this.remark,
      required this.staffId,
      required this.staffName,
      required this.creditRecordType,
      this.orderId,
      required this.creditAfter,
      required this.creditBefore});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'amount': amount,
        'remark': remark,
        'staffId': staffId,
        'staffName': staffName,
        'creditRecordType': CreditRecordType.values.indexOf(creditRecordType),
        'orderId': orderId,
        'creditBefore': creditBefore,
        'creditAfter': creditAfter,
      };
  factory CreditRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CreditRecord(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      amount: doc.data()!['amount'],
      remark: doc.data()!['remark'],
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
      creditRecordType: CreditRecordType.values
          .elementAt(doc.data()?['creditRecordType'] ?? 0),
      orderId: doc.data()!['orderId'],
      creditBefore: doc.data()!['creditBefore'],
      creditAfter: doc.data()!['creditAfter'],
    );
  }
}

class ClientHistory {
  DocumentReference? docRef;
  DateTime timestamp;
  String text;
  String? uid;

  ClientHistory({
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
  factory ClientHistory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ClientHistory(
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
