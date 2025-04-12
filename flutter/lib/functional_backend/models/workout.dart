import 'package:fitness_app/functional_backend/models/user.dart';
import 'package:fitness_app/functional_backend/services/db_service.dart';

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
  DateTime workoutDateTime;
  int? comments;
  int? likes;
  List<int?>? activities;

  bool? workoutPublic;

  Workout(
      {required this.workoutID,
      required this.workoutUserName,
      required this.workoutTitle,
      required this.workoutDateTime,
      this.comments,
      this.likes,
      this.activities,
      this.workoutPublic});

  Workout copyWith(
      {int? workoutID,
      String? workoutUserName,
      String? workoutTitle,
      DateTime? workoutDateTime,
      int? comments,
      int? likes,
      List<int?>? activities,
      bool? workoutPublic}) {
    return Workout(
        workoutID: workoutID ?? this.workoutID,
        workoutUserName: workoutUserName ?? this.workoutUserName,
        workoutTitle: workoutTitle ?? this.workoutTitle,
        workoutDateTime: workoutDateTime ?? this.workoutDateTime,
        comments: comments ?? this.comments,
        likes: likes ?? this.likes,
        activities: activities ?? this.activities,
        workoutPublic: workoutPublic ?? this.workoutPublic);
  }

  Future<int> countComments() async {
    List<List<dynamic>> commentCount = await dbService.readQuery('''
      ''', {'workout_ID': this.workoutID});

    return 1;
  }
}
