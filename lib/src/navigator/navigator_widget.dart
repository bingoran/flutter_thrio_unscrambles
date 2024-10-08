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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extension/thrio_iterable.dart';
import '../extension/thrio_stateful_widget.dart';
import '../module/module_anchor.dart';
import '../module/module_types.dart';
import '../module/thrio_module.dart';
import 'navigator_logger.dart';
import 'navigator_observer_manager.dart';
import 'navigator_page_route.dart';
import 'navigator_route.dart';
import 'navigator_route_settings.dart';
import 'navigator_types.dart';
import 'thrio_navigator_implement.dart';

/// A widget that manages a set of child widgets with a stack discipline.
/// 一个以栈结构管理一组子小部件的小部件
/// 导航器组件
///
class NavigatorWidget extends StatefulWidget {
  const NavigatorWidget({
    super.key,
    required this.moduleContext,
    required NavigatorObserverManager observerManager,
    required this.child,
  }) : _observerManager = observerManager;
  
  // 通过 child.widget 获取导航器里的page wiget,
  final Navigator child;

  // module context
  final ModuleContext moduleContext;
 
  // 导航观察器
  final NavigatorObserverManager _observerManager;

  @override
  State<StatefulWidget> createState() => NavigatorWidgetState();
}

class NavigatorWidgetState extends State<NavigatorWidget> {
  // 初始化一个全部使用默认值的系统UI对象
  final _style = const SystemUiOverlayStyle();
  
  /// 当前整个APP的路由堆栈
  List<Route<dynamic>> get history => widget._observerManager.pageRoutes;

  /// 还无法实现animated=false
  Future<bool> push(
    RouteSettings settings, {
    bool animated = true,
  }) async {
    // 拿到导航器
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return false;
    }
    
    // 根据url获取即将要展示的页面
    final pageBuilder =
        ThrioModule.get<NavigatorPageBuilder>(url: settings.url);
    // 如果没找到页面，则返回false，把处理交还给native
    if (pageBuilder == null) {
      return false;
    }

    // 加载模块
    // await anchor.loading(settings.url);

    NavigatorRoute route;
    // 根据url，在注册的moudle中获取是否有实现了提供NavigatorRouteBuilder的moduel
    final routeBuilder =
        ThrioModule.get<NavigatorRouteBuilder>(url: settings.url);
    if (routeBuilder == null) {
      // 如果没有，构建一个pageRouter，NavigatorPageRoute继承自NavigatorRoute
      route = NavigatorPageRoute(pageBuilder: pageBuilder, settings: settings);
    } else {
      // 如果有，直接执行moudel重新的
      route = routeBuilder(pageBuilder, settings);
    }
    
    // 执行页面即将展示操作
    ThrioNavigatorImplement.shared()
        .pageChannel
        .willAppear(route.settings, NavigatorRouteType.push);

    verbose(
      'push: url->${route.settings.url} '
      'index->${route.settings.index} '
      'params->${route.settings.params}',
    );

    // 设置系统界面的样式：设置一个空值，避免页面打开后不生效
    SystemChrome.setSystemUIOverlayStyle(_style);
    
    /// 导航push一个flutter页面
    // ignore: unawaited_futures
    navigatorState.push(route);
    // 设置页面为已push类型
    route.settings.isPushed = true;

    return true;
  }

  Future<bool> canPop(
    RouteSettings settings, {
    bool inRoot = false,
  }) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return false;
    }
    // 在原生端处于容器的根部，且当前 Flutter 页面栈上不超过 3，则不能再 pop
    if (inRoot && history.whereType<NavigatorRoute>().length < 3) {
      return false;
    }
    return true;
  }

  Future<int> maybePop(
    RouteSettings settings, {
    bool animated = true,
    bool inRoot = false,
  }) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return 0;
    }
    // 关闭非体系内的顶部 route，同时 return false，避免原生端清栈
    if (history.last is! NavigatorRoute) {
      final result = await navigatorState.maybePop(settings.params);
      // 返回 -1 表示关闭非体系内的顶部 route
      return result ? -1 : 0;
    }
    if (settings.name != history.last.settings.name) {
      return 0;
    }
    // 在原生端处于容器的根部，且当前 Flutter 页面栈上不超过 2，则不能再 pop
    if (inRoot && history.whereType<NavigatorRoute>().length < 2) {
      return 0;
    }
    final notPop = await history.last.willPop() == RoutePopDisposition.doNotPop;
    return notPop ? 0 : 1;
  }

  Future<bool> pop(
    RouteSettings settings, {
    bool animated = true,
    bool inRoot = false,
  }) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null || history.isEmpty) {
      return false;
    }

    // 关闭非体系内的顶部 route，同时 return false，避免原生端清栈
    if (history.last is! NavigatorRoute) {
      navigatorState.pop(settings.params);
      return false;
    }

    if (settings.name != history.last.settings.name) {
      final poppedResults = ThrioNavigatorImplement.shared().poppedResults;
      if (poppedResults.containsKey(settings.name)) {
        // 不匹配的时候表示这里是非当前引擎触发的，调用 poppedResult 回调
        final poppedResult = poppedResults.remove(settings.name);
        _poppedResultCallback(poppedResult, settings.url, settings.params);
      }
      // 在原生端不处于容器的根部，或者当前 Flutter 页面栈上超过 2，则 pop
      // 解决目前单引擎下偶现的无法 pop 的问题
      if (!inRoot && history.whereType<NavigatorRoute>().length > 2) {
        navigatorState.pop();
      }

      // return false，避免原生端清栈，如果仅仅是为了触发 poppedResult 回调原生端也不会清栈
      return false;
    }
    // 在原生端处于容器的根部，且当前 Flutter 页面栈上不超过 3，则不能再 pop
    if (inRoot && history.whereType<NavigatorRoute>().length < 3) {
      return false;
    }

    verbose(
      'pop: url->${history.last.settings.url} '
      'index->${history.last.settings.index}',
    );

    // ignore: avoid_as
    final route = history.last as NavigatorRoute;

    ThrioNavigatorImplement.shared()
        .pageChannel
        .willDisappear(route.settings, NavigatorRouteType.pop);

    route.routeType = NavigatorRouteType.pop;
    if (animated) {
      navigatorState.pop();
    } else {
      navigatorState.removeRoute(route);
    }

    return Future.value(true).then((value) {
      _poppedResultCallback(
        route.poppedResult,
        route.settings.url,
        settings.params,
      );
      // 执行完清空poppedResult保存的回调函数
      route.poppedResult = null;
      return value;
    });
  }

  Future<bool> popTo(
    RouteSettings settings, {
    bool animated = true,
  }) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return false;
    }

    var index = history.indexWhere((it) => it.settings.name == settings.name);
    if (index == -1) {
      index = history.indexWhere((it) => it.settings.url == settings.url);
      if (index == -1) {
        return false;
      }
    }
    // 已经是最顶部的页面了，直接返回 true
    if (index == history.length - 1) {
      return true;
    }

    final route = history[index];

    verbose(
      'popTo: url->${route.settings.url} '
      'index->${route.settings.index}',
    );

    ThrioNavigatorImplement.shared().pageChannel.willAppear(
          route.settings,
          NavigatorRouteType.popTo,
        );

    // ignore: avoid_as
    (route as NavigatorRoute).routeType = NavigatorRouteType.popTo;
    if (history.last != route) {
      for (var i = history.length - 2; i > index; i--) {
        if (history[i].settings.name == route.settings.name) {
          break;
        }
        navigatorState.removeRoute(history[i]);
      }
      if (animated) {
        navigatorState.pop();
      } else {
        navigatorState.removeRoute(history.last);
      }
    }
    return true;
  }

  Future<bool> remove(
    RouteSettings settings, {
    bool animated = false,
    bool inRoot = false,
  }) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return false;
    }
    final route =
        history.firstWhereOrNull((it) => it.settings.name == settings.name);
    if (route == null) {
      return false;
    }
    // 在原生端处于容器的根部，且当前 Flutter 页面栈上不超过 3，则不能再 pop
    if (inRoot && history.whereType<NavigatorRoute>().length < 3) {
      return false;
    }

    verbose(
      'remove: url->${route.settings.url} '
      'index->${route.settings.index}',
    );

    // ignore: avoid_as
    (route as NavigatorRoute).routeType = NavigatorRouteType.remove;

    if (settings.name == history.last.settings.name) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        ThrioNavigatorImplement.shared()
            .pageChannel
            .willDisappear(route.settings, NavigatorRouteType.remove);
      }
      navigatorState.pop();
      return true;
    }

    navigatorState.removeRoute(route);
    return true;
  }

  Future<bool> replace(
    RouteSettings settings,
    RouteSettings newSettings,
  ) async {
    final navigatorState = widget.child.tryStateOf<NavigatorState>();
    if (navigatorState == null) {
      return false;
    }
    final route =
        history.lastWhereOrNull((it) => it.settings.name == settings.name);
    if (route == null) {
      return false;
    }
    final pageBuilder =
        ThrioModule.get<NavigatorPageBuilder>(url: newSettings.url);
    if (pageBuilder == null) {
      return false;
    }

    // 加载模块
    // await anchor.loading(newSettings.url);

    NavigatorRoute newRoute;
    final routeBuilder =
        ThrioModule.get<NavigatorRouteBuilder>(url: newSettings.url);
    if (routeBuilder == null) {
      newRoute =
          NavigatorPageRoute(pageBuilder: pageBuilder, settings: newSettings);
    } else {
      newRoute = routeBuilder(pageBuilder, newSettings);
    }

    verbose(
      'replace: url->${route.settings.url} index->${route.settings.index}\n'
      'nweUrl->${newSettings.url} newIndex->${newSettings.index}',
    );

    // ignore: avoid_as
    (route as NavigatorRoute).routeType = NavigatorRouteType.replace;

    if (settings.name == history.last.settings.name) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        ThrioNavigatorImplement.shared()
            .pageChannel
            .willDisappear(route.settings, NavigatorRouteType.replace);
        ThrioNavigatorImplement.shared()
            .pageChannel
            .willAppear(newRoute.settings, NavigatorRouteType.replace);
      }
      navigatorState.replace(oldRoute: route, newRoute: newRoute);
    } else {
      final anchorRoute = history[history.indexOf(route) + 1];
      navigatorState.replaceRouteBelow(
          anchorRoute: anchorRoute, newRoute: newRoute);
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      // 执行ready, 至此，flutter 侧已经初始化完毕，本地做一些出来，也会通知native侧初始化完成
      ThrioNavigatorImplement.shared().ready();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _poppedResultCallback(
    NavigatorParamsCallback? poppedResultCallback,
    String? url,
    dynamic params,
  ) {
    if (poppedResultCallback == null) {
      return;
    }
    if (url?.isEmpty ?? true && params == null) {
      poppedResultCallback(null);
    } else {
      if (params is Map) {
        if (params.containsKey('__thrio_Params_HashCode__')) {
          // ignore: avoid_as
          final paramsObjs = anchor
              .removeParam<dynamic>(params['__thrio_Params_HashCode__'] as int);
          poppedResultCallback(paramsObjs);
          return;
        }
        if (params.containsKey('__thrio_TParams__')) {
          // ignore: avoid_as
          final typeString = params['__thrio_TParams__'] as String;
          final paramsObjs =
              ThrioModule.get<JsonDeserializer<dynamic>>(key: typeString)
                  ?.call(params.cast<String, dynamic>());
          poppedResultCallback(paramsObjs);
          return;
        }
      }
      poppedResultCallback(params);
    }
  }
}
