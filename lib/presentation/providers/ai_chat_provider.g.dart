// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiChatHash() => r'49da8f5d51007d10fc9f89170380778d0493aa2d';

/// AI 聊天状态管理
///
/// Copied from [AiChat].
@ProviderFor(AiChat)
final aiChatProvider =
    AutoDisposeNotifierProvider<AiChat, List<ChatMessage>>.internal(
      AiChat.new,
      name: r'aiChatProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$aiChatHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiChat = AutoDisposeNotifier<List<ChatMessage>>;
String _$chatSendButtonStateNotifierHash() =>
    r'e89cf6d1b12e2c7f12bbf6eebffed17eb46800a8';

/// 发送按钮状态管理
///
/// Copied from [ChatSendButtonStateNotifier].
@ProviderFor(ChatSendButtonStateNotifier)
final chatSendButtonStateNotifierProvider = AutoDisposeNotifierProvider<
  ChatSendButtonStateNotifier,
  ChatSendButtonState
>.internal(
  ChatSendButtonStateNotifier.new,
  name: r'chatSendButtonStateNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatSendButtonStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatSendButtonStateNotifier =
    AutoDisposeNotifier<ChatSendButtonState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
