import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/models/shop_app/login_model.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/modules/shop_app/register/cubit/states.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userRegister(
      {required name, required email, required password, required phone}) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: REGISTER, data: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      print(loginModel.data.toString());

      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((onError) {
      print("error");
      emit(ShopRegisterErrorState(onError.toString()));
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
