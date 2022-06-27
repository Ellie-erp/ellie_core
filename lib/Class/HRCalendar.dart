import 'package:cloud_firestore/cloud_firestore.dart';



enum HRLeaveType{
  UnpaidLeave,
  SickLeave,
  AnnualLeave,
  CompensatoryLeave,
  MaternityLeave,
  PaternityLeave,
}
enum ApprovalStatus {
  Processing,
  Approved,
  Denied
}

///HR 請假用 class,計AL, WIP
///需要諗消假安排
class HRCalendar {
  DocumentReference? docRef;
  DateTime timestamp; 
  String identityId;
  String identityName;
  DateTime startDate;
  DateTime endDate;
  String remark;
  List<String>? document;
  HRLeaveType hrLeaveType;
  ApprovalStatus approvalStatus;




  HRCalendar({this.docRef,required this.timestamp,required this.identityId,required this.identityName , required this.startDate,required this.endDate, this.remark='', this.document, required this.approvalStatus, required this.hrLeaveType });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'identityId': identityId,      
        'identityName': identityName,  
        'startDate': startDate,  
        'endDate': endDate,  
        'remark': remark,  
        'document': document,
    'hrLeaveType' : HRLeaveType.values.indexOf(hrLeaveType),
'approvalStatus': ApprovalStatus.values.indexOf(approvalStatus),

      };
  factory HRCalendar.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return HRCalendar(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      identityId: doc.data()!['identityId'],
      identityName: doc.data()!['identityName'],
      startDate: doc.data()!['startDate']?.toDate(),
      endDate: doc.data()!['endDate']?.toDate(),
      remark: doc.data()!['remark'],
      document: doc.data()!['document'],
 hrLeaveType: HRLeaveType.values.elementAt(doc.data()!['hrLeaveType']?? 0),
      approvalStatus: ApprovalStatus.values.elementAt(doc.data()!['approvalStatus']?? 0),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}