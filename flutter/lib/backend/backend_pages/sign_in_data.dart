/// 1. Authenticate User (Login)
String login = '''SELECT user_ID, user_name, user_email, user_password 
FROM users 
WHERE user_email = 'user@example.com';
''';
// 2. Check if Email Exists (Before Login or Registration)
String emailCheck =
    '''SELECT user_ID FROM users WHERE user_email = 'user@example.com';''';

// 3. Register a New User (Sign Up)
String signUp =
    '''INSERT INTO users (user_name, user_dob, user_weight, user_email, user_password)
VALUES ('JohnDoe', '1995-06-15', 75, 'john@example.com', 'hashed_password_here');''';

// 4. Get User Profile After Login
String profile =
    '''SELECT user_ID, user_name, user_dob, user_weight, user_email 
FROM users 
WHERE user_ID = 1;  -- Replace with the logged-in user's ID''';

// 5. Update Last Login Timestamp
String updateUser = '''UPDATE users 
SET last_login = CURRENT_TIMESTAMP 
WHERE user_ID = 1;  -- Replace with logged-in user's ID''';

// 6. Update User Password (Forgot Password)
String changePassword = '''UPDATE users 
SET user_password = 'new_hashed_password_here' 
WHERE user_email = 'user@example.com';''';

// 7. Delete User Account (If Needed)
String deleteUser =
    '''DELETE FROM users WHERE user_ID = 1;  -- Replace with actual user_ID''';

void main(List<String> args) {}
