import 'package:auto_route/auto_route.dart';
import 'package:instagram/feature/dasboard/presentation/dashboard_page.dart';
import 'package:instagram/feature/sign_in/presentation/sign_in_page.dart';
import 'package:instagram/feature/sign_up/presentation/component/sign_up_email_page.dart';
import 'package:instagram/feature/sign_up/presentation/sign_up_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignUpRoute.page, path: '/', initial: true),
    AutoRoute(page: SignInRoute.page, path: '/sign-in'),
    AutoRoute(page: SignUpEmailRoutes.page, path: '/sign-up-email'),
    AutoRoute(page: DashboardRoute.page, path: '/dashboard'),
  ];
}
