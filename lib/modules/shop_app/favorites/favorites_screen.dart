import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/layout/shop_app/cubit/cubit.dart';
import 'package:login_screen/models/shop_app/favorites_model.dart';

import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (state.model.status == false) {
            showToast(text: state.model.massage!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<ShopCubit, ShopStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return ConditionalBuilder(
                condition: state is! ShopLoadingGetFavoritesState,
                builder: (context) => ListView.separated(
                    itemBuilder: (context, index) => buildListProducts(
                        ShopCubit.get(context)
                            .favoritesModel!
                            .data!
                            .data![index]
                            .product,
                        context),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: ShopCubit.get(context)
                        .favoritesModel!
                        .data!
                        .data!
                        .length),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            });
      },
    );
  }
}
