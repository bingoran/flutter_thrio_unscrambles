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

#import <Foundation/Foundation.h>
#import "NavigatorFlutterEngine.h"
#import "NavigatorFlutterViewController.h"
#import "NavigatorPageObserverProtocol.h"
#import "NavigatorRouteSendChannel.h"
#import "NavigatorRouteObserverProtocol.h"
#import "ThrioFlutterEngine.h"
#import "FlutterThrioTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * flutter 引擎工厂
  */
@interface NavigatorFlutterEngineFactory : NSObject<
NavigatorPageObserverProtocol,
NavigatorRouteObserverProtocol
>

// 是否启用多引擎
@property (nonatomic) BOOL multiEngineEnabled;
// 主引擎是否预启动
@property (nonatomic) BOOL mainEnginePreboot;

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;

- (NavigatorFlutterEngine *)startupWithEntrypoint:(NSString *)entrypoint readyBlock:(ThrioEngineReadyCallback _Nullable)block;

// 是否是主引擎（第一个引擎）
- (BOOL)isMainEngineByEntrypoint:(NSString *)entrypoint;

// 根据入口名获取引擎
- (NavigatorFlutterEngine *_Nullable)getEngineByEntrypoint:(NSString *)entrypoint;

// 销毁引擎
- (void)destroyEngineByEntrypoint:(NSString *)entrypoint;

// 根据引擎名获取Send Channel
- (NavigatorRouteSendChannel *)getSendChannelByEntrypoint:(NSString *)entrypoint;

// 根据入口名获取引擎 moduleContext Channel
- (ThrioChannel *)getModuleChannelByEntrypoint:(NSString *)entrypoint;

// 同步设置所有引擎context数据
- (void)setModuleContextValue:(id _Nullable)value forKey:(NSString *)key;

- (void)pushViewController:(NavigatorFlutterViewController *)viewController;

- (void)popViewController:(NavigatorFlutterViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
