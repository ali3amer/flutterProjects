// import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/components/constants.dart';

class TodoLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  TodoLayout({Key? key}) : super(key: key);

  @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: state is! AppGetDatabaseSLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            // body: ConditionalBuilder(
            //   condition: tasks.length > 0,
            //   builder: (context) => screens[currentIndex],
            //   fallback: (context) => CircularProgressIndicator(),
            // ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        time: timeController.text,
                        title: titleController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                          controller: titleController,
                                          type: TextInputType.text,
                                          label: "New Task",
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return "Title Must Not Be Empty";
                                            }
                                          },
                                          prefix: Icons.title),
                                      const SizedBox(height: 20.0),
                                      defaultFormField(
                                          controller: timeController,
                                          type: TextInputType.datetime,
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString();
                                            });
                                          },
                                          label: "Time Task",
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return "Time Must Not Be Empty";
                                            }
                                          },
                                          prefix: Icons.watch_later_outlined),
                                      const SizedBox(height: 20.0),
                                      defaultFormField(
                                          controller: dateController,
                                          type: TextInputType.datetime,
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        "2022-08-05"))
                                                .then((value) {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value!);
                                            });
                                          },
                                          label: "Date Task",
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return "Date Must Not Be Empty";
                                            }
                                          },
                                          prefix: Icons.calendar_today)
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 15.0)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                // setState(() {
                //   currentIndex = index;
                // });
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async {
    return "hhhhhhh";
  }
}
