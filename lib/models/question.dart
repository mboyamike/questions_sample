class Question {
  Question({
    required this.id,
    required this.questionText,
  });

  final String id;
  final String questionText;

  Question copyWith({
    String? id,
    String? questionText,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'questionText': questionText,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      questionText: map['questionText'] as String,
    );
  }

  @override
  String toString() => 'Question(id: $id, questionText: $questionText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Question &&
      other.id == id &&
      other.questionText == questionText;
  }

  @override
  int get hashCode => id.hashCode ^ questionText.hashCode;
}
