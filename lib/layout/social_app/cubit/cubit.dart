import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_screen/layout/social_app/cubit/states.dart';
import 'package:login_screen/models/social_app/massage_model.dart';
import 'package:login_screen/models/social_app/post_model.dart';
import 'package:login_screen/models/social_app/social_user_model.dart';
import 'package:login_screen/models/user/user_model.dart';
import 'package:login_screen/modules/social_app/chats/chats_screen.dart';
import 'package:login_screen/modules/social_app/feeds/feeds_screen.dart';
import 'package:login_screen/modules/social_app/new_post/new_post_screen.dart';
import 'package:login_screen/modules/social_app/settings/settings_screen.dart';
import 'package:login_screen/modules/social_app/users/users_screen.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingSuccessState());

    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ["Home", "Chats", "New Post", "Users", "Settings"];

  void changeBottomNav(int index) {
    if (index == 1) {
      users = [];
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;

      emit(SocialChangeBottomNavState());
    }
  }

  ImagePicker picker = ImagePicker();
  File? profileImage;

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print("No File Selected");
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print("No File Selected");
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required name,
    required phone,
    required bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required name,
    required phone,
    required bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImages({required name, required phone, required bio}) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (coverImageUrl != "") {
  //     uploadCoverImage();
  //   } else if (profileImageUrl != "") {
  //     uploadProfileImage();
  //   } else if (coverImageUrl != "" && profileImageUrl != "") {
  //   } else {
  //     updateUser(name: name, phone: phone, bio: bio);
  //   }
  // }

  void updateUser({
    required phone,
    required bio,
    String? cover,
    String? image,
    String? name,
  }) {
    SocialUserModel? model = SocialUserModel(
      name: userModel!.name,
      phone: phone,
      isEmailVerified: false,
      bio: bio,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      email: userModel!.email,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print("No File Selected");
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required dateTime,
    required text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postImage: value, dateTime: dateTime, text: text);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void createPost({
    String? postImage,
    required dateTime,
    required text,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel? model = PostModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.image,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? "",
    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });

      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()["uId"] != userModel!.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        });

        emit(SocialGetPostsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetPostsErrorState(error.toString()));
      });
    }
  }

  void sendMessage(
      {required String receiverId,
      required String dateTime,
      required String text}) {
    MassageModel model = MassageModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime,
        text: text);

    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error) {
      emit(SocialSendMessagesErrorState());
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(userModel!.uId)
        .collection("messages")
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error) {
      emit(SocialSendMessagesErrorState());
    });
  }

  List<MassageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MassageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }
}
