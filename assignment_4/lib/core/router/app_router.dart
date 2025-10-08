import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/story_detail_screen.dart';
import '../../presentation/screens/comments_screen.dart';
import '../../data/models/story_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/story/:id',
      builder: (context, state) {
        final story = state.extra as StoryModel;
        return StoryDetailScreen(story: story);
      },
    ),
    GoRoute(
      path: '/comments/:id',
      builder: (context, state) {
        final story = state.extra as StoryModel;
        return CommentsScreen(story: story);
      },
    ),
  ],
);