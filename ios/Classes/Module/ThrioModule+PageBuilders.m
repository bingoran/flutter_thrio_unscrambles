// The MIT License (MIT)
//
// Copyright (c) 2021 foxsofter.
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

#import <objc/runtime.h>
#import "ThrioModule+PageBuilders.h"

@implementation ThrioModule (PageBuilders)

// 获取flutter页面的pagebuild
+ (NavigatorFlutterPageBuilder _Nullable)flutterPageBuilder {
    return objc_getAssociatedObject(self, _cmd);
}

// 设置flutter页面的pagebuild
+ (void)setFlutterPageBuilder:(NavigatorFlutterPageBuilder _Nullable)builder {
    objc_setAssociatedObject(self,
                             @selector(flutterPageBuilder),
                             builder,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// 存放注册的所有native pageBuilder
+ (ThrioRegistryMap *)pageBuilders {
    id builders = objc_getAssociatedObject(self, _cmd);
    if (!builders) {
        builders = [ThrioRegistryMap map];
        objc_setAssociatedObject(self, _cmd, builders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return builders;
}

@end
