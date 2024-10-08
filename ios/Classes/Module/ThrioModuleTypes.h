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

#import <Foundation/Foundation.h>

#ifndef ThrioModuleTypes_h
#define ThrioModuleTypes_h

NS_ASSUME_NONNULL_BEGIN

/// Signature for a block that deserialize json map to object.
/// 签名块反序列化json映射到对象
///
typedef id _Nullable (^ThrioJsonDeserializer)(NSDictionary *params);

/// Signature for a block that serializer json object to map.
/// 将json对象序列化为map
///
typedef NSDictionary *_Nullable (^ThrioJsonSerializer)(id);

NS_ASSUME_NONNULL_END

#endif /* ThrioModuleTypes_h */
