import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:questions_sample/bloc/questions_state.dart';
import 'package:questions_sample/repositories/questions_repository.dart';

import '../models/models.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  QuestionsCubit({required QuestionsRepository questionsRepository})
      : _questionsRepository = questionsRepository,
        super(QuestionsLoaded(questions: []));

  final QuestionsRepository _questionsRepository;

  Future<void> fetchQuestions() async {
    emit(QuestionsLoading());
    try {
      final questions = await _questionsRepository.fetchQuestions();
      emit(QuestionsLoaded(questions: questions));
    } catch (e) {
      emit(QuestionsError(message: '$e'));
    }
  }

  void answerQuestion(Answer answer, {int? index}) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      if (index == null || index >= currentState.answers.length) {
        emit(
          currentState.copyWith(
            answers: [...currentState.answers, answer],
          ),
        );
      } else {
        emit(
          currentState.copyWith(
            answers: [
              ...currentState.answers.sublist(0, index),
              answer,
              ...currentState.answers.sublist(
                (index + 1).clamp(0, currentState.answers.length - 1),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  String toString() =>
      'QuestionsCubit(_questionsRepository: $_questionsRepository)';
}
