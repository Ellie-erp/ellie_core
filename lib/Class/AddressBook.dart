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




  AddressBook({this.docRef,required this.createDate,required this.contactName, this.tel='' ,this.remark='', this.whatsappNo='', this.emailAddress='',this.companyName='', required this.updateDate, required this.department, this.website='', this.address=''});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
    'updateDatea': updateDate,
        'contactName': contactName,
        'tel': tel,
        'remark': remark,
        'whatsappNo': whatsappNo,
        'emailAddress': emailAddress,
 'companyName' : companyName,
    'department': Department.values.indexOf(department),
    'website' : website,
    'address' : address,
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
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}