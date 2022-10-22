import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/models/shop_app/categories_model.dart';
import 'package:login_screen/models/shop_app/change_favorites_model.dart';
import 'package:login_screen/models/shop_app/favorites_model.dart';
import 'package:login_screen/modules/shop_app/categories/categories_screen.dart';
import 'package:login_screen/modules/shop_app/favorites/favorites_screen.dart';
import 'package:login_screen/modules/shop_app/products/products_screen.dart';
import 'package:login_screen/modules/shop_app/settings/settings_screen.dart';
import 'package:login_screen/layout/shop_app/cubit/states.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

import '../../../models/shop_app/home_model.dart';
import '../../../models/shop_app/login_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool>? favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(value.statusCode);
      homeModel!.data.products.forEach((element) {
        favorites!.addAll({element.id: element.inFavorites});
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    emit(ShopLoadingCategoriesState());

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites![productId] = !favorites![productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {"product_id": productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (changeFavoritesModel!.status == false) {
        favorites![productId] = !favorites![productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites![productId] = !favorites![productId]!;

      emit(ShopErrorChangeFavoritesState());
      print(error.toString());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required name,
    required email,
    required phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      "name": name,
      "email": email,
      "phone": phone,
    }).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
