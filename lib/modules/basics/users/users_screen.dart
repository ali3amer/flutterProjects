import 'package:flutter/material.dart';

import '../../../models/user/user_model.dart';

class UsersScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(id: 1, name: "Ahmed Ali", phone: "+249929935000"),
    UserModel(id: 2, name: "Ali Mohammed", phone: "+249929935111"),
    UserModel(id: 3, name: "khaild Mohammed", phone: "+249929935555"),
    UserModel(id: 4, name: "Ahmed Mohammed", phone: "+249929935698"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => buildUserItem(users[index]),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: users.length),
    );
  }

  Widget buildUserItem(UserModel user) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              child: Text(
                "${user.id}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  user.phone,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      );
}
