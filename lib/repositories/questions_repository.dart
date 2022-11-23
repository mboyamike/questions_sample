import '../models/models.dart';

class QuestionsRepository {
  Future<List<Question>> fetchQuestions() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      Question(id: '01', questionText: 'What is your name?'),
      Question(id: '02', questionText: 'What is your gender?'),
      Question(id: '03', questionText: "What is Ichigo's first name?"),
      Question(id: '04', questionText: 'What is your favorite anime?'),
      Question(id: '05', questionText: 'What is your favorite game?'),
      Question(id: '06', questionText: 'What is your favorite framework?'),
      Question(id: '07', questionText: 'What is your nickname?'),
      Question(id: '08', questionText: 'When were you born?'),
    ];
  }
}
