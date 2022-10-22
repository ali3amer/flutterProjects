import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/models/shop_app/search_model.dart';
import 'package:login_screen/modules/shop_app/search/cubit/state.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/network/remote/dio_helper.dart';
import 'package:login_screen/shared/network/remote/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String? text) {
    emit(SearchLoadingState());

    DioHelper.postData(url: SEARCH, token: token, data: {
      "text": text,
    }).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
