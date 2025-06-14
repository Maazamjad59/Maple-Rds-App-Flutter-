class Curriculum {
  final String id;
  final String subject;
  final String gradeLevel;
  final String description;
  final String academicYear;

  Curriculum({
    required this.id,
    required this.subject,
    required this.gradeLevel,
    required this.description,
    required this.academicYear,
  });

  factory Curriculum.fromMap(Map<String, dynamic> data, String id) {
    return Curriculum(
      id: id,
      subject: data['subject'] ?? '',
      gradeLevel: data['gradeLevel'] ?? '',
      description: data['description'] ?? '',
      academicYear: data['academicYear'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'gradeLevel': gradeLevel,
      'description': description,
      'academicYear': academicYear,
    };
  }
}