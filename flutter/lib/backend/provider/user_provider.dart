import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/services/db_service.dart';

final userProvider = StateProvider<int>((ref) => 1);

final userNotifier = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

class User {
  int? userID;
  String userName;

  String userEmail;

  // String userProfilePhoto;
  // String userDOB;
  // String user_weight;
  // Stirng accountCreationDate;

  User({
    this.userID,
    this.userName = '',
    this.userEmail = '',
  });

  User copyWith({int? userID, String? userName, String? userEmail}) {
    return User(
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

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
            'SELECT user_ID, user_name, user_email, user_password FROM users WHERE user_email = @email',
            {'email': email},
          );

          List<Map<String, dynamic>> user = results
              .map((row) => {
                    'user_id': row[0],
                    'user_name': row[1],
                    'user_email': row[2]
                  })
              .toList();

          state = state.copyWith(
              userID: user[0]['user_id'],
              userName: user[0]['user_name'],
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
}
