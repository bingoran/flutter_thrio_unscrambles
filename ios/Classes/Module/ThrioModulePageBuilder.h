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
#import "FlutterThrioTypes.h"
#import "ThrioModule.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ThrioModulePageBuilder <NSObject>

/// Register native view controller builder for url.
/// 为url注册native视图控制器生成器
///
/// Do not override this method.
///
- (ThrioVoidCallback)registerPageBuilder:(NavigatorPageBuilder)builder
                                  forUrl:(NSString *)url;

/// Sets the `NavigatorFlutterViewController` builder.
/// 设置 NavigatorFlutterViewController 构建器
///
/// Need to be register when extending the `NavigatorFlutterViewController` class.
/// 当扩展 NavigatorFlutterViewController 类时需要注册
///
/// Do not override this method.
///
- (void)setFlutterPageBuilder:(NavigatorFlutterPageBuilder)builder;

@end

@class ThrioModule;

@interface ThrioModule (PageBuilder) <ThrioModulePageBuilder>

/// A function for register a `PageBuilder` .
/// 注册一个PageBuilder
///
- (void)onPageBuilderRegister:(ThrioModuleContext *)moduleContext;

@end

NS_ASSUME_NONNULL_END
