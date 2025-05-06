import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/frontend/modals/show_profile_modal.dart';
import 'package:fitness_app/backend/models/user.dart';

class FriendsPage extends ConsumerStatefulWidget {
  final int userID;

  const FriendsPage({super.key, required this.userID});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends ConsumerState<FriendsPage> {
  late Future<List<Map<String, dynamic>>> friends;
  late Future<List<Map<String, dynamic>>> friendRequests;
  @override
  void initState() {
    super.initState();
    friends = getFriends(widget.userID);
    friendRequests = getFriendRequests(widget.userID);
  }

  void _loadData() {
    setState(() {
      friends = getFriends(widget.userID);
      friendRequests = getFriendRequests(widget.userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 5, left: 3, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        'Friends',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const Row(children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Friend Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ]),
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: friendRequests,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No friends found.'));
                      } else {
                        List<Map<String, dynamic>> friendRequests =
                            snapshot.data!;
                        return Column(
                          spacing: 10,
                          children: [
                            for (Map<String, dynamic> friendRequest
                                in friendRequests)
                              FriendRequestWidget(
                                friendRequest: friendRequest,
                                onResponse: () {
                                  _loadData();
                                },
                              )
                          ],
                        );
                      }
                    }),
                const Divider(),
                const Row(children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Friends',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ]),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: friends,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No friends found.'));
                    } else {
                      List<Map<String, dynamic>> friends = snapshot.data!;
                      return Column(
                        spacing: 10,
                        children: [
                          for (Map<String, dynamic> friend in friends)
                            FriendWidget(friend: friend, onResponse: _loadData),
                          const SizedBox(height: 50)
                        ],
                      );
                    }
                  },
                ),
              ]),
        ));
  }
}

class FriendWidget extends ConsumerWidget {
  final Map<String, dynamic> friend;
  final VoidCallback onResponse;

  const FriendWidget(
      {super.key, required this.friend, required this.onResponse});

  void openProfileModal(BuildContext context, int userID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => ViewingProfilePage(userID: userID),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userNotifier);
    int userID = user.userID ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 15, left: 12, bottom: 5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            InkWell(
                onTap: () {
                  openProfileModal(context, friend['user_ID']);
                },
                child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/${friend['user_profile_photo']}.png'),
                        fit: BoxFit.fill,
                      ),
                    ))),
            Expanded(
              child: InkWell(
                onTap: () {
                  try {
                    openProfileModal(context, friend['user_ID']);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  friend['user_name'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Explicitly set color
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  deleteFriend(userID, friend['user_ID']);
                  ref.read(userNotifier.notifier).updateFriendCount();

                  onResponse();
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red),
                label: const Icon(Icons.close_rounded)),
          ]),
    );
  }
}

class FriendRequestWidget extends ConsumerWidget {
  final Map<String, dynamic> friendRequest;
  final VoidCallback onResponse;

  const FriendRequestWidget(
      {super.key, required this.friendRequest, required this.onResponse});

  void openProfileModal(BuildContext context, int userID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => ViewingProfilePage(userID: userID),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userNotifier);
    int userID = user.userID ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 15, left: 12, bottom: 5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/${friendRequest['user_profile_photo']}.png'),
                    fit: BoxFit.fill,
                  ),
                )),
            Expanded(
                child: Text(friendRequest['user_name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Explicitly set color
                    ))),
            Row(
              spacing: 5,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      declineFriendRequest(userID, friendRequest['user_ID']);
                      onResponse();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    label: const Icon(Icons.close_rounded)),
                ElevatedButton.icon(
                    onPressed: () {
                      acceptFriendRequest(userID, friendRequest['user_ID']);
                      ref.read(userNotifier.notifier).updateFriendCount();

                      onResponse();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    label: const Icon(Icons.check)),
              ],
            ),
          ]),
    );
  }
}
