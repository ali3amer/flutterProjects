import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/modules/shop_app/register/cubit/cubit.dart';
import 'package:login_screen/modules/shop_app/register/cubit/states.dart';

import '../../../layout/shop_app/shop_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../login/cubit/cubit.dart';

class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                      key: "token", value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token!;
                CacheHelper.saveData(key: "token", value: token);
                navigateAndFinish(context, ShopLayout());
              });
              showToast(
                  text: state.loginModel.message!, state: ToastStates.SUCCESS);
            } else {
              showToast(
                  text: state.loginModel.message!, state: ToastStates.WARNIG);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REGISTER",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          "Register now and browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            label: "User Name",
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Name Must Not Be Empty";
                              }
                            },
                            prefix: Icons.person),
                        const SizedBox(height: 15.0),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: "Email",
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Email Address Must Not Be Empty";
                              }
                            },
                            prefix: Icons.email_outlined),
                        const SizedBox(height: 15.0),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: "Phone",
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Phone Must Not Be Empty";
                              }
                            },
                            prefix: Icons.person),
                        const SizedBox(height: 15.0),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            label: "Password",
                            isPassword:
                                ShopRegisterCubit.get(context).isPassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            suffix: ShopRegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              ShopRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Password Is Too Short";
                              }
                            },
                            prefix: Icons.lock_outline),
                        const SizedBox(height: 15.0),
                        ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder: (context) => defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                text: "Register"),
                            fallback: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
