import 'connect_database.dart';
int user_id = 0;
String profileDataQuery =
'''
SELECT 
    u.user_ID,
    u.user_name,
    u.user_dob,
    u.user_weight,
    u.user_email,
    u.user_password,
    COUNT(f.friend_ID) AS friend_count, -- Count of the user's friends
    (SELECT user_profile_photo FROM users WHERE user_ID = u.user_ID) AS profile_picture, -- Assuming profile_picture is a column in users
    ARRAY(SELECT achievement_name FROM achievements WHERE user_ID = u.user_ID) AS achievements, -- List of achievements for the user
    ARRAY(
        SELECT achievement_name 
        FROM achievements a
        JOIN users_achievements ua ON a.achievements_ID = ua.achievements_ID
        WHERE ua.user_ID = u.user_ID AND ua.completed = TRUE
    ) AS completed_achievements, -- Completed achievements
    ARRAY(
        SELECT friend_user_name
        FROM users f 
        JOIN friends fr ON f.user_ID = fr.friend_ID 
        WHERE fr.user_ID = u.user_ID
    ) AS friends_user_names, -- Usernames of friends
    ARRAY(
        SELECT fr.friend_ID
        FROM friends fr
        WHERE fr.user_ID = u.user_ID
    ) AS friends_user_ids, -- IDs of friends
    COUNT(c.comment_ID) AS total_comments -- Total number of comments on the user's workouts
FROM 
    users u
LEFT JOIN 
    friends f ON u.user_ID = f.user_ID OR u.user_ID = f.friend_ID
LEFT JOIN 
    comments c ON c.user_ID = u.user_ID
LEFT JOIN 
    achievements a ON a.user_ID = u.user_ID
WHERE 
    u.user_ID = $user_id -- This will be replaced by the actual user_id dynamically
GROUP BY 
    u.user_ID;
''';

readQuery(profileDataQuery);
