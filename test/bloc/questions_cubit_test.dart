import 'package:bloc_test/bloc_test.dart';
import 'package:questions_sample/bloc/questions_cubit.dart';
import 'package:questions_sample/bloc/questions_state.dart';
import 'package:questions_sample/models/answer.dart';
import 'package:questions_sample/models/question.dart';
import 'package:questions_sample/repositories/questions_repository.dart';

class MockQuestionsRepository implements QuestionsRepository {
  @override
  Future<List<Question>> fetchQuestions() async {
    return <Question>[
      Question(id: '01', questionText: 'q1'),
      Question(id: '02', questionText: 'q2'),
      Question(id: '03', questionText: 'q3'),
    ];
  }
}

void main() {
  final questionsRepository = MockQuestionsRepository();
  final questions = [
    Question(id: '01', questionText: 'q1'),
    Question(id: '02', questionText: 'q2'),
    Question(id: '03', questionText: 'q3'),
  ];
  final answer1 = Answer(id: '01', questionId: '01', answerText: 'A1');
  final answer2 = Answer(id: '02', questionId: '02', answerText: 'A2');
  final answer3 = Answer(id: '03', questionId: '01', answerText: 'A1');
  blocTest<QuestionsCubit, QuestionsState>(
    'Appends an answer at the end if no index is passed',
    seed: () => QuestionsLoaded(
      questions: questions,
    ),
    build: () => QuestionsCubit(questionsRepository: questionsRepository),
    act: (bloc) => bloc.answerQuestion(answer1),
    expect: () => [
      QuestionsLoaded(questions: questions, answers: [answer1]),
    ],
  );

  blocTest<QuestionsCubit, QuestionsState>(
    'Appends an answer at the end if an index greater than length of answers'
    'array is passed',
    seed: () => QuestionsLoaded(
      questions: questions,
      answers: [answer1, answer2],
    ),
    build: () => QuestionsCubit(questionsRepository: questionsRepository),
    act: (bloc) => bloc.answerQuestion(answer3, index: 10),
    expect: () => [
      QuestionsLoaded(
        questions: questions,
        answers: [answer1, answer2, answer3],
      ),
    ],
  );

  blocTest<QuestionsCubit, QuestionsState>(
    'Replaces the answer at the start of the answers array if index 0 is passed',
    seed: () => QuestionsLoaded(
      questions: questions,
      answers: [answer2, answer3],
    ),
    build: () => QuestionsCubit(questionsRepository: questionsRepository),
    act: (bloc) => bloc.answerQuestion(answer1, index: 0),
    expect: () => [
      QuestionsLoaded(
        questions: questions,
        answers: [answer1, answer3],
      ),
    ],
  );

  blocTest<QuestionsCubit, QuestionsState>(
    'Replaces the answer at the specified index of the answers array if index '
    'is passed',
    seed: () => QuestionsLoaded(
      questions: questions,
      answers: [answer1, answer2, answer3],
    ),
    build: () => QuestionsCubit(questionsRepository: questionsRepository),
    act: (bloc) => bloc.answerQuestion(answer1, index: 1),
    expect: () => [
      QuestionsLoaded(
        questions: questions,
        answers: [answer1, answer1, answer3],
      ),
    ],
  );
}
