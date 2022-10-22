import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:login_screen/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 190.0,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 140.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)),
                          image: DecorationImage(
                            image: NetworkImage('${userModel?.cover}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 64.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage('${userModel?.image}'),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                "${userModel?.name}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "${userModel?.bio}",
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "post",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "113",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Photos",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "14k",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Followers",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            "140",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            "Following",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Add Photos"),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  OutlinedButton(
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    child: const Icon(
                      IconlyBroken.edit,
                      size: 16.0,
                    ),
                  )
                ],
              ),
              Row(children: [
                OutlinedButton(
                  onPressed: () {
                    FirebaseMessaging.instance
                        .subscribeToTopic("announcements");
                  },
                  child: const Text("Subscribe"),
                ),
                const SizedBox(width: 25.0),
                OutlinedButton(
                  onPressed: () {
                    FirebaseMessaging.instance
                        .unsubscribeFromTopic("announcements");
                  },
                  child: const Text("unSubscribe"),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
