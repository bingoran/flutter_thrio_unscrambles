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

import 'package:flutter/foundation.dart';

import '../registry/registry_map.dart';
import 'module_types.dart';
import 'thrio_module.dart';
// on 是用来指定 mixin 可以被应用的类类型的一种语法，
// 它限制了哪些类可以使用这个 mixin
// 以确保 mixin 中定义的方法和属性只能被特定类型的类使用
mixin ModuleJsonSerializer on ThrioModule {
  /// Json serializer registered in the current Module
  /// 在当前模块中注册的Json序列化器
  ///
  final _jsonSerializers = RegistryMap<Type, JsonSerializer>();

  /// Get json serializer by type string.
  /// 通过类型返回一个json序列化器
  ///
  @protected
  JsonSerializer? getJsonSerializer(String typeString) {
    final type = _jsonSerializers.keys.lastWhere(
        (it) =>
            it.toString() == typeString || typeString.endsWith(it.toString()),
        orElse: () => Null);
    return _jsonSerializers[type];
  }

  /// A function for register a json serializer.
  /// 注册序列化器,子类实现，初始化的时候会统一调用
  ///
  @protected
  void onJsonSerializerRegister(ModuleContext moduleContext) {}

  /// Register a json serializer for the module.
  ///
  /// Unregistry by calling the return value `VoidCallback`.
  ///
  @protected
  VoidCallback registerJsonSerializer<T>(JsonSerializer serializer) =>
      _jsonSerializers.registry(T, serializer);
}
