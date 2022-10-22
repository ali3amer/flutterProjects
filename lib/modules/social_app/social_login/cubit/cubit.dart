import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/modules/social_app/social_login/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/shared/network/local/cache_helper.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  // late SocialLoginModel loginModel;
  //
  void userLogin({required email, required password}) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SocialLoginSuccessState(value.user!.uid));
      CacheHelper.saveData(key: "uId", value: value.user!.uid);
    }).catchError((onError) {
      print("error");
      emit(SocialLoginErrorState(onError.toString()));
      print(onError.toString());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialChangePasswordVisibilityState());
  }
}
