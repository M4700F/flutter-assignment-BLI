// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseServiceHash() => r'766f41a8fb8947216fae68bbc31fa62d037f6899';

/// See also [databaseService].
@ProviderFor(databaseService)
final databaseServiceProvider = AutoDisposeProvider<DatabaseService>.internal(
  databaseService,
  name: r'databaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseServiceRef = AutoDisposeProviderRef<DatabaseService>;
String _$aiServiceHash() => r'2548d21e34c5f0b508401a9be74dc821d16bff8a';

/// See also [aiService].
@ProviderFor(aiService)
final aiServiceProvider = AutoDisposeProvider<AIService>.internal(
  aiService,
  name: r'aiServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AiServiceRef = AutoDisposeProviderRef<AIService>;
String _$chatRepositoryHash() => r'a47d0fcb32da4dedde25d7f8dde41add704463a7';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$currentSessionHash() => r'78dbefabc5c1bbcc809bdae31b8222b1d7339841';

/// See also [CurrentSession].
@ProviderFor(CurrentSession)
final currentSessionProvider =
    AutoDisposeNotifierProvider<CurrentSession, ChatSession?>.internal(
  CurrentSession.new,
  name: r'currentSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSession = AutoDisposeNotifier<ChatSession?>;
String _$messagesHash() => r'2ce15daa92bb28f208a00bef1c3c6977af9d5b1f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Messages
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final String sessionId;

  FutureOr<List<Message>> build(
    String sessionId,
  );
}

/// See also [Messages].
@ProviderFor(Messages)
const messagesProvider = MessagesFamily();

/// See also [Messages].
class MessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [Messages].
  const MessagesFamily();

  /// See also [Messages].
  MessagesProvider call(
    String sessionId,
  ) {
    return MessagesProvider(
      sessionId,
    );
  }

  @override
  MessagesProvider getProviderOverride(
    covariant MessagesProvider provider,
  ) {
    return call(
      provider.sessionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messagesProvider';
}

/// See also [Messages].
class MessagesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Messages, List<Message>> {
  /// See also [Messages].
  MessagesProvider(
    String sessionId,
  ) : this._internal(
          () => Messages()..sessionId = sessionId,
          from: messagesProvider,
          name: r'messagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesHash,
          dependencies: MessagesFamily._dependencies,
          allTransitiveDependencies: MessagesFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  MessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  FutureOr<List<Message>> runNotifierBuild(
    covariant Messages notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(Messages Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessagesProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Messages, List<Message>>
      createElement() {
    return _MessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessagesRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _MessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Messages, List<Message>>
    with MessagesRef {
  _MessagesProviderElement(super.provider);

  @override
  String get sessionId => (origin as MessagesProvider).sessionId;
}

String _$chatSessionsHash() => r'd01e6f5734488c279fd24716122da78985f797f1';

/// See also [ChatSessions].
@ProviderFor(ChatSessions)
final chatSessionsProvider =
    AutoDisposeAsyncNotifierProvider<ChatSessions, List<ChatSession>>.internal(
  ChatSessions.new,
  name: r'chatSessionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatSessions = AutoDisposeAsyncNotifier<List<ChatSession>>;
String _$isTypingHash() => r'552284bd435f3665f17fe2a9bf4aa180434418b6';

/// See also [IsTyping].
@ProviderFor(IsTyping)
final isTypingProvider = AutoDisposeNotifierProvider<IsTyping, bool>.internal(
  IsTyping.new,
  name: r'isTypingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isTypingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsTyping = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
