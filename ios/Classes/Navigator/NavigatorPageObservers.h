// The MIT License (MIT)
//
// Copyright (c) 2019 foxsofter
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

#import "NavigatorPageObserverProtocol.h"
#import "ThrioRegistrySet.h"

NS_ASSUME_NONNULL_BEGIN

@interface NavigatorPageObservers : NSObject<NavigatorPageObserverProtocol>

@property (nonatomic, readonly) ThrioRegistrySet<id<NavigatorPageObserverProtocol> > *observers;

// 记录最后一个页面Router
@property (nonatomic) NavigatorPageRoute *lastRoute;
// 记录最后一个页面的前一个页面的Rout特人
@property (nonatomic, readonly) NavigatorPageRoute *prevLastRoute;


@end

NS_ASSUME_NONNULL_END
