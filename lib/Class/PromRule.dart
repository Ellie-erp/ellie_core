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
List<PromRuleUserList>? promRuleUserList;





  PromRule({this.docRef, required this.createDate, required this.updateDate,required this.ruleName ,this.isDateRequired=false, this.startDate, this.endDate, required this.promRuleStatus, this.allowRetail=false,  this.allowWholesale=false, this.allowOnline=false, this.allowStockIn=false, required this.promListId, this.isAllUser=true, this.promRuleUserList});
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
    'promRuleUserList': (promRuleUserList ?? []).map((e) => e.toMap).toList(),
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
      promRuleUserList: List<PromRuleUserList>.from((doc.data()!['promRuleUserList'] ?? []).map((e) => PromRuleUserList.fromMap(e)).toList()),
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
