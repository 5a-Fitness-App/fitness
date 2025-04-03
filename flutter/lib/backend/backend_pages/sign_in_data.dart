import '../connect_database.dart';

// 1. Authenticate User (Login)
String loginQuery = 
'''SELECT user_ID, user_name, user_email, user_password 
FROM users 
WHERE user_email = 'user@example.com';
''';

// 2. Check if Email Exists (Before Login or Registration)
String emailCheckQuery =
'''SELECT user_ID FROM users WHERE user_email = 'user@example.com';''';

// 3. Register a New User (Sign Up)
String signUpQuery =
'''INSERT INTO users (user_name, user_dob, user_weight, user_email, user_password)
VALUES ('JohnDoe', '1995-06-15', 75, 'john@example.com', 'hashed_password_here');''';

Map<String, dynamic> signUpDict = {
    'user_name': 'JohnDoe',
    'user_dob': '1995-06-15',
    'user_weight': 75,
    'user_email': 'john@example.com',
    'user_password': 'hashed_password_here',
};

// 4. Get User Profile After Login
String profileQuery =
'''SELECT user_ID, user_name, user_dob, user_weight, user_email 
FROM users 
WHERE user_ID = 1;  -- Replace with the logged-in user's ID''';

// 5. Update Last Login Timestamp
String updateLoginTimeQuery = 
'''UPDATE users 
SET last_login = CURRENT_TIMESTAMP 
WHERE user_ID = 1;  -- Replace with logged-in user's ID''';

Map<String, dynamic> updateLoginTimeDict = {
    'userID': 1 // Replace with the logged-in user's actual ID
};

// 6. Update User Password (Forgot Password)
String changePasswordQuery = 
'''UPDATE users 
SET user_password = 'new_hashed_password_here' 
WHERE user_email = 'user@example.com';''';

Map<String, dynamic> changePasswordDict = {
    'newPassword': 'new_hashed_password_here', // Replace with the actual hashed password
    'userEmail': 'user@example.com' // Replace with the actual user's email
};

// 7. Delete User Account (If Needed)
String deleteUserQuery =
'''DELETE FROM users WHERE user_ID = 1;  -- Replace with actual user_ID''';

Map<String, dynamic> deleteUserDict = {
  'userID': 1 // Replace with the actual user ID
};

//FUNCTIONS TO CALL FROM FRONTEND

//1. login
await readQuery(loginQuery);

//2. check email
await readQuery(emailCheckQuery);

//3. signUp
await insertQuery(signUpQuery, signUpDict);

//4. get profile
await readQuery(profileQuery);

//5. update user
await updateQuery(updateLoginTimeQuery, updateLoginTimeDict);

//6. change password
await updateQuery(changePasswordQuery, changePasswordDict);

//7. delete user
deleteQuery(deleteQuery, deleteUserDict);
