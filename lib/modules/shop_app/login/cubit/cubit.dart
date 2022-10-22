import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/models/shop_app/login_model.dart';
import 'package:login_screen/modules/shop_app/login/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userLogin({required email, required password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(url: LOGIN, data: {
      "email": email,
      "password": password,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      print(loginModel.data.toString());

      emit(ShopLoginSuccessState(loginModel));
    }).catchError((onError) {
      print("error");
      emit(ShopLoginErrorState(onError.toString()));
      print(onError.toString());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}
