// Model to store the logged in user's data to be shared across the app
// Managed by backend/providers/user_provider.dart
class User {
  int? userID;

  String userName;

  String userProfilePhoto;

  String? userBio;

  DateTime userDOB;

  double userWeight;

  String userUnits;

  DateTime accountCreationDate;

  String userEmail;

  int friendCount;

  User(
      {this.userID,
      this.userName = '',
      this.userProfilePhoto = 'fish',
      this.userBio = '',
      required this.userDOB,
      this.userWeight = 0,
      this.userUnits = 'kg',
      required this.accountCreationDate,
      this.userEmail = '',
      this.friendCount = 0});

  User copyWith(
      {int? userID,
      String? userName,
      String? userProfilePhoto,
      String? userBio,
      DateTime? userDOB,
      double? userWeight,
      String? userUnits,
      DateTime? accountCreationDate,
      String? userEmail,
      int? friendCount}) {
    return User(
        userID: userID ?? this.userID,
        userProfilePhoto: userProfilePhoto ?? this.userProfilePhoto,
        userName: userName ?? this.userName,
        userBio: userBio ?? this.userBio,
        userDOB: userDOB ?? this.userDOB,
        userWeight: userWeight ?? this.userWeight,
        userUnits: userUnits ?? this.userUnits,
        accountCreationDate: accountCreationDate ?? this.accountCreationDate,
        userEmail: userEmail ?? this.userEmail,
        friendCount: friendCount ?? this.friendCount);
  }
}
