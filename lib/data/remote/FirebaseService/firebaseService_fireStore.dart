import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceFireStore {
  static Future<DocumentReference<Object?>> createDocument(
      String collection, Map<String, dynamic> data) async {
    CollectionReference collectionName =
        FirebaseFirestore.instance.collection(collection);
    try {
      return await collectionName.add(data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<DocumentReference<Object?>> createDocumentInCollection(
      String collection,
      String docId,
      String subCollection,
      Map<String, dynamic> data) async {
    CollectionReference collectionName = FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .collection(subCollection);
    try {
      return await collectionName.add(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setDocument(
      String collection, String docID, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .set(data, SetOptions(merge: true));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDocument(
      String collection, String docID, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .update(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteDocument(String collection, String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .delete();
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> checkExist(
      {required String collection, required String docID}) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .get()
          .then((doc) {
        return true;
      });
      return false;
    } catch (e) {
      // If any error
      return false;
    }
  }

  static Future<QuerySnapshot<Object?>> readCollection(String collection) {
    CollectionReference collectionName =
        FirebaseFirestore.instance.collection(collection);
    try {
      return collectionName.get();
    } catch (error) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot<Object?>> readDocument({
    required String collection,
    required String document,
  }) {
    DocumentReference documentName =
        FirebaseFirestore.instance.collection(collection).doc(document);
    try {
      return documentName.get();
    } catch (error) {
      rethrow;
    }
  }

  static Stream<QuerySnapshot<Object?>> listenByDocsIds(
      {required List walletsIds}) {
    CollectionReference collectionName =
        FirebaseFirestore.instance.collection('wallets');
    return collectionName
        .where(FieldPath.documentId, whereIn: walletsIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> listenToWallets({required String uId}) {
    CollectionReference collectionName =
        FirebaseFirestore.instance.collection('wallets');
    return collectionName
        .where('access', arrayContains: uId)
        .where('freezed', isEqualTo: false)
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> listenCollection(
      {required String collection}) {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(collection);
    return collectionReference.where('freezed', isEqualTo: false).snapshots();
  }

  static Stream<QuerySnapshot<Object?>> listenToFreezedWallets() {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('wallets');
    return collectionReference.where('freezed', isEqualTo: true).snapshots();
  }

  Stream<DocumentSnapshot<Object?>> listenDocument(
      {required String collection, required String document}) {
    DocumentReference docName =
        FirebaseFirestore.instance.collection(collection).doc(document);
    return docName.snapshots();
  }

  static WriteBatch createBatch2(
      {required String collection1,
      required String doc1,
      required Map<String, dynamic> data1,
      required String collection2,
      required String doc2,
      required Map<String, dynamic> data2}) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference ref1 =
        FirebaseFirestore.instance.collection(collection1).doc(doc1);
    batch.set(ref1, data1, SetOptions(merge: true));

    DocumentReference ref2 =
        FirebaseFirestore.instance.collection(collection2).doc(doc2);
    batch.set(ref2, data2, SetOptions(merge: true));

    return batch;
  }
}
