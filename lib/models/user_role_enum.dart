import 'package:get/get_utils/get_utils.dart';

/// Enum representing the user roles in the application,
/// mapping role names to their corresponding integer values from the API.
enum UserRole {
  superAdmin(0, 'SUPER_ADMIN'),
  owner(1, 'OWNER'),
  admin(2, 'ADMIN'),
  manager(3, 'MANAGER');

  final int value;
  final String apiName;

  const UserRole(this.value, this.apiName);

  /// Factory method to create a UserRole from its integer value.
  factory UserRole.fromValue(int value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.manager, // Default or error role
    );
  }

  /// Factory method to create a UserRole from its string name (from API).
  factory UserRole.fromApiName(String name) {
    return UserRole.values.firstWhere(
      (role) => role.apiName == name.toUpperCase(),
      orElse: () => UserRole.manager, // Default or error role
    );
  }

  /// Provides a user-friendly, title-cased display name for the role.
  String get displayName =>
      apiName.replaceAll('_', ' ').capitalizeFirst ?? apiName;
}
