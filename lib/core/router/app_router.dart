import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tools_app/core/presentation/main_shell.dart';
import 'package:smart_tools_app/features/contacts/presentation/pages/contacts_screen.dart';
import 'package:smart_tools_app/features/guides/presentation/pages/guides_screen.dart';
import 'package:smart_tools_app/features/home/presentation/pages/home_screen.dart';
import 'package:smart_tools_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:smart_tools_app/features/smart_tools/presentation/pages/smart_tools_dashboard.dart';
import 'package:smart_tools_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:smart_tools_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:smart_tools_app/features/profile/data/repositories/profile_repository.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/guides/presentation/pages/guide_detail_screen.dart';
import 'package:smart_tools_app/features/guides/domain/entities/guide_entity.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contacts',
              builder: (context, state) => const ContactsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/guides',
              builder: (context, state) => const GuidesScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) {
                    final guide = state.extra as Guide;
                    return GuideDetailScreen(guide: guide);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final profile = state.extra as UserProfile?;
                    return BlocProvider(
                      create: (context) => ProfileCubit(ProfileRepository()),
                      child: EditProfileScreen(initialProfile: profile),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tools',
              builder: (context, state) => const SmartToolsDashboard(),
            ),
          ],
        ),
      ],
    ),
  ],
);
