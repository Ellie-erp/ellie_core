import 'package:cloud_firestore/cloud_firestore.dart';

enum PromRuleStatus{
  Active,
  Inactive,
}

enum RuleType{
  R1Discount,   ///A款貨品獲得折扣/減價/促銷價
  R2Staired    ///A階梯式貨品獲得折扣/減價/促銷價
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
  List? promRuleUserList;   ///List of members will store in this list
  List? pluArray;   ///List of the product will store in this list
  bool isAllplu;  ///decide if the plu list is all selected.

  bool isAllRetail;   /// allow all shop on the list.
  bool isAllWholesale;  /// allow sales user  on the list.
  bool isAllOnline;  /// allow all online shop on the list.
  bool isAllStockIn;  /// allow all shop on the list.
  List? retailArray;
  List? wholesaleArray;
  List? onlineArray;
  List? stockInArray;



  PromRule({this.docRef, required this.createDate, required this.updateDate,required this.ruleName ,this.isDateRequired=false, this.startDate, this.endDate, required this.promRuleStatus, this.allowRetail=false,  this.allowWholesale=false, this.allowOnline=false, this.allowStockIn=false, required this.promListId, this.isAllUser=true, this.promRuleUserList, required this.pluArray, this.isAllplu=true, this.isAllRetail=true, this.isAllWholesale=true, this.isAllOnline=true, this.isAllStockIn=true, required this.retailArray, required this.wholesaleArray, required this.onlineArray, required this.stockInArray});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,      
        'ruleName': ruleName,  
        'isDateRequired': isDateRequired,
        'startDate': startDate,
        'endDate': endDate,
    'promRuleStatus' : PromRuleStatus.values.indexOf(this.promRuleStatus),
    'allowRetail' : allowRetail,
    'allowWholesale' : allowWholesale,
    'allowOnline' : allowOnline,
    'allowStockIn' : allowStockIn,
    'promListId' : promListId,
    'isAllUser' : isAllUser,
    'promRuleUserList': promRuleUserList,
    'pluArray' : pluArray,
    'isAllplu' : isAllplu,
    'isAllRetail' : isAllRetail,
    'isAllWholesale' : isAllWholesale,
    'isAllOnline' : isAllOnline,
    'isAllStockIn' : isAllStockIn,
    'retailArray' : retailArray,
    'wholesaleArray' : wholesaleArray,
    'onlineArray' : onlineArray,
    'stockInArray' : stockInArray,
      };


  factory PromRule.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromRule(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      ruleName: doc.data()!['ruleName'],
      isDateRequired: doc.data()!['isDateRequired']?? false,
      startDate: doc.data()!['startDate']?.toDate() ?? DateTime.now(),
      endDate: doc.data()!['endDate']?.toDate() ?? DateTime.now(),
      promRuleStatus: PromRuleStatus.values.elementAt(doc.data()?['promRuleStatus'] ?? 0),
      allowRetail: doc.data()!['allowRetail']?? false,
      allowWholesale: doc.data()!['allowWholesale']?? false,
      allowOnline: doc.data()!['allowOnline']?? false,
      allowStockIn: doc.data()!['allowStockIn']?? false,
      promListId: doc.data()!['promListId'],
      isAllUser: doc.data()!['isAllUser']?? true,
      promRuleUserList: doc.data()?['promRuleUserList'] ?? [],
      pluArray: doc.data()?['pluArray'] ?? [],
      isAllplu: doc.data()!['isAllplu']?? true,
      isAllRetail: doc.data()!['isAllRetail']?? true,
      isAllWholesale: doc.data()!['isAllWholesale']?? true,
      isAllOnline: doc.data()!['isAllOnline']?? true,
      isAllStockIn: doc.data()!['isAllStockIn']?? true,
      retailArray: doc.data()?['retailArray'] ?? [],
      wholesaleArray: doc.data()?['wholesaleArray'] ?? [],
      onlineArray: doc.data()?['onlineArray'] ?? [],
      stockInArray: doc.data()?['stockInArray'] ?? [],

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}





class PromRuleUserList {
  String userId;



  PromRuleUserList({ required this.userId});

  Map<String, dynamic> get toMap => {
    'userId': userId,


  };

  factory PromRuleUserList.fromMap(Map<String, dynamic> map) {
    return PromRuleUserList(
      userId: map['userId'],

    );
  }}





class PromRuleItem {
  DocumentReference? docRef;
  String plu; 
  String name;



  PromRuleItem({this.docRef,required this.plu,required this.name});
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
