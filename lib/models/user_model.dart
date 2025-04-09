class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoURL;
  final String bio;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> interests;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.bio,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
    required this.interests,
  });

  // Create a user from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      bio: map['bio'] ?? '',
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      createdAt: (map['createdAt'] != null)
          ? (map['createdAt'] as DateTime)
          : DateTime.now(),
      updatedAt: (map['updatedAt'] != null)
          ? (map['updatedAt'] as DateTime)
          : DateTime.now(),
      interests: List<String>.from(map['interests'] ?? []),
    );
  }

  // Convert user to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'bio': bio,
      'followers': followers,
      'following': following,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'interests': interests,
    };
  }

  // Create a copy of the user with updated fields
  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? bio,
    int? followers,
    int? following,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? interests,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      interests: interests ?? this.interests,
    );
  }
}