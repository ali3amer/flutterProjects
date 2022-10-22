import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/shared/components/components.dart';

import '../../../shared/styles/colors.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        DateTime now = DateTime.now();
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: "Create Post",
            actions: [
              defaultTextButton(
                function: () {
                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context).createPost(
                      dateTime: now.toString(),
                      text: textController.text,
                    );
                  } else {
                    SocialCubit.get(context).uploadPostImage(
                        dateTime: now.toString(), text: textController.text);
                  }
                },
                text: "Post",
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  const SizedBox(height: 10.0),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          "https://img.freepik.com/free-photo/young-musician-with-headphones-neon-light_155003-31947.jpg?w=1380&t=st=1662584371~exp=1662584971~hmac=c929788352b3e228a95469e18b7b3ebae8a9a865f62f74e69da8604df2534cd8"),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child:
                          Text("Ali Amir Ali", style: TextStyle(height: 1.3)),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: "What is On Your Mind ....",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image:
                                FileImage(SocialCubit.get(context).postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                              onPressed: () {
                                SocialCubit.get(context).removePostImage();
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 16.0,
                              )),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(IconlyBroken.image),
                            SizedBox(width: 5.0),
                            Text("Add Photo")
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("# tags"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
