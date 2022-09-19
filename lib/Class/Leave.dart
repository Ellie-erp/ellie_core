import 'package:cloud_firestore/cloud_firestore.dart';

enum LeaveType {
  UnpaidLeave,
  SickLeave,
  AnnualLeave,
  CompensatoryLeave,
  MaternityLeave, ///產假
  PaternityLeave, ///陪產假
}

enum ApprovalStatus { Processing, Approved, Denied }

///HR 請假用 class,計AL, WIP
///需要諗消假安排
class Leave {
  DocumentReference? docRef;
  DateTime timestamp;
  String userId;
  String userName;
  DateTime startDate;
  DateTime endDate;
  String remark;
  List<String>? document;
  LeaveType leaveType;
  ApprovalStatus approvalStatus;
  String companyId;

  Leave(
      {this.docRef,
      required this.timestamp,
      required this.userId,
      required this.userName,
      required this.startDate,
      required this.endDate,
      this.remark = '',
      this.document,
      required this.approvalStatus,
      required this.leaveType,
      required this.companyId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'userId': userId,
        'userName': userName,
        'startDate': startDate,
        'endDate': endDate,
        'remark': remark,
        'document': document,
        'leaveType': LeaveType.values.indexOf(leaveType),
        'approvalStatus': ApprovalStatus.values.indexOf(approvalStatus),
    'companyId': companyId,
      };
  factory Leave.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Leave(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      userId: doc.data()!['userId'],
      userName: doc.data()!['userName'],
      startDate: doc.data()!['startDate']?.toDate(),
      endDate: doc.data()!['endDate']?.toDate(),
      remark: doc.data()!['remark'],
      document: doc.data()!['document'],
      leaveType:
          LeaveType.values.elementAt(doc.data()!['leaveType'] ?? 0),
      approvalStatus:
          ApprovalStatus.values.elementAt(doc.data()!['approvalStatus'] ?? 0),
      companyId: doc.data()!['companyId']?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
