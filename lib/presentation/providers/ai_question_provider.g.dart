// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_question_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiQuestionRepositoryHash() =>
    r'250d6537cc40400f9db5f895ee3cbb533422e4b2';

/// AI 问题 Repository Provider
///
/// Copied from [aiQuestionRepository].
@ProviderFor(aiQuestionRepository)
final aiQuestionRepositoryProvider =
    AutoDisposeProvider<AiQuestionRepository>.internal(
      aiQuestionRepository,
      name: r'aiQuestionRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$aiQuestionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiQuestionRepositoryRef = AutoDisposeProviderRef<AiQuestionRepository>;
String _$aiQuestionsHash() => r'20f9d491c98572569148747d2b870fce10c08b0d';

/// 所有问题数据 Provider
///
/// Copied from [aiQuestions].
@ProviderFor(aiQuestions)
final aiQuestionsProvider = AutoDisposeProvider<List<QuestionModel>>.internal(
  aiQuestions,
  name: r'aiQuestionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiQuestionsRef = AutoDisposeProviderRef<List<QuestionModel>>;
String _$aiQuestionsCompletedHash() =>
    r'665c57baffd44b665a7c5f27145af848a8031dd4';

/// 是否已回答过问题的状态
///
/// Copied from [AiQuestionsCompleted].
@ProviderFor(AiQuestionsCompleted)
final aiQuestionsCompletedProvider =
    AutoDisposeNotifierProvider<AiQuestionsCompleted, bool>.internal(
      AiQuestionsCompleted.new,
      name: r'aiQuestionsCompletedProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$aiQuestionsCompletedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiQuestionsCompleted = AutoDisposeNotifier<bool>;
String _$aiQuestionFlowHash() => r'a30745c9af245368f9b4fc404d3e53f846be3402';

/// 问题流程状态管理
///
/// Copied from [AiQuestionFlow].
@ProviderFor(AiQuestionFlow)
final aiQuestionFlowProvider =
    AutoDisposeNotifierProvider<AiQuestionFlow, AiQuestionFlowState>.internal(
      AiQuestionFlow.new,
      name: r'aiQuestionFlowProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$aiQuestionFlowHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiQuestionFlow = AutoDisposeNotifier<AiQuestionFlowState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
