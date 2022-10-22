import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/news_app/cubit/cubit.dart';
import 'package:login_screen/layout/news_app/cubit/states.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';

import '../../modules/news_app/search/search_screen.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          // DioHelper.init();
          return Scaffold(
            appBar: AppBar(
              title: const Text("News App"),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, SearchScreen());
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeAppMode();
                    },
                    icon: const Icon(Icons.brightness_4_outlined)),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBar(index);
              },
              items: cubit.bottomItems,
            ),
          );
        });
  }
}
