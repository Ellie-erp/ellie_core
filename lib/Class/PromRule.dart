import 'package:cloud_firestore/cloud_firestore.dart';

enum PromRuleStatus {
  Active,
  Inactive,
}

enum RuleType {
  ///A款貨品獲得折扣/減價/促銷價
  R1Discount,

  ///A階梯式貨品獲得折扣/減價/促銷價
  R2Staired,

  ///暫不推出

  ///組合式貨品獲得一個促銷價
  R3Package,

  ///暫不推出

}

extension RuleTypeExt on RuleType {
  String get longName {
    switch (this) {
      case RuleType.R1Discount:
        return 'A款貨品獲得折扣/減價/促銷價';
      case RuleType.R2Staired:
        return '階梯式貨品獲得折扣/減價/促銷價';
      case RuleType.R3Package:
        return '組合式貨品獲得一個促銷價';
    }
  }
}

enum DiscountType {
  ///15 = 15%OFF
  Discount,

  Deduction,
  SpecialPrice,
}

class PromRule {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String ruleName;
  bool isDateRequired;
  DateTime? startDate;
  DateTime? endDate;
  PromRuleStatus promRuleStatus;
  bool allowRetail;
  bool allowWholesale;
  bool allowOnline;
  bool allowStockIn;
  String promListId;
  bool isAllUser;

  ///List of members will store in this list
  List? promRuleUserList;

  ///List of the product will store in this list
  List? pluArray;

  ///decide if the plu list is all selected.
  bool isAllplu;

  /// allow all shop on the list.
  bool isAllRetail;

  /// allow sales user  on the list.
  bool isAllWholesale;

  /// allow Business Client  on the list.
  bool isAllBC;

  /// allow all online shop on the list.
  bool isAllOnline;

  /// allow all shop on the list.
  bool isAllStockIn;

  List? retailArray;
  List? wholesaleArray;
  List? BCArray;
  List? onlineArray;
  List? stockInArray;
  num ruleValue;

  /// Discount value: e.g.40%,
  DiscountType discountType;
  RuleType ruleType;

  PromRule(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.ruleName,
      this.isDateRequired = false,
      this.startDate,
      this.endDate,
      required this.promRuleStatus,
      this.allowRetail = false,
      this.allowWholesale = false,
      this.allowOnline = false,
      this.allowStockIn = false,
      required this.promListId,
      this.isAllUser = true,
      this.promRuleUserList,
      required this.pluArray,
      this.isAllplu = true,
      this.isAllRetail = true,
      this.isAllWholesale = true,
      this.isAllBC = true,
      this.isAllOnline = true,
      this.isAllStockIn = true,
      required this.retailArray,
      required this.wholesaleArray,
      required this.BCArray,
      required this.onlineArray,
      required this.stockInArray,
      required this.discountType,
      this.ruleValue = 0,
      required this.ruleType});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'ruleName': ruleName,
        'isDateRequired': isDateRequired,
        'startDate': startDate,
        'endDate': endDate,
        'promRuleStatus': PromRuleStatus.values.indexOf(this.promRuleStatus),
        'allowRetail': allowRetail,
        'allowWholesale': allowWholesale,
        'allowOnline': allowOnline,
        'allowStockIn': allowStockIn,
        'promListId': promListId,
        'isAllUser': isAllUser,
        'promRuleUserList': promRuleUserList,
        'pluArray': pluArray,
        'isAllplu': isAllplu,
        'isAllBC': isAllBC,
        'isAllRetail': isAllRetail,
        'isAllWholesale': isAllWholesale,
        'isAllOnline': isAllOnline,
        'isAllStockIn': isAllStockIn,
        'retailArray': retailArray,
        'wholesaleArray': wholesaleArray,
        'BCArray': BCArray,
        'onlineArray': onlineArray,
        'stockInArray': stockInArray,
        'discountType': DiscountType.values.indexOf(this.discountType),
        'ruleType': RuleType.values.indexOf(this.ruleType),
        'ruleValue': ruleValue,
      };

  factory PromRule.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromRule(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      ruleName: doc.data()!['ruleName'],
      isDateRequired: doc.data()!['isDateRequired'] ?? false,
      startDate: doc.data()!['startDate']?.toDate() ?? DateTime.now(),
      endDate: doc.data()!['endDate']?.toDate() ?? DateTime.now(),
      promRuleStatus:
          PromRuleStatus.values.elementAt(doc.data()?['promRuleStatus'] ?? 0),
      allowRetail: doc.data()!['allowRetail'] ?? false,
      allowWholesale: doc.data()!['allowWholesale'] ?? false,
      allowOnline: doc.data()!['allowOnline'] ?? false,
      allowStockIn: doc.data()!['allowStockIn'] ?? false,
      promListId: doc.data()!['promListId'],
      isAllUser: doc.data()!['isAllUser'] ?? true,
      promRuleUserList: doc.data()?['promRuleUserList'] ?? [],
      pluArray: doc.data()?['pluArray'] ?? [],
      isAllplu: doc.data()!['isAllplu'] ?? true,
      isAllRetail: doc.data()!['isAllRetail'] ?? true,
      isAllWholesale: doc.data()!['isAllWholesale'] ?? true,
      isAllBC: doc.data()!['isAllBC'] ?? true,
      isAllOnline: doc.data()!['isAllOnline'] ?? true,
      isAllStockIn: doc.data()!['isAllStockIn'] ?? true,
      retailArray: doc.data()?['retailArray'] ?? [],
      wholesaleArray: doc.data()?['wholesaleArray'] ?? [],
      onlineArray: doc.data()?['onlineArray'] ?? [],
      stockInArray: doc.data()?['stockInArray'] ?? [],
      BCArray: doc.data()?['BCArray'] ?? [],
      discountType:
          DiscountType.values.elementAt(doc.data()?['discountType'] ?? 0),
      ruleType: RuleType.values.elementAt(doc.data()?['ruleType'] ?? 0),
      ruleValue: doc.data()?['ruleValue'] ?? [],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class PromRuleUserList {
  String userId;

  PromRuleUserList({required this.userId});

  Map<String, dynamic> get toMap => {
        'userId': userId,
      };

  factory PromRuleUserList.fromMap(Map<String, dynamic> map) {
    return PromRuleUserList(
      userId: map['userId'],
    );
  }
}

class PromRuleItem {
  DocumentReference? docRef;
  String plu;
  String name;

  PromRuleItem({this.docRef, required this.plu, required this.name});
  Map<String, dynamic> get toMap => {
        'plu': plu,
        'name': name,
      };
  factory PromRuleItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromRuleItem(
      docRef: doc.reference,
      plu: doc.data()!['plu'],
      name: doc.data()!['name'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
