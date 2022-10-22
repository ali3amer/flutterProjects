import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/shared/components/components.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  NewTasksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
