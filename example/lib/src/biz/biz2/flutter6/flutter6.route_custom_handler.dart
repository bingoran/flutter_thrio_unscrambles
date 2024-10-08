// Copyright (c) 2022 foxsofter.
//

import 'package:flutter_thrio/flutter_thrio.dart';

import '../../route.dart';

Future<void> on$RouteCustomHandlerRegister(
  final ModuleContext moduleContext,
  final void Function(String, NavigatorRouteCustomHandler) registerFunc,
) async {
  registerFunc(
      'https://*',
      <TParams, TPopParams>(
        url,
        queryParams, {
        params,
        animated = true,
        result,
        fromURL,
        innerURL,
      }) =>
          'good' as TPopParams);
          
  registerFunc(
      'justascheme://open/biz2/home{tab?}',
      <TParams, TPopParams>(
        url,
        queryParams, {
        params,
        animated = true,
        result,
        fromURL,
        innerURL,
      }) =>
          ThrioNavigator.push<TParams, TPopParams>(
            url: biz.biz1.flutter3.url,
            params: params,
            animated: animated,
            result: result,
            fromURL: fromURL,
            innerURL: innerURL,
          ));

  registerFunc('justascheme://open/biz2/home', <TParams, TPopParams>(
    url,
    queryParams, {
    params,
    animated = true,
    result,
    fromURL,
    innerURL,
  }) {
    result?.call(-1); // 不拦截
    return null;
  });

  registerFunc(
      'anotherScheme://leaderboard/home{hashId?,product}',
      <TParams, TPopParams>(
        url,
        queryParams, {
        params,
        animated = true,
        result,
        fromURL,
        innerURL,
      }) =>
          ThrioNavigator.push<TParams, TPopParams>(
            url: biz.biz1.flutter3.url,
            params: params,
            animated: animated,
            result: result,
            fromURL: fromURL,
            innerURL: innerURL,
          ));
}
