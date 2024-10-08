// The MIT License (MIT)
//
// Copyright (c) 2020 foxsofter
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

// ignore_for_file: invalid_use_of_protected_member, avoid_as

part of 'thrio_module.dart';

/// 模块上线文
/// 1、提供入口名
/// 2、通过Expando存储模块对象
/// 3、可以在Context上订阅参数，但是前提得先进行 onParamSchemeRegister 进行参数注册
class ModuleContext {
  ModuleContext({this.entrypoint = 'main'});

  /// Entrypoint of current app.
  /// 当前APP的入口点
  ///
  final String entrypoint;

  /// Module of module context.
  /// 模块的上下文
  ///
  ThrioModule get module => moduleOf[this]!;

  /// 获取context 中存储的参数
  /// Get param `value` of `key`.
  /// 通过参数“key”获取“value”。
  ///
  /// If not exist, get from parent module's `ModuleContext`.
  /// 如果不存在，则从父模块的 ModuleContext 中获取
  ///
  T? get<T>(String key) {
    
    if (module is ModuleParamScheme) {
      final value = (module as ModuleParamScheme).getParam<T>(key);
      if (value != null) {
        return value;
      }
    }
    //如果不存在，则从父模块的 ModuleContext 中获取
    return module.parent?._moduleContext.get<T>(key);
  }

  /// Set param `value` with `key`.
  /// 通过参数“key”设置“value”。
  ///
  /// Return `false` if param scheme is not registered.
  /// 如果scheme未注册，返回false
  ///
  bool set<T>(String key, T value) {
    if (module is ModuleParamScheme) {
      if ((module as ModuleParamScheme).setParam<T>(key, value)) {
        return true;
      }
    }
    // Anchor module caches the data of the framework
    // 锚定模块缓存framework数据
    return module.parent != anchor &&
        module.parent != null &&
        (module.parent?._moduleContext.set<T>(key, value) ?? false);
  }

  /// Remove param with `key`.
  /// 移除param的key
  ///
  /// Return `value` if param not exists.
  /// 如果参数不存在，返回' value '
  ///
  T? remove<T>(String key) {
    if (module is ModuleParamScheme) {
      final value = (module as ModuleParamScheme).removeParam<T>(key);
      if (value != null) {
        return value;
      }
    }
    // Anchor module caches the data of the framework
    // 锚定模块缓存framework数据
    return module.parent == anchor
        ? null
        : module.parent?._moduleContext.remove<T>(key);
  }

  /// Subscribe to a series of param by `key`.
  /// 订阅一系列通过 key 定义的参数
  ///
  /// sink `null` when `key` removed.
  /// 当删除 key 时，将 null 输出
  ///
  Stream<T?>? onWithNull<T>(String key, {T? initialValue}) {
    if (module == anchor) {
      return anchor.onParam<T>(key, initialValue: initialValue);
    }

    if (module is ModuleParamScheme) {
      final paramModule = module as ModuleParamScheme;
      // ⚠️注意：这里T的类型必须和注册Param Scheme 注册时候的类型一致
      if (paramModule.hasParamScheme<T>(key)) {
        return paramModule.onParam<T>(key, initialValue: initialValue);
      }
    }

    return module.parent?._moduleContext
        .onWithNull<T>(key, initialValue: initialValue);
  }

  /// Subscribe to a series of param by `key`.
  /// 订阅一系列通过 key 定义的参数
  ///
  Stream<T>? on<T>(String key, {T? initialValue}) =>
      onWithNull<T>(key, initialValue: initialValue)
          ?.transform<T>(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data != null) {
            sink.add(data);
          }
        },
      ));

  @override
  String toString() => 'Context of module ${module.key}';
}
