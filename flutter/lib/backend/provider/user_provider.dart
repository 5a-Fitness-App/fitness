import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/services/db_service.dart';

final userProvider = StateProvider<int>((ref) => 1);

final userNotifier = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

class User {
  String userId;
  String userName;

  String userEmail;

  // String userProfilePhoto;
  // String userDOB;
  // String user_weight;
  // Stirng accountCreationDate;

  User({
    this.userId = '',
    this.userName = '',
    this.userEmail = '',
  });

  User copyWith(String? userName, String? userEmail) {
    return User(
      userId: userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  Future<String?> login(String email, String password) async {
    try {
      List<List<dynamic>> results = await dbService.readQuery(
        'SELECT user_password FROM users WHERE user_email = @email',
        {'email': email},
      );

      if (results.isEmpty) {
        // If no user found, return error message
        return 'Email or password is incorrect';
      } else {
        // List<Map<String, dynamic>> user = results
        //     .map((row) => {
        //           'user_id': row[0],
        //           'user_name': row[1],
        //           'user_password': row[5]
        //         })
        //     .toList();

        String userPassword = results[0][0];

        if (password == userPassword) {
          // If passwords match, return null (successful login)
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
