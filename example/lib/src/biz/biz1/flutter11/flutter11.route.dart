// Copyright (c) 2024 foxsofter.
//
// Do not edit this file.
//

import 'package:flutter_thrio/flutter_thrio.dart';

class Flutter11Route extends NavigatorRouteLeaf {
  factory Flutter11Route(final NavigatorRouteNode parent) =>
      _instance ??= Flutter11Route._(parent);

  Flutter11Route._(super.parent);

  static Flutter11Route? _instance;

  @override
  String get name => 'flutter11';

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