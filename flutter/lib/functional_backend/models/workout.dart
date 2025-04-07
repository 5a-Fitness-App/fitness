import 'package:fitness_app/functional_backend/models/user.dart';

class Comment {
  int commentID;
  User commenter;
  String content;
  String date;

  Comment(
      {required this.commentID,
      required this.commenter,
      required this.content,
      required this.date});
}

class Activity {
  int activityID;

  String exerciseType;
  String? notes;

  //Strength fields
  int? reps;
  double? weight;
  String? weightMetric;

  //Cardio fields
  double? distance;
  String? time;
  double? incline;
  double? speed;

  Activity({required this.activityID, required this.exerciseType});
}

class Workout {
  int? workoutID;
  String? workoutTitle;
  String? workoutUserName;
  // String? workoutDateTime;
  List<Comment>? comments;
  List<Activity>? activities;

  Workout(
      {required this.workoutID,
      required this.workoutUserName,
      required this.workoutTitle,
      this.comments,
      this.activities});

  Workout copyWith(
      {int? workoutID,
      String? workoutUserName,
      String? workoutTitle,
      List<Comment>? comments,
      List<Activity>? activities}) {
    return Workout(
        workoutID: workoutID ?? this.workoutID,
        workoutUserName: workoutUserName ?? this.workoutUserName,
        workoutTitle: workoutTitle ?? this.workoutTitle,
        comments: comments ?? this.comments,
        activities: activities ?? this.activities);
  }
}
