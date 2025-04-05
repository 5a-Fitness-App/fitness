CREATE DATABASE fitnessDatabase;
\c fitnessDatabase;

-- ENUM types
CREATE TYPE user_profile_photo_enum AS ENUM ('fish', 'shark', 'crab', 'dolphin');
CREATE TYPE units_enum AS ENUM ('kg', 'lb');
CREATE TYPE activity_enum AS ENUM ('cardio', 'strength', 'swim', 'yoga', 'meditation');
CREATE TYPE exercise_type_enum AS ENUM ('legs', 'glutes', 'chest', 'back', 'shoulders', 'biceps', 'triceps', 'core', 'cardio');
CREATE TYPE distance_metric_enum AS ENUM ('Miles', 'km');

-- USERS table
CREATE TABLE users (
    user_ID SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_profile_photo user_profile_photo_enum NOT NULL,
    user_bio TEXT,
    user_dob DATE NOT NULL,
    user_weight INT NOT NULL CHECK (user_weight > 0),
    user_units units_enum NOT NULL,
    users_account_creation_date DATE NOT NULL, -- Fixed period typo
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);

-- FRIENDS table
CREATE TABLE friends (
    user_ID INT,
    friend_ID INT,
    friend_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, friend_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (friend_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (user_ID <> friend_ID)
);

-- FRIEND REQUESTS table
CREATE TABLE friend_requests (
    sender_ID INT,
    receiver_ID INT,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sender_ID, receiver_ID),
    FOREIGN KEY (sender_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (receiver_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (sender_ID <> receiver_ID)
);

-- WORKOUTS table
CREATE TABLE workouts (
    workout_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_title VARCHAR(25) NOT NULL,
    workout_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workout_public BOOL NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- EXERCISES table
CREATE TABLE exercises (
    exercise_ID SERIAL PRIMARY KEY,
    exercise_type exercise_type_enum NOT NULL,
    exercise_name VARCHAR(25) NOT NULL
);

-- ACTIVITIES table
CREATE TABLE activities (
    activity_ID SERIAL PRIMARY KEY,
    workout_ID INT NOT NULL,
    exercise_ID INT NOT NULL,
    activity_name VARCHAR(25) NOT NULL,
    activity_type activity_enum NOT NULL,
    activity_notes TEXT,
    activity_reps INT NOT NULL,
    activity_time TIMESTAMP NOT NULL,
    activity_weight_metric units_enum NOT NULL,
    activity_incline INT,
    activity_distance_metric distance_metric_enum NOT NULL, -- fixed typo "metic"
    activity_distance INT NOT NULL CHECK (activity_distance >= 0),
    activity_elevation INT NOT NULL CHECK (activity_elevation >= 0),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (exercise_ID) REFERENCES exercises(exercise_ID) ON DELETE CASCADE
);

-- ACHIEVEMENTS table
CREATE TABLE achievements (
    achievements_ID SERIAL PRIMARY KEY,
    user_ID INT,
    achievement_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- COMMENTS table
CREATE TABLE comments (
    comment_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL, -- added to make FK reference work
    content TEXT NOT NULL,
    date_commented TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- LIKES table
CREATE TABLE likes (
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
    date_liked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, workout_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- USERS_ACHIEVEMENTS table
CREATE TABLE users_achievements (
    user_ID INT NOT NULL,
    achievements_ID INT NOT NULL,
    completed BOOL NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, achievements_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (achievements_ID) REFERENCES achievements(achievements_ID) ON DELETE CASCADE
);

-- WORKOUT_COMMENTS table
CREATE TABLE workout_comments (
    workout_ID INT,
    comment_ID INT,
    PRIMARY KEY (workout_ID, comment_ID),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (comment_ID) REFERENCES comments(comment_ID) ON DELETE CASCADE
);
<<<<<<< HEAD



INSERT INTO users (user_name, user_profile_photo, user_bio, user_dob, user_weight, user_units, users_account_creation_date, user_email, user_password) VALUES
('Alice', 'fish', 'Loves swimming and strength training.', '1990-05-12', 65, 'kg', '2024-01-10', 'alice@example.com', 'hashedpassword1'),
('Bob', 'shark', 'Runner and yoga enthusiast.', '1985-09-30', 75, 'kg', '2024-02-15', 'bob@example.com', 'hashedpassword2'),
('Charlie', 'crab', 'Cardio king.', '1992-12-20', 80, 'lb', '2024-03-01', 'charlie@example.com', 'hashedpassword3'),
('Diana', 'dolphin', 'Weightlifter and food lover.', '1995-07-18', 70, 'kg', '2024-03-20', 'diana@example.com', 'hashedpassword4'),
('Eli', 'fish', 'All about meditation and core strength.', '1998-04-22', 60, 'kg', '2024-04-01', 'eli@example.com', 'hashedpassword5');


INSERT INTO exercises (exercise_type, exercise_name) VALUES
('legs', 'Squats'),
('glutes', 'Hip Thrusts'),
('chest', 'Bench Press'),
('back', 'Deadlift'),
('shoulders', 'Overhead Press'),
('biceps', 'Bicep Curls'),
('triceps', 'Tricep Dips'),
('core', 'Plank'),
('cardio', 'Running');


INSERT INTO workouts (user_ID, workout_title, workout_date_time, workout_public) VALUES
(1, 'Leg Day', '2025-04-01 09:00:00', true),
(1, 'Upper Body Blast', '2025-04-02 10:00:00', false),
(1, 'Core Strength', '2025-04-03 11:00:00', true),
(1, 'Cardio Burn', '2025-04-04 08:00:00', false),
(2, 'Morning Yoga', '2025-04-01 07:00:00', true),
(2, 'Strength Push', '2025-04-02 12:00:00', false),
(2, 'Long Run', '2025-04-03 06:00:00', true),
(2, 'Back and Biceps', '2025-04-04 09:30:00', false),
(3, 'Cardio Madness', '2025-04-01 17:00:00', true),
(3, 'Full Body HIIT', '2025-04-02 17:00:00', true),
(3, 'Core & Cardio', '2025-04-03 17:00:00', true),
(3, 'Run + Plank', '2025-04-04 17:00:00', true),
(4, 'Chest Power', '2025-04-01 14:00:00', false),
(4, 'Glute Gains', '2025-04-02 15:00:00', true),
(4, 'Arm Strength', '2025-04-03 13:00:00', false),
(4, 'Yoga Recovery', '2025-04-04 16:00:00', true),
(5, 'Core and Meditation', '2025-04-01 10:00:00', true),
(5, 'Stretch and Strength', '2025-04-02 10:30:00', true),
(5, 'Run & Reflect', '2025-04-03 07:00:00', true),
(5, 'Total Body Flow', '2025-04-04 11:00:00', false);



INSERT INTO activities (
    workout_ID, exercise_ID, activity_name, activity_type, activity_notes, activity_reps, activity_time,
    activity_weight_metric, activity_incline, activity_distance_metric, activity_distance, activity_elevation
) VALUES
-- Alice
(1, 1, 'Back Squats', 'strength', 'Focus on form', 10, '2025-04-01 09:05:00', 'kg', 0, 'km', 0, 0),
(1, 2, 'Hip Thrusts', 'strength', 'Use resistance bands', 12, '2025-04-01 09:15:00', 'kg', 0, 'km', 0, 0),
(2, 3, 'Bench Press', 'strength', '3 sets, heavy', 8, '2025-04-02 10:10:00', 'kg', 0, 'km', 0, 0),
(2, 5, 'Overhead Press', 'strength', 'Stand firm', 10, '2025-04-02 10:20:00', 'kg', 0, 'km', 0, 0),
(3, 8, 'Plank Hold', 'core', '1-minute hold', 1, '2025-04-03 11:10:00', 'kg', 0, 'km', 0, 0),
(4, 9, 'Treadmill Run', 'cardio', 'Moderate pace', 1, '2025-04-04 08:05:00', 'kg', 1, 'km', 5, 50),

-- Bob
(5, 9, 'Sun Salutations', 'yoga', 'Flow series', 1, '2025-04-01 07:10:00', 'kg', 0, 'km', 0, 0),
(6, 1, 'Squats', 'strength', '5x5', 5, '2025-04-02 12:10:00', 'kg', 0, 'km', 0, 0),
(7, 9, 'Trail Run', 'cardio', 'Outside run', 1, '2025-04-03 06:15:00', 'kg', 2, 'Miles', 3, 70),
(8, 6, 'Bicep Curls', 'strength', '3 sets of 10', 10, '2025-04-04 09:40:00', 'kg', 0, 'km', 0, 0),

-- Charlie
(9, 9, 'Spin Class', 'cardio', '45 minutes', 1, '2025-04-01 17:10:00', 'kg', 3, 'km', 15, 100),
(10, 1, 'Jump Squats', 'cardio', 'Explosive power', 15, '2025-04-02 17:20:00', 'kg', 0, 'km', 0, 0),
(11, 8, 'Plank March', 'core', 'Engage abs', 2, '2025-04-03 17:30:00', 'kg', 0, 'km', 0, 0),
(12, 9, 'Evening Jog', 'cardio', 'Wind down', 1, '2025-04-04 17:40:00', 'kg', 0, 'Miles', 2, 30),

-- Diana
(13, 3, 'Flat Bench Press', 'strength', 'Max out', 5, '2025-04-01 14:05:00', 'kg', 0, 'km', 0, 0),
(14, 2, 'Barbell Glute Bridges', 'strength', 'Activate glutes', 12, '2025-04-02 15:15:00', 'kg', 0, 'km', 0, 0),
(15, 7, 'Tricep Dips', 'strength', 'Bodyweight', 10, '2025-04-03 13:20:00', 'kg', 0, 'km', 0, 0),
(16, 4, 'Downward Dog Flow', 'yoga', 'Breathing focus', 1, '2025-04-04 16:05:00', 'kg', 0, 'km', 0, 0),

-- Eli
(17, 8, 'Plank Variations', 'core', 'Hold each 30s', 4, '2025-04-01 10:10:00', 'kg', 0, 'km', 0, 0),
(18, 5, 'Overhead Dumbbell Press', 'strength', 'Light weight', 10, '2025-04-02 10:40:00', 'kg', 0, 'km', 0, 0),
(19, 9, 'Morning Jog', 'cardio', 'Paced run', 1, '2025-04-03 07:10:00', 'kg', 1, 'km', 3, 40),
(20, 4, 'Yoga Flow + Meditation', 'meditation', 'End with 10m breathwork', 1, '2025-04-04 11:10:00', 'kg', 0, 'km', 0, 0);
=======
>>>>>>> 52cea3ab94986d269bb572fc9351094259e38185
