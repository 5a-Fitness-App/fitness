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

  User({
    this.userID,
    this.userName = '',
    this.userProfilePhoto = 'fish',
    this.userBio = '',
    required this.userDOB,
    this.userWeight = 0,
    this.userUnits = 'kg',
    required this.accountCreationDate,
    this.userEmail = '',
  });

  User copyWith({
    int? userID,
    String? userName,
    String? userProfilePhoto,
    String? userBio,
    DateTime? userDOB,
    double? userWeight,
    String? userUnits,
    DateTime? accountCreationDate,
    String? userEmail,
  }) {
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
    );
  }
}
