// The MIT License (MIT)
//
// Copyright (c) 2019 Hellobike Group
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'package:flutter/widgets.dart';

import '../channel/thrio_channel.dart';
import '../module/thrio_module.dart';
import 'navigator_logger.dart';
import 'navigator_route_observer.dart';
import 'navigator_route_settings.dart';
import 'thrio_navigator_implement.dart';

/// 路由行为的回调
typedef NavigatorRouteObserverCallback = void Function(
  NavigatorRouteObserver observer,
  RouteSettings settings,
);

/// 路由观察的channel类
class NavigatorRouteObserverChannel with NavigatorRouteObserver {
  NavigatorRouteObserverChannel(String entrypoint)
      // channel 初始化，导航行为的channel名为__thrio_route_channel__
      : _channel = ThrioChannel(channel: '__thrio_route_channel__$entrypoint') {
    _on('didPush',
        (observer, routeSettings) => observer.didPush(routeSettings));
    _on('didPop', (observer, routeSettings) => observer.didPop(routeSettings));
    _on('didPopTo',
        (observer, routeSettings) => observer.didPopTo(routeSettings));
    _on('didRemove',
        (observer, routeSettings) => observer.didRemove(routeSettings));
    _onDidReplace();
  }

  final ThrioChannel _channel;

  @override
  void didPush(RouteSettings routeSettings) => _channel.invokeMethod<bool>(
      'didPush', routeSettings.toArgumentsWithoutParams());

  @override
  void didPop(RouteSettings routeSettings) {
    verbose('didPop: ${routeSettings.name}');
    _channel.invokeMethod<bool>(
        'didPop', routeSettings.toArgumentsWithoutParams());
  }

  @override
  void didPopTo(RouteSettings routeSettings) => _channel.invokeMethod<bool>(
      'didPopTo', routeSettings.toArgumentsWithoutParams());

  @override
  void didRemove(RouteSettings routeSettings) => _channel.invokeMethod<bool>(
      'didRemove', routeSettings.toArgumentsWithoutParams());

  @override
  void didReplace(
    RouteSettings newRouteSettings,
    RouteSettings oldRouteSettings,
  ) {
    final oldArgs = oldRouteSettings.toArgumentsWithoutParams();
    final newArgs = newRouteSettings.toArgumentsWithoutParams();
    _channel.invokeMethod<bool>('didReplace', {
      'oldRouteSettings': oldArgs,
      'newRouteSettings': newArgs,
    });
  }

  void _on(
    String method,
    NavigatorRouteObserverCallback callback,
  ) =>
      _channel.registryMethodCall(method, ([final arguments]) {
        final routeSettings = NavigatorRouteSettings.fromArguments(arguments);
        if (routeSettings != null) {
          final observers =
              ThrioModule.gets<NavigatorRouteObserver>(url: routeSettings.url);
          for (final observer in observers) {
            callback(observer, routeSettings);
          }
          if (method == 'didPop') {
            final currentPopRoutes =
                ThrioNavigatorImplement.shared().currentPopRoutes;
            if (currentPopRoutes.isNotEmpty &&
                currentPopRoutes.last.settings.name == routeSettings.name) {
              currentPopRoutes.first.poppedResult?.call(null);
            }
            ThrioNavigatorImplement.shared().currentPopRoutes.clear();
          }
        }
        return Future.value();
      });

  void _onDidReplace() =>
      _channel.registryMethodCall('didReplace', ([final arguments]) {
        final newRouteSettings = NavigatorRouteSettings.fromArguments(
            (arguments?['newRouteSettings'] as Map<Object?, Object?>)
                .cast<String, dynamic>());
        final oldRouteSettings = NavigatorRouteSettings.fromArguments(
            (arguments?['oldRouteSettings'] as Map<Object?, Object?>)
                .cast<String, dynamic>());
        if (newRouteSettings != null && oldRouteSettings != null) {
          final observers = <NavigatorRouteObserver>[
            ...ThrioModule.gets<NavigatorRouteObserver>(
                url: newRouteSettings.url),
            ...ThrioModule.gets<NavigatorRouteObserver>(
                url: oldRouteSettings.url),
          ];
          for (final observer in observers) {
            observer.didReplace(newRouteSettings, oldRouteSettings);
          }
        }
        return Future.value();
      });
}
