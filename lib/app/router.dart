import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/home/home_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/projects/new_project_screen.dart';
import '../presentation/projects/project_screen.dart';
import '../presentation/projects/edit_project_screen.dart';
import '../presentation/stock/stock_editor_screen.dart';
import '../presentation/stock/buy_stock_screen.dart';
import '../presentation/parts/part_editor_screen.dart';
import '../presentation/results/result_screen.dart';
import '../presentation/projects/cut_settings_screen.dart';
import '../presentation/billing/pro_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/pro', builder: (context, state) => const ProScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'projects/new',
            builder: (context, state) => const NewProjectScreen(),
          ),
          GoRoute(
            path: 'projects/:projectId',
            builder: (context, state) =>
                ProjectScreen(projectId: state.pathParameters['projectId']!),
            routes: [
              GoRoute(
                path: 'cut-settings',
                builder: (context, state) => CutSettingsScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
              GoRoute(
                path: 'result',
                builder: (context, state) =>
                    ResultScreen(projectId: state.pathParameters['projectId']!),
              ),
              GoRoute(
                path: 'parts/new',
                builder: (context, state) => PartEditorScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
              GoRoute(
                path: 'parts/:partId/edit',
                builder: (context, state) => PartEditorScreen(
                  projectId: state.pathParameters['projectId']!,
                  partId: state.pathParameters['partId']!,
                ),
              ),
              GoRoute(
                path: 'stock/new',
                builder: (context, state) => StockEditorScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
              GoRoute(
                path: 'stock/buy',
                builder: (context, state) => BuyStockScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
              GoRoute(
                path: 'stock/:stockId/edit',
                builder: (context, state) => StockEditorScreen(
                  projectId: state.pathParameters['projectId']!,
                  stockId: state.pathParameters['stockId']!,
                ),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => EditProjectScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
