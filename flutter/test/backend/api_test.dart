import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/services/db_service.dart';

void main() {
  late DbService dbService;
  const testHost = 'localhost';

  setUpAll(() async {
    dbService = DbService();
    await dbService.init(testHost);
  });

  // Close after all tests
  tearDownAll(() async {
    if (dbService.isInitialized) {
      await dbService.connection.close();
    }
  });

  test('Successful getFriendsWorkout function with valid userID', () async {
    try {
      final result = await getFriendsWorkouts(1);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      final firstWorkout = result.first;
      expect(firstWorkout['workout_ID'], isA<int>());
      expect(firstWorkout['user_name'], isA<String>());
      expect(firstWorkout['workout_date_time'], isA<DateTime>());

      // TODO: complete for other returned items

      print(
          '✅ getFriendWorkouts function (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendsWorkouts (with valid userID): $e');
    }
  });

  test('Unsuccesful getFriendsWorkout function with invalid userID', () async {
    try {
      final result = await getFriendsWorkouts(-1); // Non-existent ID
      expect(result, isEmpty);

      print('✅ getFriendWorkouts (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendsWorkouts (with invalid userID): $e');
    }
  });

  test('Successful getUserWorkouts function with valid userID', () async {
    try {
      final result = await getUserWorkouts(1);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      final firstWorkout = result.first;
      expect(firstWorkout['workout_ID'], isA<int>());
      expect(firstWorkout['user_name'], isA<String>());
      expect(firstWorkout['workout_date_time'], isA<DateTime>());

      // TODO: complete for other returned items

      print(
          '✅ getUserWorkouts function (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getUserWorkouts (with valid userID): $e');
    }
  });

  test('Unsuccessful getUserWorkouts function with invalid userID', () async {
    try {
      final result = await getUserWorkouts(-1); // Non-existent ID
      expect(result, isEmpty);

      print('✅ getUserWorkouts (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getUserWorkouts (with invalid userID): $e');
    }
  });

  // TODO: test('Succesful getWorkoutDetails() function with valid workoutID', () async {});
  // TODO: test('Unsuccessful getWorkoutDetails() function with invalid workoutID');

  // TODO test('Successful hasUserLikedWorkout() function when user has not liked a workout', () async {} );
  // TODO test('Successful hasUserLikedWorkout() function when user has liked a workout', () async {} );
  // TODO test('Unsuccessful hasUserLikedWorkout() function with invalid userID', () async {} );
  // TODO test('Unsuccessful hasUserLikedWorkout() function with invalid workoutID', () async {} );

  // TODO test('Successful unlikeWorkout() function with valid userID and workoutID', () async {});
  // TODO  test('Unsuccesful unlikeWorkout() function with invalid userID', () async {});
  // TODO test('Unsuccesful unlikeWorkout() function with invalid workoutID', () async {});

  // TODO test('Successful likeWorkout() function with valid userID and workoutID', () async {});
  // TODO  test('Unsuccesful likeWorkout() function with invalid userID', () async {});
  // TODO test('Unsuccesful likeWorkout() function with invalid workoutID', () async {});

  // TODO: test('Successful getWorkoutActivities() function with valid workoutID', () async {});
  // TODO: test('Unsuccessful getWorkoutActivities() function with invalid workoutID', () async {});

  // TODO: test('Successful getWorkoutComments() function with valid workoutID', () async {});
  // TODO: test('Unsuccessful getWorkoutComments() function with invalid workoutID', () async {});

  // TODO: test('Successful getFriendCount() function with valid userID', () async {});
  // TODO: test('Unsuccessful getFriendCount() function with invalid userID', () async {});

  // TODO: test('Successful register() function with valid inputs', () async {});
  // TODO: test('Successful register() function with invalid inputs', () async {});

  // TODO: test('Successful addWorkout() function with valid inputs', () async {});
  // TODO: test('Successful addWorkout() function with invalid inputs', () async {});

  // TODO: test('Successful deleteWorkout() function with valid workoutID', () async {});
  // TODO: test('Unsuccesful deleteWorkout() function with invalid workoutID', () async {});

  // TODO: test('Succesful addComment() function with valid input', () async {});
  // TODO: test('Unsuccesful addComment() function with invalid input', () async {});

  // TODO: test('Succesful deleteComment() function with valid input', () async {});
  // TODO: test('Unsuccesful deleteComment() function with invalid input', () async {});

  // TODO: test('Succesful getFriendRequests() function with valid input', () async {});
  // TODO: test('Unsuccesful getFriendRequests() function with invalid input', () async {});

  // TODO: test('Succesful getFriends() function with valid input', () async {});
  // TODO: test('Unsuccesful getFriends() function with invalid input', () async {});

  // TODO: test('Succesful acceptFriendRequest() function with valid input', () async {});
  // TODO: test('Unsuccesful acceptFriendRequest() function with invalid input', () async {});

  // TODO: test('Succesful declineFriendRequest() function with valid input', () async {});
  // TODO: test('Unsuccesful declineFriendRequest() function with invalid input', () async {});

  // TODO: test('Succesful deleteFriend() function with valid input', () async {});
  // TODO: test('Unsuccesful deleteFriend() function with invalid input', () async {});

  // TODO: test('Succesful toggleWorkoutPublic() function with valid input', () async {});
  // TODO: test('Unsuccesful toggleWorkoutPublic() function with valid input', () async {});

  // TODO: test('Succesful toggleWorkoutPublic() function with valid input', () async {});
  // TODO: test('Unsuccesful toggleWorkoutPublic() function with valid input', () async {});
}
