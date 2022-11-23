// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../models/models.dart';

abstract class QuestionsState {}

class QuestionsLoading extends QuestionsState {}

class QuestionsLoaded extends QuestionsState {
  QuestionsLoaded({
    required this.questions,
    this.answers = const [],
  });

  final List<Question> questions;
  final List<Answer> answers;

  QuestionsLoaded copyWith({
    List<Question>? questions,
    List<Answer>? answers,
  }) {
    return QuestionsLoaded(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionsLoaded &&
        listEquals(other.questions, questions) &&
        listEquals(other.answers, answers);
  }

  @override
  int get hashCode => questions.hashCode ^ answers.hashCode;

  @override
  String toString() =>
      'QuestionsLoaded(questions: $questions, answers: $answers)';
}

class QuestionsError extends QuestionsState {
  QuestionsError({
    required this.message,
  });

  final String message;

  @override
  String toString() => 'QuestionsError(message: $message)';
}
