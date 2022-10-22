import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/models/social_app/massage_model.dart';
import 'package:login_screen/models/social_app/social_user_model.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/shared/styles/colors.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel socialUserModel;
  ChatDetailsScreen({Key? key, required this.socialUserModel})
      : super(key: key);
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: socialUserModel.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                          NetworkImage(socialUserModel.image.toString()),
                    ),
                    const SizedBox(width: 15.0),
                    Text(socialUserModel.name.toString())
                  ],
                ),
              ),
              body: ConditionalBuilder(
                  // condition: true,
                  condition: SocialCubit.get(context).messages.isNotEmpty,
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var message = SocialCubit.get(context)
                                        .messages[index];
                                    if (SocialCubit.get(context)
                                            .userModel!
                                            .uId ==
                                        message.senderId) {
                                      return buildMyMessage(message);
                                    }
                                    return buildMessage(message);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 15.0),
                                  itemCount:
                                      SocialCubit.get(context).messages.length),
                            ),
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Write Your Massage Here ..."),
                                  )),
                                  Container(
                                    height: 50.0,
                                    color: defaultColor,
                                    child: MaterialButton(
                                      onPressed: () {
                                        SocialCubit.get(context).sendMessage(
                                            receiverId: socialUserModel.uId!,
                                            dateTime: DateTime.now().toString(),
                                            text: messageController.text);
                                      },
                                      child: const Icon(
                                        IconlyBroken.send,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator())),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(model.text!),
        ),
      );

  Widget buildMyMessage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(model.text!),
        ),
      );
}
