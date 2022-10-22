import 'package:flutter/material.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 20.0,
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  "https://kyruus-app-static.kyruus.com/providermatch/atlantic/photos/orig/pmc-avatar-male_316x392.png"),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              "Chats",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.camera_alt,
                  size: 16.0,
                  color: Colors.white,
                ),
              )),
          IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.edit,
                  size: 16.0,
                  color: Colors.white,
                ),
              )),
        ],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Search")
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                height: 100.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildStoryItem(),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 20.0,
                  ),
                  itemCount: 5,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              ListView.separated(
                  itemBuilder: (context, index) => buildChatItem(),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 20.0,
                      ),
                  itemCount: 15)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatItem() => Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: const [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    "https://kyruus-app-static.kyruus.com/providermatch/atlantic/photos/orig/pmc-avatar-male_316x392.png"),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 1.0, end: 2.0),
                child: CircleAvatar(radius: 7.0, backgroundColor: Colors.red),
              )
            ],
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ali Amir Ali",
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "this message send by ali amir and he said",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text("03:54 pm")
                  ],
                )
              ],
            ),
          ),
        ],
      );
  Widget buildStoryItem() => Container(
        width: 60.0,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: const [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      "https://kyruus-app-static.kyruus.com/providermatch/atlantic/photos/orig/pmc-avatar-male_316x392.png"),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 1.0, end: 2.0),
                  child: CircleAvatar(radius: 7.0, backgroundColor: Colors.red),
                )
              ],
            ),
            const SizedBox(height: 7.0),
            const Text("Ali Amir Ali",
                maxLines: 2, overflow: TextOverflow.ellipsis)
          ],
        ),
      );
}
