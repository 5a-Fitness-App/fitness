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
