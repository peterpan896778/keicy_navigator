library keicy_navigator;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeicyNavigator {
  static Future push(BuildContext context, String routeName, Widget page) async {
    return await Navigator.of(context).push(KeicyRoute(routeName, page));
  }

  static Future pushReplacement(BuildContext context, String routeName, Widget page) async {
    return await Navigator.of(context).pushReplacement(KeicyRoute(routeName, page));
  }
}

class KeicyNavigatorObserver extends NavigatorObserver {
  static SharedPreferences _prefs;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {}

  @override
  void didPop(Route route, Route previousRoute) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs.setInt("Route Name: ${previousRoute.settings.name}", DateTime.now().millisecondsSinceEpoch);

    super.didPop(route, previousRoute);
  }
}

enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

class KeicyRoute extends PageRouteBuilder {
  Widget page;
  String routeName;
  Object arguments;
  PageTransitionType transitionType;
  Duration transitionDuration;
  bool opaque;
  Curve curve;

  KeicyRoute(
    this.routeName,
    this.page, {
    this.arguments,
    this.transitionType = PageTransitionType.fade,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.curve = Curves.ease,
  }) : super(
          settings: RouteSettings(
            name: routeName,
            arguments: {"isCheckCookie": false},
          ),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: transitionDuration,
          opaque: opaque,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
            switch (transitionType) {
              case PageTransitionType.fade:
                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
                break;
              default:
                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
                break;
            }
          },
        );
}
