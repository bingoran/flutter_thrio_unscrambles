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

#import "UIViewController+HidesNavigationBar.h"
#import "UIViewController+Internal.h"

@implementation UIViewController (HidesNavigationBar)

// 获取当前导航栏掩藏状态
- (BOOL)thrio_hidesNavigationBar {
    return [[self thrio_hidesNavigationBar_] boolValue];
}

// 设置当前导航栏掩藏｜显示
- (void)setThrio_hidesNavigationBar:(BOOL)hidesNavigationBar {
    [self setThrio_hidesNavigationBar_:@(hidesNavigationBar)];
    if ([self.navigationController.viewControllers containsObject:self]) {
        // 设置导航的展示或者掩藏
        self.navigationController.navigationBarHidden = hidesNavigationBar;
    }
}

@end
