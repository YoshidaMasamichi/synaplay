class Recruitment {
  final String id;
  final String userId;
  final String title;
  final DateTime date;
  final String area;
  final String level;
  final int maxPlayers;
  final String description;
  final String createdByName;
  final DateTime createdAt;

  const Recruitment({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.area,
    required this.level,
    required this.maxPlayers,
    required this.description,
    required this.createdByName,
    required this.createdAt,
  });

  factory Recruitment.fromJson(Map<String, dynamic> json) {
    return Recruitment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      area: json['area'] as String,
      level: json['level'] as String,
      maxPlayers: json['max_players'] as int,
      description: json['description'] as String,
      createdByName: json['created_by_name'] as String? ?? '名無し',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'title': title,
        'date': date.toIso8601String().substring(0, 10),
        'area': area,
        'level': level,
        'max_players': maxPlayers,
        'description': description,
        'created_by_name': createdByName,
      };
}
