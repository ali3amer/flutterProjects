import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_screen/shared/cubit/cubit.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../modules/news_app/web_view/web_view_screen.dart';
import '../styles/colors.dart';

Widget defaultButton(
        {double width = double.infinity,
        Color background = Colors.blue,
        required Function function,
        required String text}) =>
    Container(
      width: width,
      color: background,
      height: 40.0,
      child: MaterialButton(
        onPressed: () => function(),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultTextButton({required Function function, required String text}) =>
    TextButton(onPressed: () => function(), child: Text(text.toUpperCase()));

Widget defaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        Function? onSubmit,
        Function? onChange,
        Function? validate,
        Function? onTap,
        bool isPassword = false,
        bool isClickable = true,
        required String label,
        required IconData prefix,
        IconData? suffix,
        Function? suffixPressed}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      onFieldSubmitted: (s) => onSubmit!(s),
      onChanged: (s) => () {},
      validator: (s) => validate!(s),
      onTap: () => onTap!(),
      obscureText: isPassword,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  icon: Icon(suffix),
                  onPressed: () => suffixPressed!(),
                )
              : null,
          border: const OutlineInputBorder()),
    );

PreferredSizeWidget defaultAppBar(
    {required BuildContext context, String? title, List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(IconlyBroken.arrowLeft2)),
    titleSpacing: 5.0,
    title: Text(title!),
    actions: actions,
  );
}

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key("${model["id"]}"),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Text(
                    model['date'],
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: "Done", id: model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: "Archive", id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model["id"]);
      },
    );

Widget tasksBuilder({required List<Map> tasks}) {
  return tasks.length > 0
      ? ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: tasks.length)
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                size: 70,
                color: Colors.grey,
              ),
              Text(
                "No Tasks Yet, Please Add Some Tasks",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        );
}

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        navigateTo(context, WebViewScreen(url: article["url"]));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: NetworkImage(
                      "${article['urlToImage']}",
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        "${article['title']}",
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Text(
                      article['publishedAt'],
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) {
  return list.isNotEmpty
      ? ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildArticleItem(list[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: list.length)
      : Center(
          child: isSearch ? Container() : const CircularProgressIndicator(),
        );
}

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) {
      return false;
    });

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNIG }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARNIG:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProducts(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image.toString()),
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      "DISCOUNT",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.0, height: 1.3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "\$${model.price.round()}",
                        style: const TextStyle(
                            fontSize: 12.0, color: defaultColor),
                      ),
                      const SizedBox(width: 5.0),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          "\$${model.oldPrice.round()}",
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favorites![model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          radius: 15.0,
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                        iconSize: 14.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
