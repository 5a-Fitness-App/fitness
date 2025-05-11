// Posts class hold a list for the logged in user's friends' posts and a separate list for their own posts
// Managed by Post Provider in backend/post_provider.dart
class Posts {
  final List<Map<String, dynamic>> userWorkouts;
  final List<Map<String, dynamic>> friendsWorkouts;

  Posts({required this.userWorkouts, required this.friendsWorkouts});

  Posts copyWith(
      {List<Map<String, dynamic>>? userWorkouts,
      List<Map<String, dynamic>>? friendsWorkouts}) {
    return Posts(
        userWorkouts: userWorkouts ?? this.userWorkouts,
        friendsWorkouts: friendsWorkouts ?? this.friendsWorkouts);
  }
}
