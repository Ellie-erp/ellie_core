import 'package:cloud_firestore/cloud_firestore.dart';


///訂單以外的運輸工作由這class處理
class DeliveryJob {
  DocumentReference? docRef;
  DateTime createDate; 
  String jobTitle;
  String Address;
  String? remark;
  DateTime? arrivedDate;




  DeliveryJob({this.docRef,required this.createDate,required this.jobTitle,required this.Address ,this.remark, this.arrivedDate,});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'jobTitle': jobTitle,
        'Address': Address,
        'remark': remark,
        'arrivedDate': arrivedDate,


      };
  factory DeliveryJob.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DeliveryJob(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      jobTitle: doc.data()!['jobTitle'],
      Address: doc.data()!['Address'],
      remark: doc.data()!['remark']?? '',
      arrivedDate: doc.data()!['arrivedDate']?.toDate(),


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}