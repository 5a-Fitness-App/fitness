import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/services/db_service.dart';
import 'package:fitness_app/functional_backend/models/post.dart';
import 'dart:convert';
import 'package:fitness_app/functional_backend/models/user.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';
import 'package:fitness_app/functional_backend/api.dart';

final postProvider = StateProvider<int>((ref) => 1);

final postNotifier = StateNotifierProvider<PostNotifier, Posts>((ref) {
  return PostNotifier(ref);
});

class PostNotifier extends StateNotifier<Posts> {
  final Ref ref;

  PostNotifier(this.ref) : super(Posts(userWorkouts: [], friendsWorkouts: []));

  Future<void> loadUserWorkouts() async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      List<Map<String, dynamic>> userWorkouts = await getUserWorkouts(userID);
      state = state.copyWith(userWorkouts: userWorkouts);
    }
  }

  Future<void> loadFriendsWorkouts() async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      List<Map<String, dynamic>> friendsWorkouts =
          await getFriendsWorkouts(userID);
      state = state.copyWith(friendsWorkouts: friendsWorkouts);
    }
  }
}
