CREATE TYPE exercise_name_enum AS ENUM (
  -- Legs
  'Back Squats', --1
  'Front Squats', --2 
  'Hack Squats', --3
  'Bulgarian Split Squats', --4
  'Step-ups', --5 
  'Goblet Squats', --6 
  'RDLS', --7 
  'Leg Extensions (Machine)', --8 
  'Leg Curls (Machine)', --9
  'Calf Raises', --10
  'Single-leg Leg Press', --11

  -- Glutes
  'Hip Thrust', --12
  'Donkey Kick', --13
  'Hip Abductor', --14

  -- Chest
  'Bench Press', --15
  'Chest Flys', --16
  'Push-Ups', --17
  'Dumbell Chest Press', --18
  'Chest Press (Machine)',
  'Deadlifts',
  'Pull-ups',
  'Rows (Barbell)',
  'Rows (Dumbbell)',
  'Lat Pulldown',
  'T-Bar Rows',

  -- Back
  'Lat Rows (Machine)',
  'Lat Rows (Cable)',
  'Upper Back Rows (Machine)',
  'Upper Back Rows (Cable)',
  'Pullovers',

  -- Shoulders
  'Overhead Press',
  'Shoulder Press',
  'Lat Raises',
  'Front Raises',
  'Rear Delt Flys',
  'Face Pulls',
  'Shrugs',

  -- Biceps
  'Bicep Curls',
  'Hammer Curls',
  'Barbell Curls',
  'Preacher Curls',
  'Concentration Curls',

  -- Triceps
  'Tricep Dips',
  'Tricep Pushdowns',
  'Skull Crushers',
  'Close-Grip Bench Press',
  'Overhead Tricep Extensions',

  -- Core
  'Planks',
  'Russian Twists',
  'Leg Raises',
  'Sit-Ups',
  'Bicycle Crunches',
  'Hanging Leg Raises',
  'Cable Woodchoppers',
  'Ab Rollouts',

  -- Cardio
  'Running',
  'Walking',
  'Treadmill',
  'Cycling',
  'Swimming',
  'Rowing',
  'Jumping Jacks',
  'Stair Climbing'
);

CREATE TYPE exercise_target_enum AS ENUM (
  'Legs',
  'Glutes',
  'Chest',
  'Back',
  'Shoulders',
  'Biceps',
  'Triceps',
  'Core',
  'Cardio'
);

CREATE TYPE weight_units_enum AS ENUM ('kg', 'lb');

-- CREATE TYPE distance_units_enum AS ENUM ('mi', 'km');

CREATE TYPE profile_photo_enum AS ENUM ('fish', 'shark', 'crab', 'dolphin');

-- USERS table
CREATE TABLE users (
    user_ID SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL UNIQUE,
    user_profile_photo profile_photo_enum NOT NULL,
    user_bio TEXT,
    user_dob DATE NOT NULL,
    user_weight NUMERIC(5,2) CHECK (user_weight > 0),
    user_weight_unit weight_units_enum NOT NULL DEFAULT 'kg',
    users_account_creation_date DATE NOT NULL,
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

-- ACHIEVEMENTS table
CREATE TABLE achievements (
    achievement_ID SERIAL PRIMARY KEY,
    achievement_description VARCHAR(255) NOT NULL
);

-- USERS_ACHIEVEMENTS table
CREATE TABLE users_achievements (
    user_ID INT NOT NULL,
    achievement_ID INT NOT NULL,
    completed BOOL NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, achievement_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (achievement_ID) REFERENCES achievements(achievement_ID) ON DELETE CASCADE
);

-- WORKOUTS table
CREATE TABLE workouts (
    workout_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_caption TEXT NOT NULL,
    workout_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workout_public BOOL NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- EXERCISES table
CREATE TABLE exercises (
  exercise_ID SERIAL PRIMARY KEY,
  exercise_name exercise_name_enum NOT NULL UNIQUE,
  exercise_target exercise_target_enum NOT NULL
);

-- ACTIVITIES table
CREATE TABLE activities (
  activity_ID SERIAL PRIMARY KEY,
  workout_ID INT NOT NULL,
  exercise_ID INT NOT NULL,
  activity_notes TEXT,
  activity_metrics JSONB,
  FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
  FOREIGN KEY (exercise_ID) REFERENCES exercises(exercise_ID) ON DELETE CASCADE
);

-- COMMENTS table
CREATE TABLE comments (
    comment_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
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

-- Legs
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Back Squats', 'Legs'),
('Front Squats', 'Legs'),
('Hack Squats', 'Legs'),
('Bulgarian Split Squats', 'Legs'),
('Step-ups', 'Legs'),
('Goblet Squats', 'Legs'),
('RDLS', 'Legs'),
('Leg Extensions (Machine)', 'Legs'),
('Leg Curls (Machine)', 'Legs'),
('Calf Raises', 'Legs'),
('Single-leg Leg Press', 'Legs'),
('Deadlifts', 'Legs');

-- Glutes
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Hip Thrust', 'Glutes'),
('Donkey Kick', 'Glutes'),
('Hip Abductor', 'Glutes');

-- Chest
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Bench Press', 'Chest'),
('Chest Flys', 'Chest'),
('Push-Ups', 'Chest'),
('Dumbell Chest Press', 'Chest'),
('Chest Press (Machine)', 'Chest'),
('Rows (Barbell)', 'Chest'),
('Rows (Dumbbell)', 'Chest'),
('Lat Pulldown', 'Chest'),
('T-Bar Rows', 'Chest');

-- Back
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Lat Rows (Machine)', 'Back'),
('Lat Rows (Cable)', 'Back'),
('Upper Back Rows (Machine)', 'Back'),
('Upper Back Rows (Cable)', 'Back'),
('Pullovers', 'Back'),
('Pull-ups', 'Back');

-- Shoulders
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Overhead Press', 'Shoulders'),
('Shoulder Press', 'Shoulders'),
('Lat Raises', 'Shoulders'),
('Front Raises', 'Shoulders'),
('Rear Delt Flys', 'Shoulders'),
('Face Pulls', 'Shoulders'),
('Shrugs', 'Shoulders');

-- Biceps
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Bicep Curls', 'Biceps'),
('Hammer Curls', 'Biceps'),
('Barbell Curls', 'Biceps'),
('Preacher Curls', 'Biceps'),
('Concentration Curls', 'Biceps');

-- Triceps
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Tricep Dips', 'Triceps'),
('Tricep Pushdowns', 'Triceps'),
('Skull Crushers', 'Triceps'),
('Close-Grip Bench Press', 'Triceps'),
('Overhead Tricep Extensions', 'Triceps');

-- Core
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Planks', 'Core'),
('Russian Twists', 'Core'),
('Leg Raises', 'Core'),
('Sit-Ups', 'Core'),
('Bicycle Crunches', 'Core'),
('Hanging Leg Raises', 'Core'),
('Cable Woodchoppers', 'Core'),
('Ab Rollouts', 'Core');

-- Cardio
INSERT INTO exercises (exercise_name, exercise_target) VALUES
('Running', 'Cardio'),
('Walking', 'Cardio'),
('Treadmill', 'Cardio'),
('Cycling', 'Cardio'),
('Swimming', 'Cardio'),
('Rowing', 'Cardio'),
('Jumping Jacks', 'Cardio'),
('Stair Climbing', 'Cardio');

-- Insert 10 users
INSERT INTO users (user_name, user_profile_photo, user_bio, user_dob, user_weight, user_weight_unit, users_account_creation_date, user_email, user_password)
VALUES 
('aqua_fish', 'fish', 'Love swimming and weights!', '1995-06-15', 70.2, 'kg', '2023-01-15', 'aqua_fish@example.com', 'hashedpassword1'),
('shark_boi', 'shark', 'Shark in the gym 🦈', '1998-04-23', 85.6, 'kg', '2023-02-10', 'shark_boi@example.com', 'hashedpassword2'),
('crabby_abs', 'crab', 'Core strength fanatic!', '2000-11-09', 65.9, 'kg', '2023-03-05', 'crabby_abs@example.com', 'hashedpassword3'),
('dolphin_dash', 'dolphin', 'Cardio queen 🐬', '1993-07-29', 60.2, 'kg', '2023-04-20', 'dolphin_dash@example.com', 'hashedpassword4'),
('leg_day_lady', 'fish', 'Never skips leg day', '1997-09-17', 68.1, 'kg', '2023-05-08', 'legdaylady@example.com', 'hashedpassword5');

-- Insert 5 workouts for each user (user_ID from 1 to 10)
INSERT INTO workouts (user_ID, workout_caption, workout_date_time, workout_public)
VALUES
-- User 1
(1, 'Leg day grind!', '2024-01-01 10:00', TRUE),
(1, 'Back and biceps', '2024-02-03 10:00', TRUE),
(1, 'Core focus', '2024-02-05 10:00', TRUE),
(1, 'Shoulder shredder', '2024-06-07 10:00', TRUE),
(1, 'Full body blast', '2024-08-09 10:00', TRUE),

-- User 2
(2, 'Swim cardio + weights', '2024-01-02 11:00', FALSE),
(2, 'Deadlift PR!', '2024-03-04 11:00', TRUE),
(2, 'Upper back power', '2024-10-06 11:00', FALSE),
(2, 'Push day', '2024-10-08 11:00', TRUE),
(2, 'Recovery day walk', '2024-07-10 11:00', TRUE),

-- User 3
(3, 'Crab crunches 🦀', '2024-02-01 09:00', TRUE),
(3, 'Bicep curls till failure', '2024-02-03 09:00', TRUE),
(3, 'Machine focus day', '2024-06-05 09:00', FALSE),
(3, 'High rep endurance', '2024-06-07 09:00', TRUE),
(3, 'Glute bridges & kicks', '2024-08-09 09:00', TRUE),

-- User 4
(4, 'Stair climb HIIT', '2024-02-02 08:00', TRUE),
(4, 'Sprint intervals', '2024-03-04 08:00', TRUE),
(4, 'Treadmill + arms', '2024-02-06 08:00', FALSE),
(4, 'Zumba fun', '2024-12-08 08:00', TRUE),
(4, 'Cycling + yoga', '2024-06-10 08:00', TRUE),

-- User 5
(5, 'Split squats all day', '2024-05-01 17:00', TRUE),
(5, 'Step ups and RDLs', '2024-01-03 17:00', FALSE),
(5, 'Back day', '2024-11-05 17:00', TRUE),
(5, 'Leg press record', '2024-03-07 17:00', TRUE),
(5, 'Donkey kicks to finish', '2024-09-09 17:00', TRUE);

-- Activities for User 1
INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
VALUES
-- Workout 1: Leg day grind!
(1, 1, 'Back Squats for 4 sets of 10 reps', '{"sets": 4, "reps": 10, "weight": 80, "unit": "kg"}'),
(1, 2, 'Front Squats for 3 sets of 8 reps', '{"sets": 3, "reps": 8, "weight": 70, "unit": "kg"}'),
(1, 3, 'Hack Squats for 3 sets of 10 reps', '{"sets": 3, "reps": 10, "weight": 60, "unit": "kg"}'),
(1, 4, 'Bulgarian Split Squats for 4 sets of 12 reps', '{"sets": 4, "reps": 12, "weight": 20, "unit": "kg"}'),

-- Workout 2: Back and biceps
(2, 20, 'Rows (Barbell) for 4 sets of 8 reps', '{"sets": 4, "reps": 8, "weight": 60, "unit": "kg"}'),
(2, 38, 'Bicep Curls for 3 sets of 12 reps', '{"sets": 3, "reps": 12, "weight": 12, "unit": "kg"}'),

-- Workout 3: Core focus
(3, 48, 'Planks for 1 minute', '{"time": "60s"}'),
(3, 26, 'Russian Twists for 4 sets of 20 reps', '{"sets": 4, "reps": 20, "weight": 5, "unit": "kg"}'),

-- Workout 4: Shoulder shredder
(4, 31, 'Overhead Press for 4 sets of 8 reps', '{"sets": 4, "reps": 8, "weight": 50, "unit": "kg"}'),
(4, 34, 'Front Raises for 3 sets of 12 reps', '{"sets": 3, "reps": 12, "weight": 8, "unit": "kg"}'),

-- Workout 5: Full body blast
(5, 29, 'Deadlifts for 5 sets of 5 reps', '{"sets": 5, "reps": 5, "weight": 100, "unit": "kg"}'),
(5, 21, 'Rows (Dumbbell) for 4 sets of 10 reps', '{"sets": 4, "reps": 10, "weight": 18, "unit": "kg"}');

-- Activities for User 2
INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
VALUES
-- Workout 1: Swim cardio + weights
(6, 36, 'Swimming for 30 minutes', '{"time": "30m", "distance": 1000, "unit": "m"}'),

-- Workout 2: Deadlift PR!
(7, 20, 'Deadlifts for 5 sets of 5 reps', '{"sets": 5, "reps": 5, "weight": 160, "unit": "kg"}'),
(7, 21, 'Pull-ups for 3 sets of 10 reps', '{"sets": 3, "reps": 10}'),

-- Workout 3: Upper back power
(8, 22, 'Lat Rows (Machine) for 4 sets of 8 reps', '{"sets": 4, "reps": 8, "weight": 80, "unit": "kg"}'),

-- Workout 4: Push day
(9, 14, 'Bench Press for 4 sets of 8 reps', '{"sets": 4, "reps": 8, "weight": 80, "unit": "kg"}'),

-- Workout 5: Recovery day walk
(10, 38, 'Walking for 45 minutes', '{"time": "45m", "distance": 5000, "unit": "m"}');

-- Activities for User 3
INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
VALUES
-- Workout 1: Crab crunches 🦀
(11, 25, 'Planks for 45 seconds', '{"time": "45s"}'),
(11, 26, 'Russian Twists for 3 sets of 25 reps', '{"sets": 3, "reps": 25, "weight": 6, "unit": "kg"}'),

-- Workout 2: Bicep curls till failure
(12, 28, 'Bicep Curls for 3 sets to failure', '{"sets": 3, "reps": 20, "weight": 10, "unit": "kg"}'),

-- Workout 3: Machine focus day
(13, 17, 'Push-Ups for 4 sets of 12 reps', '{"sets": 4, "reps": 12, "weight": 40, "unit": "kg"}'),

-- Workout 4: High rep endurance
(14, 31, 'Lat Pulldown for 5 sets of 20 reps', '{"sets": 5, "reps": 20, "weight": 50, "unit": "kg"}'),

-- Workout 5: Glute bridges & kicks
(15, 9, 'Hip Thrust for 4 sets of 12 reps', '{"sets": 4, "reps": 12, "weight": 40, "unit": "kg"}');

-- Activities for User 4
INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
VALUES
-- Workout 1: Stair climb HIIT
(16, 36, 'Stair Climbing for 15 minutes', '{"time": "15m", "distance": 200, "unit": "m", "incline": 5}'),

-- Workout 2: Sprint intervals
(17, 39, 'Running for 30 seconds, rest for 60 seconds', '{"time": "10m", "distance": "400", "unit": "m"}'),

-- Workout 3: Treadmill + arms
(18, 14, 'Bench Press for 4 sets of 8 reps', '{"sets": 4, "reps": 8, "weight": 50, "unit": "kg"}'),

-- Workout 4: Zumba fun
(19, 38, 'Walking for 30 minutes', '{"time": "30m", "distance": 4000, "unit": "m"}'),

-- Workout 5: Cycling + yoga
(20, 37, 'Cycling for 40 minutes', '{"time": "40m", "distance": 12000, "unit": "m"}');

-- Activities for User 5
INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
VALUES
-- Workout 1: Split squats all day
(21, 1, 'Back Squats for 4 sets of 12 reps', '{"sets": 4, "reps": 12, "weight": 70, "unit": "kg"}'),
(21, 3, 'Hack Squats for 3 sets of 10 reps', '{"sets": 3, "reps": 10, "weight": 60, "unit": "kg"}'),

-- Workout 2: Step ups and RDLs
(22, 8, 'Leg Extensions (Machine) for 4 sets of 12 reps', '{"sets": 4, "reps": 12, "weight": 40, "unit": "kg"}'),
(22, 7, 'RDLS for 3 sets of 10 reps', '{"sets": 3, "reps": 10, "weight": 80, "unit": "kg"}'),

-- Workout 3: Core blast
(23, 25, 'Planks for 1 minute', '{"time": "60s"}'),
(23, 26, 'Russian Twists for 4 sets of 20 reps', '{"sets": 4, "reps": 20, "weight": 10, "unit": "kg"}'),

-- Workout 4: Shoulder burn
(24, 13, 'Struggled with this one', '{"sets": 4, "reps": 8, "weight": 55, "unit": "kg"}'),

-- Workout 5: Full body conditioning
(25, 12, 'need to fix my form', '{"sets": 4, "reps": 5, "weight": 100, "unit": "kg"}');


INSERT INTO achievements (achievement_description)
VALUES
('First Workout Completed'),
('Completed 10 Workouts'),
('Comment on a friends Post'),
('Like a friends Post'),
('First Friend Added');

INSERT INTO users_achievements (user_ID, achievement_ID, completed, date_earned)
VALUES
(1, 1, TRUE, '2024-01-01 10:00'),
(1, 2, TRUE, '2024-01-05 10:00'),
(1, 3, TRUE, '2024-01-04 11:00'), 
(1, 4, TRUE, '2024-02-07 09:00'), 
(1, 5, TRUE, '2024-03-01 17:00'); 

-- Insert likes
INSERT INTO likes (user_ID, workout_ID) VALUES
-- User 1 likes User 2's workout
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),

-- User 2 likes User 3's workout
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),

-- User 3 likes User 4's workout
(3, 16),
(3, 17),
(3, 18),
(3, 19),
(3, 20),

-- User 4 likes User 5's workout
(4, 21),
(4, 22),
(4, 23),
(4, 24),
(4, 25),

-- User 5 likes User 1's workout
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5);

-- Insert comments
INSERT INTO comments (user_ID, workout_ID, content) VALUES
-- User 1 comments on User 2's workout
(1, 6, 'Great swimming technique!'),
(1, 7, 'Awesome Deadlift PR!'),
(1, 8, 'Keep going strong!'),
(1, 9, 'Push day looks amazing!'),
(1, 10, 'Good recovery workout!'),

-- User 2 comments on User 3's workout
(2, 1, 'Wow!'),
(2, 11, 'Love the crab crunches!'),
(2, 12, 'Great bicep curls session!'),
(2, 13, 'Machine workout looks effective!'),
(2, 14, 'Nice endurance workout!'),
(2, 15, 'Glute bridges look solid!'),

-- User 3 comments on User 4's workout
(3, 16, 'Stair climb HIIT is tough!'),
(3, 17, 'Sprint intervals are intense!'),
(3, 18, 'Treadmill + arms combo looks fun!'),
(3, 19, 'Zumba looks like a blast!'),
(3, 20, 'Cycling and yoga, perfect combo!'),

-- User 4 comments on User 5's workout
(4, 21, 'Split squats are always challenging!'),
(4, 22, 'Step ups and RDLs are great for legs!'),
(4, 23, 'Nice workout on the machines!'),
(4, 24, 'High reps build endurance!'),
(4, 25, 'Glute bridges are effective for activation!'),

-- User 5 comments on User 1's workout
(5, 1, 'Great leg day workout!'),
(5, 2, 'Back and biceps look strong!'),
(5, 3, 'Core focus is essential!'),
(5, 4, 'Shoulder shredder looks intense!'),
(5, 5, 'Full body blast is always a great session!');

-- Insert friend requests
INSERT INTO friend_requests (sender_ID, receiver_ID) VALUES
-- User 1 sends request to User 2
(1, 2),
-- User 2 sends request to User 3
(2, 3),
-- User 3 sends request to User 4
(3, 4),
-- User 4 sends request to User 5
(4, 5),
-- User 5 sends request to User 1
(4, 1);

-- Insert friends
INSERT INTO friends (user_ID, friend_ID) VALUES
-- User 1 and User 2 are friends
(1, 2),
(2, 1),
(1, 3),
(3, 1),
-- User 2 and User 3 are friends
(2, 3),
(3, 2),

-- User 3 and User 4 are friends
(3, 4),
(4, 3),
-- User 4 and User 5 are friends
(4, 5),
(5, 4),
-- User 5 and User 1 are friends
(5, 1),
(1, 5);