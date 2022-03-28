import 'package:cloud_firestore/cloud_firestore.dart';

/// a user list mananging the current user who registered in the ERP system. For interApp uses such as order taking.
/// NOT for managing the account detail/authentication/

enum UserType {
  Client,
  Staff,
}

class UserList {
  DocumentReference? docRef;
  DateTime createDate;
  String? displayName;
  String? email;
  num? credit;
  List<DelAddress>? delAddress;
  num? paymentPeriod;
  UserType userType;
  Map<String, bool> permissions;
  String role;

  UserList(
      {this.docRef,
      required this.createDate,
      this.displayName,
      this.email,
      this.delAddress,
      this.credit,
      this.paymentPeriod,
      this.userType = UserType.Client,
      this.permissions = const {},
      this.role = ''});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'displayName': displayName,
        'email': email,
        'delAddress': (delAddress ?? []).map((e) => e.toMap).toList(),
        'credit': credit,
        'paymentPeriod': paymentPeriod,
        'userType': userType.index,
      };
  factory UserList.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserList(
        docRef: doc.reference,
        createDate: doc.data()!['createDate']?.toDate(),
        displayName: doc.data()!['displayName'] ?? 'Undefined',
        email: doc.data()!['email'] ?? '',
        delAddress: List<DelAddress>.from((doc.data()?['delAddress'] ?? [])
            .map((e) => DelAddress.fromMap(e))
            .toList()),
        credit: doc.data()!['credit'],
        paymentPeriod: doc.data()!['paymentPeriod'] ?? 0,
        userType: UserType.values.elementAt(doc.data()!['userType'] ?? 0),
        permissions:
            (doc.data()!['permissions'] as Map?)?.cast<String, bool>() ?? {},
        role: doc.data()!['role'] ?? '');
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class DelAddress {
  String? address;
  String? remark;

  DelAddress({this.address, this.remark});

  Map<String, dynamic> get toMap => {
        'address': address,
        'remark': remark,
      };

  factory DelAddress.fromMap(Map<String, dynamic> map) {
    return DelAddress(
      address: map['address'],
      remark: map['remark'],
    );
  }
}
