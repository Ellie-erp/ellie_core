import 'package:cloud_firestore/cloud_firestore.dart';

enum LeaveType {
  UnpaidLeave,
  SickLeave,
  AnnualLeave,
  CompensatoryLeave,
  MaternityLeave, ///產假
  PaternityLeave, ///陪產假
  PersonalLeave,
}

extension LeaveTypeExts on LeaveType {
  String get Chinese {
    switch (this) {
      case  LeaveType.UnpaidLeave:
        return '無薪假';
      case LeaveType.SickLeave:
        return '病假';
      case  LeaveType.AnnualLeave:
        return '年假';
      case LeaveType.CompensatoryLeave:
        return '補假';
      case LeaveType.MaternityLeave:
        return '產假';
      case LeaveType.PaternityLeave:
        return '陪產假';
      case LeaveType.PersonalLeave:
        return '事假';
    }
  }
}


extension LeaveTypeExts2 on LeaveType {
  String get ShortName {
    switch (this) {
      case  LeaveType.UnpaidLeave:
        return 'NPL';
      case LeaveType.SickLeave:
        return 'SL';
      case  LeaveType.AnnualLeave:
        return 'AL';
      case LeaveType.CompensatoryLeave:
        return 'CL';
      case LeaveType.MaternityLeave:
        return 'ML';
      case LeaveType.PaternityLeave:
        return 'PL';
      case LeaveType.PersonalLeave:
        return 'PL';
    }
  }
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
      this.companyId='',
      });
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
