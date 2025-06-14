class Announcement {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime date;
  final String postedBy;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.date,
    required this.postedBy,
  });

  factory Announcement.fromMap(Map<String, dynamic> data) {
    return Announcement(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      postedBy: data['postedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date.millisecondsSinceEpoch,
      'postedBy': postedBy,
    };
  }
}