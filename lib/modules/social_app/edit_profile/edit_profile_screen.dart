import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        TextEditingController nameController = TextEditingController();
        TextEditingController bioController = TextEditingController();
        TextEditingController phoneController = TextEditingController();

        nameController.text = userModel.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: "Edit Profile", actions: [
            defaultTextButton(
                function: () {
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text);
                },
                text: "UPDATE"),
            const SizedBox(width: 15.0)
          ]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (state is SocialUserUpdateLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialUserUpdateLoadingState)
                  const SizedBox(height: 8.0),
                Container(
                  height: 190.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 140.0,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0)),
                                image: DecorationImage(
                                  image: coverImage == null
                                      ? NetworkImage('${userModel.cover}')
                                      : FileImage(coverImage) as ImageProvider,
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
                                      SocialCubit.get(context).getCoverImage();
                                    },
                                    icon: const Icon(
                                      IconlyBroken.camera,
                                      size: 16.0,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider),
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: const Icon(
                                  IconlyBroken.camera,
                                  size: 16.0,
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                if (SocialCubit.get(context).profileImage != null ||
                    SocialCubit.get(context).coverImage != null)
                  Row(
                    children: [
                      if (SocialCubit.get(context).profileImage != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  SocialCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                text: "Upload Profile"),
                            if (state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0),
                            if (state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator()
                          ],
                        )),
                      const SizedBox(width: 5.0),
                      if (SocialCubit.get(context).coverImage != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  SocialCubit.get(context).uploadCoverImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                text: "Upload Cover"),
                            if (state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0),
                            if (state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator()
                          ],
                        ))
                    ],
                  ),
                if (SocialCubit.get(context).profileImage != null ||
                    SocialCubit.get(context).coverImage != null)
                  const SizedBox(height: 20.0),
                defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    label: "Name",
                    prefix: IconlyBroken.user2,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return "The Name Must Not Be Empty";
                      }
                    }),
                const SizedBox(height: 10.0),
                defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    label: "Bio",
                    prefix: IconlyBroken.infoCircle,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return "The Name Must Not Be Empty";
                      }
                    }),
                const SizedBox(height: 10.0),
                defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    label: "Phone",
                    prefix: IconlyBroken.call,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return "The Phone Must Not Be Empty";
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
