import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/news_app/cubit/cubit.dart';
import 'package:login_screen/layout/news_app/cubit/states.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).business;
        print("list is $list");
        return ScreenTypeLayout(
          mobile: articleBuilder(list, context),
          desktop: Text(
            "Desktop",
            style: TextStyle(fontSize: 50.0),
          ),
          breakpoints:
              ScreenBreakpoints(desktop: 600.0, tablet: 600.0, watch: 600.0),
        );
      },
    );
  }
}
