import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/shared/cubit/states.dart';
import 'package:login_screen/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/todo_app/archived_tasks/archived_task_screen.dart';
import '../../modules/todo_app/done_tasks/done_task_screen.dart';
import '../../modules/todo_app/new_tasks/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];

  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void changeIndex(int index) {
    currentIndex = index;

    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      print("database created");
      database
          .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("error is ${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) {
      return txn
          .rawInsert(
              "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'new')")
          .then((value) {
        print("$value inserted");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((onError) {
        print("error $onError");
      });
    });
    return null;
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseSLoadingState());
    database.rawQuery("SELECT * from tasks").then((value) {
      value.forEach((element) {
        if (element["status"] == "new") {
          newTasks.add(element);
        } else if (element["status"] == "Done") {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
    ;
  }

  void updateData({required String status, required int id}) async {
    database?.rawUpdate(
        "Update tasks SET status = ? WHERE id = ?", [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) async {
    database?.rawUpdate("DELETE FROM tasks WHERE id = ?", [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putDBoolean(key: "isDark", value: isDark)
          .then((value) => emit(AppChangeModeState()));
    }
  }
}
