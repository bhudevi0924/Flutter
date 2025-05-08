import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
  }

  Future addUserOrderDetails(Map<String, dynamic> userOrderMap, String id, String orderId) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("orders").doc(orderId).set(userOrderMap);
  }

  Future addAdminOrderDetails(Map<String, dynamic> userOrderMap, String orderId) async {
    return await FirebaseFirestore.instance.collection("orders").doc(orderId).set(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String id) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("orders").snapshots();
  }

  Future <QuerySnapshot> getUserWallet(String email) async {
    return await FirebaseFirestore.instance.collection("users").where("Email", isEqualTo: email).get();
  }

  Future updateUserWallet(String id, String amount) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).update({"Wallet": amount});
  }

  Future addUserTransactionDetails(Map<String, dynamic> userTransactionMap, String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("transactions").add(userTransactionMap);
  }

  Future<Stream<QuerySnapshot>> getUserTransactions(String id) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("transactions").snapshots();
  }
}