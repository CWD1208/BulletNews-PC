import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockc/data/models/ai_question_model.dart';
import 'package:stockc/data/repositories/ai_question_repository.dart';

part 'ai_question_provider.g.dart';

/// AI 问题 Repository Provider
@riverpod
AiQuestionRepository aiQuestionRepository(AiQuestionRepositoryRef ref) {
  return AiQuestionRepository();
}

/// 是否已回答过问题的状态
@riverpod
class AiQuestionsCompleted extends _$AiQuestionsCompleted {
  @override
  bool build() {
    final repository = ref.watch(aiQuestionRepositoryProvider);
    return repository.hasCompletedQuestions();
  }

  /// 标记问题已回答
  Future<void> markCompleted() async {
    final repository = ref.read(aiQuestionRepositoryProvider);
    await repository.markQuestionsCompleted();
    state = true;
  }

  /// 重置问题状态
  Future<void> reset() async {
    final repository = ref.read(aiQuestionRepositoryProvider);
    await repository.resetQuestions();
    state = false;
  }
}

/// 所有问题数据 Provider
@riverpod
List<QuestionModel> aiQuestions(AiQuestionsRef ref) {
  final repository = ref.watch(aiQuestionRepositoryProvider);
  return repository.getAllQuestions();
}

/// 问题流程状态管理
@riverpod
class AiQuestionFlow extends _$AiQuestionFlow {
  @override
  AiQuestionFlowState build() {
    final questions = ref.watch(aiQuestionsProvider);
    return AiQuestionFlowState(
      currentIndex: 0,
      totalQuestions: questions.length,
      answers: {},
    );
  }

  /// 选择选项
  void selectOption(String questionId, String optionId) {
    final currentQuestion = _getCurrentQuestion();
    if (currentQuestion == null) return;

    if (currentQuestion.isMultipleChoice) {
      // 多选：切换选中状态
      final currentAnswers = Set<String>.from(
        state.answers[questionId] ?? [],
      );
      if (currentAnswers.contains(optionId)) {
        currentAnswers.remove(optionId);
      } else {
        currentAnswers.add(optionId);
      }
      state = state.copyWith(
        answers: {
          ...state.answers,
          questionId: currentAnswers.toList(),
        },
      );
    } else {
      // 单选：直接替换
      state = state.copyWith(
        answers: {
          ...state.answers,
          questionId: [optionId],
        },
      );
    }
  }

  /// 检查当前问题是否已选择
  bool isOptionSelected(String questionId, String optionId) {
    final answers = state.answers[questionId] ?? [];
    return answers.contains(optionId);
  }

  /// 检查当前问题是否可以进入下一步
  bool canProceed() {
    final currentQuestion = _getCurrentQuestion();
    if (currentQuestion == null) return false;

    final answers = state.answers[currentQuestion.id] ?? [];
    return answers.isNotEmpty;
  }

  /// 进入下一步
  void next() {
    if (state.currentIndex < state.totalQuestions - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  /// 返回上一步
  void previous() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  /// 获取当前问题
  QuestionModel? _getCurrentQuestion() {
    final questions = ref.read(aiQuestionsProvider);
    if (state.currentIndex >= 0 && state.currentIndex < questions.length) {
      return questions[state.currentIndex];
    }
    return null;
  }

  /// 获取当前问题（公开方法）
  QuestionModel? getCurrentQuestion() => _getCurrentQuestion();

  /// 是否在最后一步
  bool get isLastStep => state.currentIndex == state.totalQuestions - 1;
}

/// 问题流程状态
class AiQuestionFlowState {
  final int currentIndex;
  final int totalQuestions;
  final Map<String, List<String>> answers; // questionId -> [optionIds]

  const AiQuestionFlowState({
    required this.currentIndex,
    required this.totalQuestions,
    required this.answers,
  });

  AiQuestionFlowState copyWith({
    int? currentIndex,
    int? totalQuestions,
    Map<String, List<String>>? answers,
  }) {
    return AiQuestionFlowState(
      currentIndex: currentIndex ?? this.currentIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answers: answers ?? this.answers,
    );
  }
}

