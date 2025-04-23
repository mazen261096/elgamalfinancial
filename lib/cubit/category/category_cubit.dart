import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'category_states.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitiateState());

  @override
  Future<void> close() {
    categorySub?.cancel();
    // TODO: implement close
    return super.close();
  }

  List category = [];
  StreamSubscription<DocumentSnapshot<Object?>>? categorySub;

  Future<void> fetchCategory() async {
    try {
      emit(CategoryFetchLoadingState());
      if (categorySub != null) categorySub!.cancel();
      categorySub = FirebaseServiceFireStore()
          .listenDocument(collection: 'category', document: 'category')
          .listen((value) {
        if (value.data() != null) {
          Map categoryDocument = value.data() as Map<String, dynamic>;
          category = categoryDocument['category'];
        } else {
          category = [];
        }

        emit(CategoryFetchSuccessState());
      });
    } catch (error) {
      emit(CategoryFetchFailedState());
      rethrow;
    }
  }

  Future<void> addCategory(String categoryName) async {
    try {
      emit(CategoryAddLoadingState());
      await FirebaseServiceFireStore().updateDocument('category', 'category', {
        'category': FieldValue.arrayUnion([categoryName])
      }).then((value) {
        emit(CategoryAddSuccessState());
      });
    } catch (error) {
      emit(CategoryAddFailedState());
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    try {
      emit(CategoryDeleteLoadingState());
      await FirebaseServiceFireStore().updateDocument('category', 'category', {
        'category': FieldValue.arrayRemove([categoryName])
      }).then((value) {
        emit(CategoryDeleteSuccessState());
      });
    } catch (error) {
      emit(CategoryDeleteFailedState());
      rethrow;
    }
  }

  bool isExist(String categoryName) {
    return category.contains(categoryName);
  }
}
