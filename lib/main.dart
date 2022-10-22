import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:login_screen/layout/social_app/cubit/cubit.dart';
import 'package:login_screen/layout/social_app/social_layout.dart';
import 'package:login_screen/modules/social_app/social_register/cubit/states.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_screen/layout/news_app/news_layout.dart';
import 'package:login_screen/layout/shop_app/cubit/cubit.dart';
import 'package:login_screen/layout/shop_app/shop_layout.dart';
import 'package:login_screen/modules/shop_app/login/shop_login_screen.dart';
import 'package:login_screen/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:login_screen/shared/bloc_observer.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/cubit/states.dart';
import 'package:login_screen/shared/network/local/cache_helper.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/styles/themes.dart';

import 'layout/news_app/cubit/cubit.dart';
import 'modules/social_app/social_login/social_login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());

  showToast(
    text: 'on background message',
    state: ToastStates.SUCCESS,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();

  await CacheHelper.init();
  CacheHelper.putDBoolean(key: "isDark", value: false);
  bool? isDark = CacheHelper.getData(key: "isDark");

  Widget? widget;
  bool? onBoarding = CacheHelper.getData(key: "onBoarding");
  print("token is $token");
  token = CacheHelper.getData(key: "token") ?? "";

  // if (onBoarding != null) {
  //   if (token != null && token != "") {
  //     widget = ShopLayout();
  //   } else {
  //     // widget = ShopLoginScreen();
  //     widget = SocialLoginScreen();
  //   }
  // } else {
  //   widget = OnBoardingScreen();
  // }

  uId = CacheHelper.getData(key: "uId") ?? "";

  if (uId == null || uId == "") {
    widget = SocialLoginScreen();
  } else {
    widget = SocialLayout();
  }

  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (Platform.isLinux) {
        await DesktopWindow.setMinWindowSize(const Size(650.0, 650.0));
      }
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      runApp(MyApp(isDark!, widget!));
    },
    blocObserver: MyBlocObserver(),
  );
  // var tokenFirebase = await FirebaseMessaging.instance.getToken();
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //
  // print("tokin is $tokenFirebase");
  //
  // FirebaseMessaging.onMessage.listen((event) {
  //   print('on message');
  //   print(event.data.toString());
  //
  //   showToast(
  //     text: 'on message',
  //     state: ToastStates.SUCCESS,
  //   );
  // });
  //
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print('on message opened app');
  //   print(event.data.toString());
  //   showToast(
  //     text: 'on message opened app',
  //     state: ToastStates.SUCCESS,
  //   );
  // });
  //
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

class MyApp extends StatelessWidget {
  bool isDark;
  Widget startWidget;
  MyApp(this.isDark, this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getPosts()
            ..getUsers(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkTheme,
            home: Directionality(
                textDirection: TextDirection.ltr, child: NewsLayout()),
          );
        },
      ),
    );
  }
}
