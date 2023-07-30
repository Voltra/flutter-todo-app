part of "routes_import.dart";

@AutoRouterConfig(replaceInRouteName: "Route,Screen,Page")
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<CustomRoute> routes = [
    CustomRoute(page: ListPageRoute.page, path: "/")
  ];
}