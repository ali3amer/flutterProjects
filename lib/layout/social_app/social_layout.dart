import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/models/social_app/social_user_model.dart';
import 'package:login_screen/modules/social_app/new_post/new_post_screen.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/styles/Iconly-Broken_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'cubit/cubit.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: () {}, icon: Icon(IconlyBroken.notification)),
              IconButton(onPressed: () {}, icon: Icon(IconlyBroken.search)),
            ],
          ),
          // body: ConditionalBuilder(
          //     condition: SocialCubit.get(context).model != null,
          //     builder: (context) {
          //       print(uId);
          //       SocialUserModel model = SocialCubit.get(context).model!;
          //       return Column(
          //         children: [
          //           if (FirebaseAuth.instance.currentUser!.emailVerified ==
          //               false)
          //             Container(
          //                 color: Colors.amber.withOpacity(0.6),
          //                 child: Padding(
          //                   padding:
          //                       const EdgeInsets.symmetric(horizontal: 20.0),
          //                   child: Row(
          //                     children: [
          //                       const Icon(Icons.info_outline),
          //                       const SizedBox(width: 15.0),
          //                       const Expanded(
          //                         child: Text("Please Verify Your Email"),
          //                       ),
          //                       const SizedBox(width: 15.0),
          //                       defaultTextButton(
          //                           function: () {
          //                             FirebaseAuth.instance.currentUser
          //                                 ?.sendEmailVerification()
          //                                 .then((value) {
          //                               showToast(
          //                                   text: "Check Your Mail",
          //                                   state: ToastStates.SUCCESS);
          //                             }).catchError((onError) {});
          //                           },
          //                           text: "SEND")
          //                     ],
          //                   ),
          //                 )),
          //         ],
          //       );
          //     },
          //     fallback: (context) =>
          //         const Center(child: CircularProgressIndicator())),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(IconlyBroken.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(IconlyBroken.chat), label: "Chats"),
                BottomNavigationBarItem(
                    icon: Icon(IconlyBroken.paperUpload), label: "Post"),
                BottomNavigationBarItem(
                    icon: Icon(IconlyBroken.location), label: "Users"),
                BottomNavigationBarItem(
                    icon: Icon(IconlyBroken.setting), label: "Settings"),
              ]),
        );
      },
    );
  }
}
