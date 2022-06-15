import 'package:cloud_firestore/cloud_firestore.dart';

enum EXPStatus {
  DRAFT,
  ACTIVE,
  DISABLE,
}

class Expense {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String seller;
  num transportCost;
  EXPStatus expStatus;
  num total;
  String refNo;
  String staffId;
  String staffName;
  String remark;
  String locationId;
  String locationName;

  Expense(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.seller,
      this.transportCost=0,
      required this.expStatus,
      this.total=0,
      this.refNo='',
      required this.staffId,
      required this.staffName,
      required this.remark,
      required this.locationId,
        required this.locationName,
      });
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,
        'expStatus': EXPStatus.values.indexOf(expStatus),
        'total': total,
        'refNo': refNo,
        'staffId': staffId,
        'staffName': staffName,
        'remark': remark,
    'locationId' : locationId,
    'locationName' : locationName,
      };

  factory Expense.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Expense(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      seller: doc.data()?['seller'],
      transportCost: doc.data()?['transportCost'] ?? 0,
      expStatus: EXPStatus.values.elementAt(doc.data()!['expStatus'] ?? 0),
      total: doc.data()?['total'] ?? 0,
      refNo: doc.data()?['refNo'] ?? '',
      staffId: doc.data()?['staffId'],
      staffName: doc.data()?['staffName'],
      remark: doc.data()?['remark'],
      locationId:  doc.data()?['locationId'],
      locationName: doc.data()?['locationName'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
