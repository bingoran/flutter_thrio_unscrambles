// The MIT License (MIT)
//
// Copyright (c) 2022 foxsofter.
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


/// 拓展了一些工具方法：主要就是从传入的dynamic params获取值
/// 
/// 从参数中获取值，当“键”的值没有找到时抛出ArgumentError
///
T getValue<T>(dynamic params, String key) {
  final val = getValueOrNull<T>(params, key);
  if (val != null) {
    return val;
  }
  throw ArgumentError.notNull(key);
}

/// 从参数中获取值，当' key '的值没有找到时返回' defaultValue '。
///
T getValueOrDefault<T>(dynamic params, String key, T defaultValue) {
  final val = getValueOrNull<T>(params, key);
  if (val != null) {
    return val;
  }
  return defaultValue;
}

/// 从参数中获取值
///
T? getValueOrNull<T>(dynamic params, String key) {
  if (params is Map) {
    final val = params[key];
    if (val is T) {
      return val;
    }
  }
  return null;
}

List<E> getListValue<E>(dynamic params, String key) {
  if (params is Map) {
    final col = params[key];
    if (col is List) {
      return List<E>.from(col);
    }
  }
  return <E>[];
}

Map<K, V> getMapValue<K, V>(dynamic params, String key) {
  if (params is Map) {
    final col = params[key];
    if (col is Map) {
      return Map<K, V>.from(col);
    }
  }
  return <K, V>{};
}
