import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/social_app/social_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../social_register/social_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {
  SocialLoginScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: "uId", value: state.uId).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
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
                            "login now to communicate with friends",
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
                                  SocialLoginCubit.get(context).isPassword,
                              onSubmit: (value) {
                                if (formKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              suffix: SocialLoginCubit.get(context).suffix,
                              suffixPressed: () {
                                SocialLoginCubit.get(context)
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
                              condition: state is! SocialLoginLoadingState,
                              builder: (context) => defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      SocialLoginCubit.get(context).userLogin(
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
                                    navigateTo(context, SocialRegisterScreen());
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
