import 'package:fitness_app/functional_backend/models/workout.dart';

class User {
  int? userID;
  String userName;

  String userEmail;

  // String userProfilePhoto;
  // String userDOB;
  // String user_weight;
  // Stirng accountCreationDate;

  List<Workout> userWorkouts;

  User(
      {this.userID,
      this.userName = '',
      this.userEmail = '',
      this.userWorkouts = const []});

  User copyWith(
      {int? userID,
      String? userName,
      String? userEmail,
      List<Workout>? userWorkouts}) {
    return User(
        userID: userID ?? this.userID,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        userWorkouts: userWorkouts ?? this.userWorkouts);
  }
}
