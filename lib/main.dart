import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_sample/bloc/bloc.dart';
import 'package:questions_sample/repositories/questions_repository.dart';
import 'package:questions_sample/views/screens/home_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => QuestionsRepository(),
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionsCubit(
        questionsRepository: context.read<QuestionsRepository>(),
      )..fetchQuestions(),
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
