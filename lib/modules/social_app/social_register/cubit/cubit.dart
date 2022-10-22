import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/models/shop_app/login_model.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/models/social_app/social_user_model.dart';
import 'package:login_screen/modules/shop_app/register/cubit/states.dart';
import 'package:login_screen/modules/social_app/social_register/cubit/states.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  // late SocialLoginModel loginModel;
  //
  void userRegister({
    required name,
    required email,
    required password,
    required phone,
    required image,
    required cover,
    required bio,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      var uid = value.user!.uid;
      userCreate(
          uId: uid,
          name: name,
          email: email,
          phone: phone,
          image: image,
          cover: cover,
          bio: bio);
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required uId,
    required name,
    required email,
    required phone,
    required image,
    required cover,
    required bio,
  }) {
    SocialUserModel? model = SocialUserModel(
        uId: uId,
        name: name,
        email: email,
        phone: phone,
        image: image,
        isEmailVerified: false,
        bio: bio,
        cover: cover);
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error));
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
