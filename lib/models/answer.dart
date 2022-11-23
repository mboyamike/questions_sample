class Answer {
  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
  });

  final String id;
  final String questionId;
  final String answerText;

  Answer copyWith({
    String? id,
    String? questionId,
    String? answerText,
  }) {
    return Answer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answerText: answerText ?? this.answerText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'questionId': questionId,
      'answerText': answerText,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'] as String,
      questionId: map['questionId'] as String,
      answerText: map['answerText'] as String,
    );
  }

  @override
  String toString() =>
      'Answer(id: $id, questionId: $questionId, answerText: $answerText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Answer &&
        other.id == id &&
        other.questionId == questionId &&
        other.answerText == answerText;
  }

  @override
  int get hashCode => id.hashCode ^ questionId.hashCode ^ answerText.hashCode;
}
