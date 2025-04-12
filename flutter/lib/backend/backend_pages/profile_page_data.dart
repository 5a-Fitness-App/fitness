import 'connect_database.dart';

int user_id = 0;
String profileDataQuery = '''
SELECT 
    u.user_ID,
    u.user_name,
    u.user_dob,
    u.user_weight,
    u.user_email,
    u.user_password,
    COUNT(DISTINCT f.friend_ID) AS friend_count,  -- Unique friends
    u.user_profile_photo AS profile_picture,  -- Assuming profile_picture column exists
    ARRAY(SELECT achievement_name FROM achievements WHERE user_ID = u.user_ID) AS achievements,  -- All achievements
    ARRAY(
        SELECT achievement_name 
        FROM achievements a
        JOIN users_achievements ua ON a.achievements_ID = ua.achievements_ID
        WHERE ua.user_ID = u.user_ID AND ua.completed = TRUE
    ) AS completed_achievements,  -- Completed achievements
    ARRAY(
        SELECT f.user_name
        FROM users f 
        JOIN friends fr ON f.user_ID = fr.friend_ID 
        WHERE fr.user_ID = u.user_ID
    ) AS friends_user_names,  -- Friends' usernames
    ARRAY(
        SELECT fr.friend_ID
        FROM friends fr
        WHERE fr.user_ID = u.user_ID
    ) AS friends_user_ids,  -- Friends' IDs
    COUNT(c.comment_ID) AS total_comments,  -- Total comments on the user's workouts
    COUNT(l.like_ID) AS total_likes  -- Count of likes on the user's workouts
FROM 
    users u
LEFT JOIN 
    friends f ON u.user_ID = f.user_ID OR u.user_ID = f.friend_ID
LEFT JOIN 
    comments c ON c.user_ID = u.user_ID
LEFT JOIN 
    achievements a ON a.user_ID = u.user_ID
LEFT JOIN 
    likes l ON l.workout_ID IN (SELECT workout_ID FROM workouts WHERE user_ID = u.user_ID)  -- Assuming likes are linked to workouts of the user
WHERE 
    u.user_ID = $user_id  
GROUP BY 
    u.user_ID;''';

// Future<void> main() async {
//   try {
//     await connection.open();
//     print('Connected to PostgreSQL ✅');

//     await readQuery("SELECT * from activities");
//   } catch (e) {
//     print('Error connecting to PostgreSQL ❌: $e');
//   } finally {
//     await connection.close();
//     print('Connection closed 🔒');
//   }
// }
