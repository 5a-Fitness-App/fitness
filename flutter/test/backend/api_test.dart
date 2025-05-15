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

  test(
      'Successful getFriendsWorkout function with valid userID and the user has at least one friend',
      () async {
    try {
      final result = await getFriendsWorkouts(1);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      final firstWorkout = result.first;
      expect(firstWorkout['workout_ID'], isA<int>());
      expect(firstWorkout['user_ID'], isA<int>());
      expect(firstWorkout['user_name'], isA<String>());
      expect(firstWorkout['user_profile_photo'], isA<String>());
      expect(firstWorkout['workout_caption'], isA<String>());
      expect(firstWorkout['workout_date_time'], isA<DateTime>());
      expect(firstWorkout['total_comments'], isA<int>());
      expect(firstWorkout['total_likes'], isA<int>());

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
      expect(firstWorkout['user_profile_photo'], isA<String>());
      expect(firstWorkout['workout_caption'], isA<String>());
      expect(firstWorkout['workout_date_time'], isA<DateTime>());
      expect(firstWorkout['workout_public'], isA<bool>());
      expect(firstWorkout['total_comments'], isA<int>());
      expect(firstWorkout['total_likes'], isA<int>());

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

  test('Succesful getWorkoutDetails() function with valid workoutID', () async {
    try {
      final result = await getWorkoutDetails(1);

      expect(result, isA<Map<String, dynamic>>());
      expect(result.length, greaterThan(0));

      expect(result['workout_ID'], 1);
      expect(result['user_ID'], isA<int>());
      expect(result['user_name'], isA<String>());
      expect(result['user_profile_photo'], isA<String>());
      expect(result['workout_caption'], isA<String>());
      expect(result['workout_date_time'], isA<DateTime>());
      expect(result['workout_public'], isA<bool>());
      expect(result['total_comments'], isA<int>());
      expect(result['total_likes'], isA<int>());

      print('✅ getWorkoutDetails (with valid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute getWorkoutDetails (with valid workoutID): $e');
    }
  });

  test('Unsuccessful getWorkoutDetails() function with invalid workoutID',
      () async {
    try {
      final result = await getWorkoutDetails(-1);

      expect(result['error'], isNotNull);

      print('✅ getUserWorkouts (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getWorkoutDetails (with invalid workoutID): $e');
    }
  });

  test(
      'Successful hasUserLikedWorkout() function when user has not liked a workout',
      () async {
    try {
      final isLiked = await hasUserLikedWorkout(1, 5);

      expect(isLiked, false);

      print(
          '✅ hasUserLikeWorkout when user has not liked a workout executed as expected');
    } catch (e) {
      fail(
          'Failed to execute hasUserLikedWorkout when user has not liked a workout: $e');
    }
  });

  test(
      'Successful hasUserLikedWorkout() function when user has liked a workout',
      () async {
    try {
      final isLiked = await hasUserLikedWorkout(1, 6);

      expect(isLiked, true);

      print(
          '✅ hasUserLikeWorkout when user has liked a workout executed as expected');
    } catch (e) {
      fail(
          'Failed to execute hasUserLikedWorkout when user has liked a workout: $e');
    }
  });

  test('Unsuccessful hasUserLikedWorkout() function with invalid userID',
      () async {
    try {
      final isLiked = await hasUserLikedWorkout(-1, 1);

      expect(isLiked, false);

      print('✅ hasUserLikeWorkout (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute hasUserLikedWorkout (with invalid userID): $e');
    }
  });

  test('Unsuccessful hasUserLikedWorkout() function with invalid workoutID',
      () async {
    try {
      final isLiked = await hasUserLikedWorkout(1, -1);

      expect(isLiked, false);

      print('✅ hasUserLikeWorkout (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute hasUserLikedWorkout (with invalid userID): $e');
    }
  });

  test('Successful unlikeWorkout() function with valid userID and workoutID',
      () async {
    try {
      final initialIsLiked = await hasUserLikedWorkout(1, 6);

      expect(initialIsLiked, true);

      await unlikeWorkout(1, 6);

      final isLiked = await hasUserLikedWorkout(1, 6);

      expect(isLiked, false);

      print(
          '✅ unlikeWorkout (with valid userID and workoutID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute unlikeWorkout (with valid userID and workoutID): $e');
    } finally {
      await likeWorkout(1, 6);
    }
  });

  test('Unsuccesful unlikeWorkout() function with invalid userID', () async {
    try {
      await unlikeWorkout(-1, 6);

      final isLiked = await hasUserLikedWorkout(-1, 6);

      expect(isLiked, false);

      print('✅ unlikeWorkout (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute unlikeWorkout (with invalid userID): $e');
    }
  });

  test('Unsuccesful unlikeWorkout() function with invalid workoutID', () async {
    try {
      await unlikeWorkout(1, -6);

      final isLiked = await hasUserLikedWorkout(1, -6);

      expect(isLiked, false);

      print('✅ unlikeWorkout (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute unlikeWorkout (with invalid workoutID): $e');
    }
  });

  test('Successful likeWorkout() function with valid userID and workoutID',
      () async {
    try {
      await likeWorkout(1, 5);

      final isLiked = await hasUserLikedWorkout(1, 5);

      expect(isLiked, true);

      print(
          '✅ likeWorkout (with valid userID and workoutID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute likeWorkout (with valid userID and workoutID): $e');
    } finally {
      await unlikeWorkout(1, 5);
    }
  });

  test('Unsuccesful likeWorkout() function with invalid userID', () async {
    try {
      await likeWorkout(-1, 5);

      final isLiked = await hasUserLikedWorkout(-1, 5);

      expect(isLiked, false);

      print('✅ unlikeWorkout (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute likeWorkout (with invalid userID): $e');
    }
  });

  test('Unsuccesful likeWorkout() function with invalid workoutID', () async {
    try {
      await likeWorkout(1, -5);

      final isLiked = await hasUserLikedWorkout(1, -5);

      expect(isLiked, false);

      print('✅ unlikeWorkout (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute likeWorkout (with invalid workoutID): $e');
    }
  });

  test('Successful getWorkoutActivities() function with valid workoutID',
      () async {
    try {
      final result = await getWorkoutActivities(1);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      final firstActivity = result.first;

      expect(firstActivity['exercise_name'], isA<String>());
      expect(firstActivity['exercise_target'], isA<String>());
      expect(firstActivity['notes'], isA<String>());
      expect(firstActivity['metrics'], isA<Map<String, dynamic>>());

      print(
          '✅ getWorkoutActivities (with valid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute getWorkoutActivities (with valid workoutID): $e');
    }
  });

  test('Unsuccessful getWorkoutActivities() function with invalid workoutID',
      () async {
    try {
      final result = await getWorkoutActivities(-1);

      expect(result, isEmpty);

      print(
          '✅ getWorkoutActivities (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute likeWorkout (with invalid workoutID): $e');
    }
  });

  test(
      'Successful getWorkoutComments() function with valid workoutID and when at least one comment is available',
      () async {
    try {
      final result = await getWorkoutComments(6);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      final firstComment = result.first;

      expect(firstComment['user_ID'], isA<int>());
      expect(firstComment['user_name'], isA<String>());
      expect(firstComment['user_profile_photo'], isA<String>());
      expect(firstComment['comment_ID'], isA<int>());
      expect(firstComment['content'], isA<String>());
      expect(firstComment['date'], isA<DateTime>());

      print(
          '✅ getWorkoutComments (with valid workoutID and at least one comment is available) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute getWorkoutComments (with valid workoutID and at least one comment is available): $e');
    }
  });

  test(
      'Successful getWorkoutComments() function with valid workoutID and when no comments available',
      () async {
    int? workoutID;

    try {
      workoutID = await dbService.insertAndReturnId('''
        INSERT INTO workouts (user_ID, workout_caption, workout_date_time, workout_public) VALUES (1, 'Leg day grind!', '2024-01-01 10:00', TRUE) RETURNING workout_ID;
      ''', {});

      final results = await getWorkoutComments(workoutID);

      expect(results, isEmpty);

      print(
          '✅ getWorkoutComments (with valid workoutID and no comments available) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute getWorkoutComments (with valid workoutID and no comments available): $e');
    } finally {
      if (workoutID != null) {
        await deleteWorkout(workoutID);
      }
    }
  });

  test('Unsuccessful getWorkoutComments() function with invalid workoutID',
      () async {
    try {
      final results = await getWorkoutComments(-1);

      expect(results, isEmpty);

      print(
          '✅ getWorkoutComments (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute getWorkoutComments(with invalid workoutID: $e');
    }
  });

  test('Successful getFriendCount() function with valid userID', () async {
    try {
      final friendCount = await getFriendCount(1);

      expect(friendCount, isA<int>());

      print('✅ getFriendCount (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendCount (with valid userID): $e');
    }
  });

  test('Unsuccessful getFriendCount() function with invalid userID', () async {
    try {
      final friendCount = await getFriendCount(-1);

      expect(friendCount, 0);

      print('✅ getFriendCount (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendCount (with invalid userID): $e');
    }
  });

  test('Successful register() function with valid inputs', () async {
    try {
      final result = await register('testing', 'fish', DateTime.now(), 90, 'kg',
          'testing@example.com', 'pass');

      expect(result, null);

      print('✅ register (with valid inputs) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with valid inputs)');
    } finally {
      await dbService.deleteQuery('''
        DELETE FROM users 
        WHERE 
        user_name = 'testing' AND 
        user_email = 'testing@example.com';
      ''', {});
    }
  });

  test('Unsuccessful register() function with invalid email', () async {
    try {
      final result = await register(
          'testing',
          'fish',
          DateTime.now(),
          90,
          'kg',
          'aqua_fish@example.com', //already registered email,
          'pass');

      expect(result, 'There was an error registering your account');

      print('✅ register (with invalid email) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with invalid email): $e');
    }
  });

  test('Unsuccessful register() function with invalid username', () async {
    try {
      final result = await register(
          'aqua_fish', // already registered username
          'fish',
          DateTime.now(),
          90,
          'kg',
          'testing@example.com',
          'pass');

      expect(result, 'There was an error registering your account');

      final result2 = await register(
          'too_many_characters_for_username', // username is too long
          'fish',
          DateTime.now(),
          90,
          'kg',
          'testing@example.com',
          'pass');

      expect(result2, 'There was an error registering your account');

      print('✅ register (with invalid username) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with invalid username): $e');
    }
  });

  test('Unsuccessful register() function with invalid weight', () async {
    try {
      final result = await register(
          'testing',
          'fish',
          DateTime.now(),
          -1, // invalid weight
          'kg',
          'testing@example.com',
          'pass');

      expect(result, 'There was an error registering your account');

      print('✅ register (with invalid weight) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with invalid weight): $e');
    }
  });

  test('Unsuccessful register() function with invalid weight unit', () async {
    try {
      final result = await register(
          'testing',
          'fish',
          DateTime.now(),
          90,
          '', //invalid weight unit
          'testing@example.com',
          'pass');

      expect(result, 'There was an error registering your account');

      print('✅ register (with invalid weight unit) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with invalid weight unit): $e');
    }
  });

  test('Unsuccessful register() function with invalid profile photo', () async {
    try {
      final result = await register('testing', '', DateTime.now(), 90, 'kg',
          'testing@example.com', 'pass');

      expect(result, 'There was an error registering your account');

      print('✅ register (with invalid profile photo) executed as expected');
    } catch (e) {
      fail('Failed to execute register (with profile photo): $e');
    }
  });

  test('Successful addWorkout() function with valid inputs', () async {
    try {
      final results =
          await addWorkout(1, 'testingtestingtestingtesting', true, []);

      expect(results, null);

      print('✅ addWorkout (with valid inputs) executed as expected');
    } catch (e) {
      fail('Failed to execute addWorkout (with valid inputs): $e');
    } finally {
      await dbService.deleteQuery('''
        DELETE FROM workouts WHERE user_ID = 1 AND workout_caption = 'testingtestingtestingtesting' AND workout_public = true ''',
          {});
    }
  });

  test('Unsuccessful addWorkout() function with invalid userID', () async {
    try {
      final results =
          await addWorkout(-1, 'testingtestingtestingtesting', true, []);

      expect(results,
          'error: Severity.error 23503: insert or update on table "workouts" violates foreign key constraint "workouts_user_id_fkey" detail: Key (user_id)=(-1) is not present in table "users". table: workouts constraint workouts_user_id_fkey');

      print('✅ addWorkout (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute addWorkout (with invalid userID): $e');
    } finally {
      await dbService.deleteQuery('''
        DELETE FROM workouts WHERE user_ID = 1 AND workout_caption = 'testingtestingtestingtesting' AND workout_public = true ''',
          {});
    }
  });

  test('Successful deleteWorkout() function with valid workoutID', () async {
    int? workoutID;

    try {
      workoutID = await dbService.insertAndReturnId('''
        INSERT INTO workouts (user_ID, workout_caption, workout_date_time, workout_public)
        VALUES
        (1, 'testingtestingtestingtesting', CURRENT_DATE, true)
        RETURNING workout_ID;
      ''', {});

      final check = await dbService.readQuery(
          '''SELECT workout_id FROM workouts WHERE workout_ID = @workout_ID;
      ''', {'workout_ID': workoutID});

      expect(check, isNotEmpty);

      await deleteWorkout(workoutID);

      final checkDelete = await dbService.readQuery(
          '''SELECT workout_id FROM workouts WHERE workout_ID = @workout_ID;
      ''', {'workout_ID': workoutID});

      expect(checkDelete, isEmpty);

      print('✅ deleteWorkout (with valid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteWorkout (with valid workoutID): $e');
    }
  });

  test('Unsuccesful deleteWorkout() function with invalid workoutID', () async {
    try {
      await deleteWorkout(-1);

      final checkDelete = await dbService.readQuery(
          '''SELECT workout_id FROM workouts WHERE workout_ID = @workout_ID;
      ''', {'workout_ID': -1});

      expect(checkDelete, isEmpty);

      print('✅ deleteWorkout (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteWorkout (with invalid workoutID): $e');
    }
  });

  test('Succesful addComment() function with valid input', () async {
    try {
      final error = await addComment(6, 1, 'testingtestingtestingtesting');

      final check = await dbService.readQuery('''
        SELECT comment_ID FROM comments WHERE user_ID = 1 AND workout_ID = 6 AND content = 'testingtestingtestingtesting';
      ''', {});

      expect(check, isNotEmpty);
      expect(error, null);

      print('✅ addComment (with valid input) executed as expected');
    } catch (e) {
      fail('Failed to execute addComment (with valid input): $e');
    } finally {
      await dbService.deleteQuery(
          '''DELETE FROM comments WHERE user_ID = 1 AND workout_ID = 6 AND content = 'testingtestingtestingtesting';''',
          {});
    }
  });

  test('Unsuccesful addComment() function with invalid workoutID', () async {
    try {
      final error = await addComment(-6, 1, 'testingtestingtestingtesting');

      expect(error,
          'error: Severity.error 23503: insert or update on table "comments" violates foreign key constraint "comments_workout_id_fkey" detail: Key (workout_id)=(-6) is not present in table "workouts". table: comments constraint comments_workout_id_fkey');

      print('✅ addComment (with invalid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute addComment (with invalid workoutID): $e');
    }
  });

  test('Unsuccesful addComment() function with invalid userID', () async {
    try {
      final error = await addComment(6, -1, 'testingtestingtestingtesting');

      expect(error,
          'error: Severity.error 23503: insert or update on table "comments" violates foreign key constraint "comments_user_id_fkey" detail: Key (user_id)=(-1) is not present in table "users". table: comments constraint comments_user_id_fkey');

      print('✅ addComment (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute addComment (with invalid userID): $e');
    }
  });

  test('Succesful deleteComment() function with valid workoutID', () async {
    try {
      final commentID = await dbService.insertAndReturnId('''
        INSERT INTO comments (user_ID, workout_ID, content) VALUES (1, 6, 'test comment') RETURNING comment_id;
      ''', {});

      final insertCheck = await dbService.readQuery('''
        SELECT comment_ID FROM comments WHERE comment_ID = @comment_ID;
      ''', {'comment_ID': commentID});

      // Convert query results to List of Maps
      List<Map<String, dynamic>> formatInsertCheck =
          insertCheck.map((row) => {'comment_ID': row[0]}).toList();

      expect(formatInsertCheck[0]['comment_ID'], commentID);

      await deleteComment(commentID);

      final deleteCheck = await dbService.readQuery('''
        SELECT comment_id FROM comments WHERE comment_ID = @comment_ID;
      ''', {'comment_ID': commentID});

      // Convert query results to List of Maps
      List<Map<String, dynamic>> formatDeleteCheck =
          deleteCheck.map((row) => {'comment_ID': row[0]}).toList();

      expect(formatDeleteCheck, isEmpty);

      print('✅ deleteComment (with valid commentID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteComment (with valid workoutID: $e');
    }
  });

  test('Unsuccesful deleteComment() function with invalid workoutID', () async {
    try {
      await deleteComment(-1);

      final result = await dbService.readQuery(
          '''SELECT comment_ID FROM comments WHERE comment_ID = @comment_ID;''',
          {'comment_ID': -1});

      expect(result, isEmpty);

      print('✅ deleteComment (with invalid commentID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteComment (with invalid workoutID): $e');
    }
  });

  test('Succesful getFriendRequests() function with valid userID', () async {
    try {
      final results = await getFriendRequests(2);

      expect(results, isA<List<Map<String, dynamic>>>());

      final firstRequest = results.first;
      expect(firstRequest['user_ID'], isA<int>());
      expect(firstRequest['user_name'], isA<String>());
      expect(firstRequest['user_profile_photo'], isA<String>());

      print('✅ deleteComment (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendRequests (with valid userID): $e');
    }
  });

  test('Unsuccesful getFriendRequests() function with invalid input', () async {
    try {
      final results = await getFriendRequests(-1);

      expect(results, isEmpty);

      print('✅ deleteComment (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriendRequests (with invalid userID): $e');
    }
  });

  test('Succesful getFriends() function with valid userID', () async {
    try {
      final friends = await getFriends(1);

      expect(friends, isNotEmpty);

      final firstFriend = friends.first;
      expect(firstFriend['user_ID'], isA<int>());
      expect(firstFriend['user_name'], isA<String>());
      expect(firstFriend['user_profile_photo'], isA<String>());

      print('✅ getFriends (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriends (with valid userID): $e');
    }
  });

  test('Unsuccesful getFriends() function with invalid userID', () async {
    try {
      final friends = await getFriends(-1);

      expect(friends, isEmpty);

      print('✅ getFriends (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute getFriends (with invalid userID): $e');
    }
  });

  test('Succesful acceptFriendRequest() function with valid input', () async {
    try {
      final error = await acceptFriendRequest(2, 1);

      final check = await dbService.readQuery(
          '''SELECT * FROM friends WHERE (friend_ID = 2 AND user_ID = 1) OR (friend_ID = 1 AND user_ID = 2)''',
          {});

      expect(check, isNotEmpty);
      expect(error, null);

      print('✅ acceptFriendRequest (with valid input) executed as expected');
    } catch (e) {
      fail('Failed to execute acceptFriendRequest (with valid input): $e');
    } finally {
      await dbService.deleteQuery(
          '''DELETE FROM friends WHERE (friend_ID = 2 AND user_ID = 1) OR (friend_ID = 1 AND user_ID = 2)''',
          {});
      await dbService.insertQuery(
          '''INSERT INTO friend_requests (sender_ID, receiver_ID) VALUES (1, 2);''',
          {});
    }
  });

  test('Unsuccesful acceptFriendRequest() function with invalid receiverID',
      () async {
    try {
      final error = await acceptFriendRequest(-2, 1);

      expect(error,
          'error: Severity.error 23503: insert or update on table "friends" violates foreign key constraint "friends_user_id_fkey" detail: Key (user_id)=(-2) is not present in table "users". table: friends constraint friends_user_id_fkey');

      print(
          '✅ acceptFriendRequest (with invalid receiverID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute acceptFriendRequest (with invalid receiverID): $e');
    }
  });

  test('Unsuccesful acceptFriendRequest() function with invalid senderID',
      () async {
    try {
      final error = await acceptFriendRequest(2, -1);

      expect(error,
          'error: Severity.error 23503: insert or update on table "friends" violates foreign key constraint "friends_friend_id_fkey" detail: Key (friend_id)=(-1) is not present in table "users". table: friends constraint friends_friend_id_fkey');

      print(
          '✅ acceptFriendRequest (with invalid senderID) executed as expected');
    } catch (e) {
      fail('Failed to execute acceptFriendRequest (with invalid senderID): $e');
    }
  });

  test('Succesful declineFriendRequest() function with valid input', () async {
    try {
      final error = await declineFriendRequest(2, 1);

      final check = await dbService.readQuery(
          '''SELECT * FROM friend_requests WHERE sender_ID = 1 and receiver_ID = 2''',
          {});

      expect(check, isEmpty);
      expect(error, null);

      print('✅ declineFriendRequest (with valid input) executed as expected');
    } catch (e) {
      fail('Failed to execute declineFriendRequest (with valid input): $e');
    } finally {
      await dbService.insertQuery(
          '''INSERT INTO friend_requests (sender_ID, receiver_ID) VALUES (1, 2);''',
          {});
    }
  });

  test('Unsuccesful declineFriendRequest() function with invalid senderID',
      () async {
    try {
      final error = await declineFriendRequest(2, -1);

      expect(error, null);

      print(
          '✅ declineFriendRequest (with invalid senderID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute declineFriendRequest (with invalid senderID): $e');
    }
  });

  test('Unsuccesful declineFriendRequest() function with invalid receiverID',
      () async {
    try {
      final error = await declineFriendRequest(-2, 1);

      expect(error, null);

      print(
          '✅ declineFriendRequest (with invalid receiverID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute declineFriendRequest (with invalid receiverID): $e');
    }
  });

  test('Succesful deleteFriend() function with valid input', () async {
    try {
      await dbService.insertQuery(
          '''INSERT INTO friends (user_ID, friend_ID) VALUES (3, 5), (5, 3);''',
          {});

      final insertCheck = await dbService.readQuery(
          '''SELECT * FROM friends WHERE (friend_ID = 3 AND user_ID = 5) OR (friend_ID = 5 AND user_ID = 3)''',
          {});

      expect(insertCheck, isNotEmpty);

      final error = await deleteFriend(3, 5);

      final deleteCheck = await dbService.readQuery(
          '''SELECT * FROM friends WHERE (friend_ID = 3 AND user_ID = 5) OR (friend_ID = 5 AND user_ID = 3)''',
          {});

      expect(deleteCheck, isEmpty);
      expect(error, null);

      print('✅ deleteFriend (with valid input) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteFriend (with valid input): $e');
    }
  });
  test('Unsuccesful deleteFriend() function with invalid userID', () async {
    try {
      final error = await deleteFriend(-3, 5);

      expect(error, null);

      print('✅ deleteFriend (with invalid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteFriend (with invalid userID): $e');
    }
  });

  test('Unsuccesful deleteFriend() function with invalid friendID', () async {
    try {
      final error = await deleteFriend(3, -5);

      expect(error, null);

      print('✅ deleteFriend (with invalid friendID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteFriend (with invalid friendID): $e');
    }
  });

  test('Succesful toggleWorkoutPublic() function with valid workoutID',
      () async {
    try {
      List<List<dynamic>> check = await dbService.readQuery(
          '''SELECT workout_public FROM workouts WHERE workout_ID = 1;''', {});
      bool initialStatus = check
          .map((row) => {'workout_public': row[0]})
          .toList()[0]['workout_public'];

      final error = await toggleWorkoutPublic(1);

      List<List<dynamic>> toggleCheck = await dbService.readQuery(
          '''SELECT workout_public FROM workouts WHERE workout_ID = 1;''', {});
      bool toggledStatus = toggleCheck
          .map((row) => {'workout_public': row[0]})
          .toList()[0]['workout_public'];

      expect(toggledStatus, !initialStatus);
      expect(error, null);

      print(
          '✅ toggleWorkoutPublic (with valid workoutID) executed as expected');
    } catch (e) {
      fail('Failed to execute toggleWorkoutPublic (with valid workoutID): $e');
    }
  });

  test('Unsuccesful toggleWorkoutPublic() function with invalid workoutID',
      () async {
    try {
      final error = await toggleWorkoutPublic(-1);

      expect(error,
          'error; RangeError (length): Invalid value: Valid value range is empty: 0');

      print(
          '✅ toggleWorkoutPublic (with invalid workoutID) executed as expected');
    } catch (e) {
      fail(
          'Failed to execute toggleWorkoutPublic (with invalid workoutID): $e');
    }
  });

  test('Successful deleteAccount with valid userID', () async {
    try {
      final userID = await dbService.insertAndReturnId('''
        INSERT INTO users (user_name, user_profile_photo, user_bio, user_dob, user_weight, user_weight_unit, users_account_creation_date, user_email, user_password) VALUES 
        ('testing', 'fish', 'Love swimming and weights!', '1995-06-15', 70.2, 'kg', '2023-01-15', 'testing@example.com', 'hashedpassword1') RETURNING user_ID;
      ''', {});

      final check = await dbService.readQuery(
          '''SELECT * FROM users WHERE user_ID = @user_ID;''',
          {'user_ID': userID});

      expect(check, isNotEmpty);

      final error = await deleteAccount(userID);

      final deleteCheck = await dbService.readQuery(
          '''SELECT * FROM users WHERE user_ID = @user_ID;''',
          {'user_ID': userID});

      expect(deleteCheck, isEmpty);
      expect(error, null);

      print('✅ deleteAccount (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteAccount (with valid userID): $e');
    }
  });

  test('Unsuccessful deleteAccount with invalid userID', () async {
    try {
      final error = await deleteAccount(-1);

      expect(error, null);

      print('✅ deleteAccount (with valid userID) executed as expected');
    } catch (e) {
      fail('Failed to execute deleteAccount (with valid userID): $e');
    }
  });
}
