import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notes/presentation/pages/notes_list_page.dart';
import '../../features/notes/presentation/pages/note_edit_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'notes',
        builder: (context, state) => const NotesListPage(),
      ),
      GoRoute(
        path: '/note/new',
        name: 'new-note',
        builder: (context, state) => const NoteEditPage(),
      ),
      GoRoute(
        path: '/note/:id',
        name: 'edit-note',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return NoteEditPage(noteId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}