class PollOption {
  final String id;
  final String text;
  final int votes;

  PollOption({
    required this.id,
    required this.text,
    required this.votes,
  });

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      votes: map['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'votes': votes,
    };
  }

  PollOption copyWith({
    String? id,
    String? text,
    int? votes,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
    );
  }
}

class PollModel {
  final String id;
  final String userId;
  final String question;
  final List<PollOption> options;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int totalVotes;
  final List<String> tags;
  final bool isAnonymous;
  final String category;

  PollModel({
    required this.id,
    required this.userId,
    required this.question,
    required this.options,
    required this.createdAt,
    required this.expiresAt,
    required this.totalVotes,
    required this.tags,
    required this.isAnonymous,
    required this.category,
  });

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      question: map['question'] ?? '',
      options: List<PollOption>.from(
        (map['options'] as List? ?? []).map(
              (option) => PollOption.fromMap(option),
        ),
      ),
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      expiresAt: (map['expiresAt'] as DateTime?) ?? DateTime.now().add(const Duration(days: 1)),
      totalVotes: map['totalVotes'] ?? 0,
      tags: List<String>.from(map['tags'] as List? ?? []),
      isAnonymous: map['isAnonymous'] ?? false,
      category: map['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'question': question,
      'options': options.map((option) => option.toMap()).toList(),
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'totalVotes': totalVotes,
      'tags': tags,
      'isAnonymous': isAnonymous,
      'category': category,
    };
  }

  PollModel copyWith({
    String? id,
    String? userId,
    String? question,
    List<PollOption>? options,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? totalVotes,
    List<String>? tags,
    bool? isAnonymous,
    String? category,
  }) {
    return PollModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      question: question ?? this.question,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      totalVotes: totalVotes ?? this.totalVotes,
      tags: tags ?? this.tags,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      category: category ?? this.category,
    );
  }

  double getPercentage(String optionId) {
    if (totalVotes == 0) return 0;

    final option = options.firstWhere(
          (option) => option.id == optionId,
      orElse: () => PollOption(id: '', text: '', votes: 0),
    );

    return (option.votes / totalVotes) * 100;
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get timeLeft => expiresAt.difference(DateTime.now());
}