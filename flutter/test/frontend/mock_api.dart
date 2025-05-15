library mock_api;

// This will shadow the real API when imported
Future<String?> mockRegister(String username, String profilePhoto, DateTime dob,
    double weight, String weightUnits, String email, String password) async {
  // Default mock implementation
  return null;
}
