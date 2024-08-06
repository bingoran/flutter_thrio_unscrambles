// Copyright (c) 2024 foxsofter.
//
// Do not edit this file.
//

import 'package:flutter_thrio/flutter_thrio.dart';

class Flutter9Route extends NavigatorRouteLeaf {
  factory Flutter9Route(final NavigatorRouteNode parent) =>
      _instance ??= Flutter9Route._(parent);

  Flutter9Route._(super.parent);

  static Flutter9Route? _instance;

  @override
  String get name => 'flutter9';

  Future<TPopParams?> push<TParams, TPopParams>({
    final TParams? params,
    final bool animated = true,
    final NavigatorIntCallback? result,
    final String? fromURL,
    final String? innerURL,
  }) =>
      ThrioNavigator.push<TParams, TPopParams>(
        url: url,
        params: params,
        animated: animated,
        result: result,
        fromURL: fromURL,
        innerURL: innerURL,
      );

  Future<TPopParams?> pushSingle<TParams, TPopParams>({
    final TParams? params,
    final bool animated = true,
    final NavigatorIntCallback? result,
    final String? fromURL,
    final String? innerURL,
  }) =>
      ThrioNavigator.pushSingle<TParams, TPopParams>(
        url: url,
        params: params,
        animated: animated,
        result: result,
        fromURL: fromURL,
        innerURL: innerURL,
      );
}