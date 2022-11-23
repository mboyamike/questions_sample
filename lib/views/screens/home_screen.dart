import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_sample/bloc/bloc.dart';
import 'package:questions_sample/views/views.dart';

import '../../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: _Body(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Questions Sample'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<QuestionsCubit, QuestionsState>(
        builder: (context, state) {
          if (state is QuestionsError) {
            return DisplayErrorWidget(
              errorMessage: state.message,
              onRefreshPressed: () {
                context.read<QuestionsCubit>().fetchQuestions();
              },
              refreshText: 'Fetch Questions',
            );
          }

          if (state is QuestionsLoaded) {
            return QuestionsWidget(state: state);
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget({super.key, required this.state});

  final QuestionsLoaded state;

  @override
  State<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends State<QuestionsWidget> {
  int currentStep = 0;

  late final List<TextEditingController> textEditingControllers;

  Map<int, Question?> selectedQuestions = {
    0: null,
    1: null,
    2: null,
  };

  StepState _getStepState(int index) {
    final isCurrentStep = index == currentStep;
    if (isCurrentStep) {
      return StepState.editing;
    }

    final isAnswered = textEditingControllers[index].text.trim().isNotEmpty;
    if (isAnswered) {
      return StepState.complete;
    }

    final isPastStep = index < currentStep;
    if (isPastStep) {
      return StepState.error;
    } else {
      return StepState.indexed;
    }
  }

  @override
  void initState() {
    super.initState();
    final numberOfQuestions = widget.state.questions.length.clamp(0, 3);

    textEditingControllers = [
      for (int i = 0; i < numberOfQuestions; i++)
        TextEditingController()
          ..addListener(
            () => setState(() {}),
          ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (final controller in textEditingControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = widget.state.questions;
    final numberOfQuestions = allQuestions.length.clamp(0, 3);
    final shouldDisableContinue = selectedQuestions[currentStep] == null ||
        textEditingControllers[currentStep].text.trim().isEmpty;
    return Stepper(
      type: StepperType.horizontal,
      currentStep: currentStep,
      steps: [
        for (int index = 0; index < numberOfQuestions; index++)
          Step(
            title: Text('Q$index'),
            isActive: index <= currentStep,
            state: _getStepState(index),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final filteredQuestions = allQuestions.where(
                      (question) =>
                          !selectedQuestions.values.contains(question),
                    );
                    final availableQuestions = [
                      if (selectedQuestions[index] != null)
                        selectedQuestions[index]!,
                      for (final question in filteredQuestions) question
                    ];
                    return DropdownButton<Question?>(
                      items: [
                        for (final question in availableQuestions)
                          DropdownMenuItem(
                            value: question,
                            child: Text(question.questionText),
                          ),
                      ],
                      onChanged: (newQuestion) {
                        setState(() {
                          selectedQuestions[index] = newQuestion;
                        });
                      },
                      value: selectedQuestions[index],
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextField(controller: textEditingControllers[index]),
              ],
            ),
          ),
      ],
      onStepContinue: shouldDisableContinue
          ? null
          : () {
              if (currentStep < numberOfQuestions - 1) {
                setState(() {
                  currentStep++;
                });
              }
            },
      onStepCancel: currentStep <= 0
          ? null
          : () => setState(() {
                currentStep--;
              }),
      onStepTapped: (activeStep) {
        final currentAnswer = textEditingControllers[currentStep].text.trim();
        final currentQuestion = selectedQuestions[currentStep];
        if (currentQuestion != null && currentAnswer.isNotEmpty) {
          context.read<QuestionsCubit>().answerQuestion(
                Answer(
                  id: '$currentStep',
                  questionId: currentQuestion.id,
                  answerText: currentAnswer,
                ),
              );
        }
        setState(() {
          currentStep = activeStep;
        });
      },
    );
  }
}
