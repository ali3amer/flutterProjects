import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/news_app/cubit/cubit.dart';
import 'package:login_screen/layout/news_app/cubit/states.dart';

import '../../../shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    label: "Search",
                    prefix: Icons.search,
                    onChange: (value) {
                      NewsCubit.get(context).getSearch(value);
                    },
                    validate: (String value) {
                      if (value.isEmpty) {
                        print("Search Must Not Empty");
                      }
                    }),
              ),
              Expanded(child: articleBuilder(list, context, isSearch: true))
            ],
          ),
        );
      },
    );
  }
}
