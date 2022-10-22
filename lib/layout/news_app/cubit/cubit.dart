import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/news_app/cubit/states.dart';

import '../../../modules/news_app/business/business_screen.dart';
import '../../../modules/news_app/science/science_screen.dart';
import '../../../modules/news_app/sports/sports_screen.dart';
import '../../../modules/settings_screen/settings_screen.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.business), label: "Business"),
    const BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Sports"),
    const BottomNavigationBarItem(icon: Icon(Icons.science), label: "Science"),
  ];

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    print("hhhhhhhh");
    if (business.isEmpty) {
      emit(NewsGetBusinessLoadingState());
      DioHelper.getData(url: "v2/top-headlines", query: {
        "country": "eg",
        "category": "business",
        "apiKey": "65f7f556ec76449fa7dc7c0069f040ca",
      }).then((value) {
        business = value.data["articles"];
        print("this is business $business");
        emit(NewsGetBusinessSuccessState());
      }).catchError((onError) {
        emit(NewsGetBusinessErrorState(error: onError.toString()));
        print(onError.toString());
      });
    } else {
      emit(NewsGetBusinessSuccessState());
    }
  }

  List<dynamic> sports = [];

  void getSports() {
    if (sports.isEmpty) {
      emit(NewsGetSportsLoadingState());
      DioHelper.getData(url: "v2/top-headlines", query: {
        "country": "eg",
        "category": "sports",
        "apiKey": "65f7f556ec76449fa7dc7c0069f040ca",
      }).then((value) {
        sports = value.data["articles"];
        print("this is business $sports");
        emit(NewsGetSportsSuccessState());
      }).catchError((onError) {
        emit(NewsGetSportsErrorState(error: onError.toString()));
        print(onError.toString());
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    if (science.isEmpty) {
      emit(NewsGetScienceLoadingState());
      DioHelper.getData(url: "v2/top-headlines", query: {
        "country": "eg",
        "category": "science",
        "apiKey": "65f7f556ec76449fa7dc7c0069f040ca",
      }).then((value) {
        science = value.data["articles"];
        print("this is business $science");
        emit(NewsGetScienceSuccessState());
      }).catchError((onError) {
        emit(NewsGetScienceErrorState(error: onError.toString()));
        print(onError.toString());
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(url: "v2/everything", query: {
      "q": value,
      "apiKey": "65f7f556ec76449fa7dc7c0069f040ca",
    }).then((value) {
      search = value.data["articles"];
      print("this is business $search");
      emit(NewsGetScienceSuccessState());
    }).catchError((onError) {
      emit(NewsGetScienceErrorState(error: onError.toString()));
      print(onError.toString());
    });
  }
}
