import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/modules/shop_app/search/cubit/cubit.dart';
import 'package:login_screen/modules/shop_app/search/cubit/state.dart';
import 'package:login_screen/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      defaultFormField(
                          controller: searchController,
                          type: TextInputType.text,
                          label: "Search",
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Search Must Not Be Empty";
                            }
                          },
                          onSubmit: (String? text) {
                            SearchCubit.get(context).search(text);
                          },
                          prefix: Icons.search),
                      const SizedBox(height: 10.0),
                      if (state is SearchLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 10.0),
                      if (state is SearchSuccessState)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  buildListProducts(
                                      SearchCubit.get(context)
                                          .model!
                                          .data!
                                          .data![index],
                                      context,
                                      isOldPrice: false),
                              separatorBuilder: (context, index) => myDivider(),
                              itemCount: SearchCubit.get(context)
                                  .model!
                                  .data!
                                  .data!
                                  .length),
                        ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
