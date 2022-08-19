import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellie_core/Class/Info.dart';

///ERP用通訊錄, 預定建立在每個Dempartment enum.方便紀錄及聯絡
class AddressBook {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String contactName;
  String tel;
  String remark;
  String whatsappNo;
  String emailAddress;
  String companyName;
  Department department;
  String website;
  String address;
  String tel2;
  String tel3;
  String connectId;
  String jobTitle;

  AddressBook(
      {this.docRef,
      required this.createDate,
      required this.contactName,
      this.tel = '',
      this.remark = '',
      this.whatsappNo = '',
      this.emailAddress = '',
      this.companyName = '',
      required this.updateDate,
      required this.department,
      this.website = '',
      this.address = '',
      this.tel2 = '',
      this.tel3 = '',
      this.connectId = '',
      this.jobTitle = ''});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'contactName': contactName,
        'tel': tel,
        'remark': remark,
        'whatsappNo': whatsappNo,
        'emailAddress': emailAddress,
        'companyName': companyName,
        'department': Department.values.indexOf(department),
        'website': website,
        'address': address,
        'tel2': tel2,
        'tel3': tel3,
        'connectId': connectId,
        'jobTitle': jobTitle,
      };
  factory AddressBook.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AddressBook(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      contactName: doc.data()!['contactName'],
      tel: doc.data()!['tel'],
      remark: doc.data()!['remark'],
      whatsappNo: doc.data()!['whatsappNo'],
      emailAddress: doc.data()!['emailAddress'],
      companyName: doc.data()!['companyName'],
      department: Department.values.elementAt(doc.data()?['department'] ?? 0),
      website: doc.data()!['website'],
      address: doc.data()!['address'],
      tel2: doc.data()!['tel2'],
      tel3: doc.data()!['tel3'],
      connectId: doc.data()!['connectId'] ?? '',
      jobTitle: doc.data()!['jobTitle'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
