import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/services/db_service.dart';
import 'package:fitness_app/functional_backend/models/user.dart';
import 'dart:convert';

final userProvider = StateProvider<int>((ref) => 1);

final userNotifier = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
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
            '''SELECT 
              user_ID,
              user_name,
              user_profile_photo,
              user_bio,
              user_dob,
              user_weight,
              user_weight_unit,
              users_account_creation_date,
              user_email
              FROM users 
              WHERE user_email = @email''',
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
                    'user_email': row[8]
                  })
              .toList();

          print(utf8.decode(user[0]['user_profile_photo'].bytes));

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
              userEmail: user[0]['user_email']);

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

  void logOut() {
    state = state.copyWith(userID: null, userName: null, userEmail: '');
  }
}
