import 'package:fitness_app/functional_backend/models/workout.dart';

class User {
  int? userID;

  String userName;

  //String? user_profile_photo

  String? userBio;

  DateTime userDOB;

  int userWeight;
  // String userUnits;

  DateTime accountCreationDate;

  String userEmail;

  List<Workout> userWorkouts;

  List<Workout> friendsWorkouts;

  int friendCount;

  User(
      {this.userID,
      this.userName = '',
      this.userBio = '',
      required this.userDOB,
      this.userWeight = 0,
      // this.userUnits = 'kg',
      required this.accountCreationDate,
      this.userEmail = '',
      this.userWorkouts = const [],
      this.friendsWorkouts = const [],
      this.friendCount = 0});

  User copyWith(
      {int? userID,
      String? userName,
      String? userBio,
      DateTime? userDOB,
      int? userWeight,
      // String? userUnits,
      DateTime? accountCreationDate,
      String? userEmail,
      List<Workout>? userWorkouts,
      List<Workout>? friendsWorkouts,
      int? friendCount}) {
    return User(
        userID: userID ?? this.userID,
        userName: userName ?? this.userName,
        userBio: userBio ?? this.userBio,
        userDOB: userDOB ?? this.userDOB,
        userWeight: userWeight ?? this.userWeight,
        // userUnits: userUnits ?? this.userUnits,
        accountCreationDate: accountCreationDate ?? this.accountCreationDate,
        userEmail: userEmail ?? this.userEmail,
        userWorkouts: userWorkouts ?? this.userWorkouts,
        friendsWorkouts: friendsWorkouts ?? this.friendsWorkouts,
        friendCount: friendCount ?? this.friendCount);
  }
}
