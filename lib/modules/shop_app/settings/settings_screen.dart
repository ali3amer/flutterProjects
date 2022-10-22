import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/shop_app/cubit/cubit.dart';
import 'package:login_screen/layout/shop_app/cubit/states.dart';
import 'package:login_screen/models/shop_app/login_model.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopLoginModel model = ShopCubit.get(context).userModel!;
        nameController.text = model.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if (state is ShopLoadingUpdateUserState)
                          LinearProgressIndicator(),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            label: "Name",
                            prefix: Icons.person,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Name Must Not Be Empty";
                              }
                            }),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: "Email Address",
                            prefix: Icons.email,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Email Must Not Be Empty";
                              }
                            }),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: "Phone",
                            prefix: Icons.phone,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Phone Must Not Be Empty";
                              }
                            }),
                        const SizedBox(height: 20.0),
                        defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              ShopCubit.get(context).updateUserData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text);
                            }
                          },
                          text: "Update",
                        ),
                        const SizedBox(height: 20.0),
                        defaultButton(
                          function: () => singOut(context),
                          text: "Logout",
                        )
                      ],
                    ),
                  ),
                ),
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }
}
