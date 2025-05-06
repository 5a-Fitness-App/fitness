import 'package:fitness_app/backend/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/services/db_service.dart';
import 'package:fitness_app/backend/models/user.dart';
import 'dart:convert';
import 'package:fitness_app/backend/provider/post_provider.dart';

final userProvider = StateProvider<int>((ref) => 1);

final userNotifier = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<User> {
  final Ref ref;

  UserNotifier(this.ref)
      : super(
            User(accountCreationDate: DateTime.now(), userDOB: DateTime.now()));

  Future<String?> login(String email, String password) async {
    try {
      List<List<dynamic>> passwordResults = await dbService.readQuery(
        'SELECT user_password FROM users WHERE user_email = @email',
        {'email': email},
      );

      if (passwordResults.isEmpty) {
        // If no user found, return error message
        return 'Email or password is incorrect';
      } else {
        String userPassword = passwordResults[0][0];

        if (password == userPassword) {
          // If passwords match, return null (successful login)
          List<List<dynamic>> results = await dbService.readQuery(
            '''
              SELECT 
                u.user_ID,
                u.user_name,
                u.user_profile_photo,
                u.user_bio, 
                u.user_dob,
                u.user_weight,
                u.user_weight_unit,
                u.users_account_creation_date,
                u.user_email,
                COUNT(f.friend_ID) AS friend_count
              FROM users u
                 JOIN friends f ON u.user_ID = f.user_ID
              WHERE user_email = @email 
              GROUP BY u.user_ID
              LIMIT 1;
            ''',
            {'email': email},
          );

          List<Map<String, dynamic>> user = results
              .map((row) => {
                    'user_ID': row[0],
                    'user_name': row[1],
                    'user_profile_photo': row[2],
                    'user_bio': row[3],
                    'user_dob': row[4],
                    'user_weight': double.parse(row[5]),
                    'user_units': row[6],
                    'users_account_creation_date': row[7],
                    'user_email': row[8],
                    'friend_count': row[9]
                  })
              .toList();

          state = state.copyWith(
              userID: user[0]['user_ID'],
              userName: user[0]['user_name'],
              userProfilePhoto:
                  utf8.decode(user[0]['user_profile_photo'].bytes),
              userBio: user[0]['user_bio'],
              userDOB: user[0]['user_dob'],
              userWeight: user[0]['user_weight'],
              userUnits: utf8.decode(user[0]['user_units'].bytes),
              accountCreationDate: user[0]['users_account_creation_date'],
              userEmail: user[0]['user_email'],
              friendCount: user[0]['friend_count']);

          print('userid: ${state.userID}');

          return null;
        } else {
          // If passwords don't match, return an error message
          return 'Email or password is incorrect';
        }
      }
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during login: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<void> updateFriendCount() async {
    int friendCount = await getFriendCount(state.userID!);

    state = state.copyWith(friendCount: friendCount);
    ref.read(postNotifier.notifier).loadFriendsWorkouts();
    ref.read(postNotifier.notifier).loadUserWorkouts();
  }

  void logOut() {
    state = state.copyWith(
        userID: null,
        userName: null,
        userEmail: '',
        userBio: null,
        userUnits: 'kg',
        userDOB: DateTime.now(),
        userWeight: null,
        accountCreationDate: DateTime.now(),
        friendCount: null,
        userProfilePhoto: null);
  }

  void deleteUserAccount() async {
    await deleteAccount(state.userID ?? 0);
    state = state.copyWith(
        userID: null,
        userName: null,
        userEmail: '',
        userBio: null,
        userUnits: 'kg',
        userDOB: DateTime.now(),
        userWeight: null,
        accountCreationDate: DateTime.now(),
        friendCount: null,
        userProfilePhoto: null);
  }
}
