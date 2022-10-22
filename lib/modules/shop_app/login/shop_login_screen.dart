import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_screen/layout/shop_app/shop_layout.dart';
import 'package:login_screen/modules/shop_app/login/cubit/cubit.dart';
import 'package:login_screen/modules/shop_app/login/cubit/states.dart';
import 'package:login_screen/modules/shop_app/register/shop_register_screen.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
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
                            "LOGIN",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.black),
                          ),
                          Text(
                            "login now and browse our hot offers",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 30.0),
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
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              label: "Password",
                              isPassword:
                                  ShopLoginCubit.get(context).isPassword,
                              onSubmit: (value) {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              suffix: ShopLoginCubit.get(context).suffix,
                              suffixPressed: () {
                                ShopLoginCubit.get(context)
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
                              condition: state is! ShopLoginLoadingState,
                              builder: (context) => defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      ShopLoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  text: "login"),
                              fallback: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't Have An Account?"),
                              defaultTextButton(
                                  function: () {
                                    navigateTo(context, ShopRegisterScreen());
                                  },
                                  text: "register now")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
