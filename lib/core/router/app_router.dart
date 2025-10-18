import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../features/marketplace/presentation/pages/dataset_detail_page.dart';
import '../../features/seller/presentation/pages/upload_dataset_page.dart';
import '../../features/seller/presentation/pages/my_datasets_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/dao/presentation/pages/dao_page.dart';
import '../../shared/presentation/widgets/main_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/marketplace',
            name: 'marketplace',
            builder: (context, state) => const MarketplacePage(),
            routes: [
              GoRoute(
                path: 'dataset/:id',
                name: 'dataset-detail',
                builder: (context, state) {
                  final datasetId = state.pathParameters['id']!;
                  return DatasetDetailPage(datasetId: datasetId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/my-data',
            name: 'my-data',
            builder: (context, state) => const MyDatasetsPage(),
            routes: [
              GoRoute(
                path: 'upload',
                name: 'upload-dataset',
                builder: (context, state) => const UploadDatasetPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/dao',
            name: 'dao',
            builder: (context, state) => const DaoPage(),
          ),
        ],
      ),
    ],
  );
});

class AppRoutes {
  static const String home = '/home';
  static const String marketplace = '/marketplace';
  static const String datasetDetail = '/marketplace/dataset';
  static const String myData = '/my-data';
  static const String uploadDataset = '/my-data/upload';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String dao = '/dao';
}
