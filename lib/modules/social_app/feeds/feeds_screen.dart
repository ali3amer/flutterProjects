import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/shared/styles/colors.dart';

import '../../../models/social_app/post_model.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.isNotEmpty &&
                SocialCubit.get(context).userModel != null,
            builder: (BuildContext context) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5.0,
                        margin: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            const Image(
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://img.freepik.com/free-photo/young-caucasian-musician-headphones-singing-gradient-pink-purple-wall-neon-light-concept-music-hobby-festival-joyful-party-host-dj-stand-upper-colorful-portrait-artist_155003-38777.jpg?w=1380&t=st=1662582908~exp=1662583508~hmac=e5b48c0c8f1af3ad19c58f8b389e1c8b1729dee7bb3d25df5f8a3c704c8a5042",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Communicat With your Friends",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              SocialCubit.get(context).posts[index],
                              index,
                              context),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
                          itemCount: SocialCubit.get(context).posts.length),
                      const SizedBox(height: 100)
                    ],
                  ),
                ),
            fallback: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildPostItem(PostModel model, int index, context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(model.image!),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(model.name!,
                              style: const TextStyle(height: 1.3)),
                          const SizedBox(width: 5.0),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          )
                        ],
                      ),
                      Text(model.dateTime!,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 16.0,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              model.text!,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 10.0),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            //   child: Container(
            //     width: double.infinity,
            //     child: Wrap(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsetsDirectional.only(end: 5.0),
            //           child: Container(
            //             height: 25.0,
            //             child: MaterialButton(
            //               onPressed: () {},
            //               minWidth: 1,
            //               padding: EdgeInsets.zero,
            //               child: Text(
            //                 "#software",
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .caption
            //                     ?.copyWith(color: defaultColor),
            //               ),
            //             ),
            //           ),
            //         ),
            //         // Padding(
            //         //   padding: const EdgeInsetsDirectional.only(end: 5.0),
            //         //   child: Container(
            //         //     height: 25.0,
            //         //     child: MaterialButton(
            //         //       onPressed: () {},
            //         //       minWidth: 1,
            //         //       padding: EdgeInsets.zero,
            //         //       child: Text(
            //         //         "#flutter",
            //         //         style: Theme.of(context)
            //         //             .textTheme
            //         //             .caption
            //         //             ?.copyWith(color: defaultColor),
            //         //       ),
            //         //     ),
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
            if (model.postImage != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        model.postImage!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(
                              IconlyBroken.heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              SocialCubit.get(context).likes[index].toString(),
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconlyBroken.chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              "34",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                                SocialCubit.get(context).userModel!.image!)),
                        const SizedBox(width: 15.0),
                        Text("Write your Comment ...",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(height: 1.4)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context)
                        .likePost(SocialCubit.get(context).postsId[index]);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconlyBroken.heart,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        "Like",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
