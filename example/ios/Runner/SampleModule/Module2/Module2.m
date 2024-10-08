//
//  Module2.m
//  Runner
//
//  Created by foxsofter on 2020/2/23.
//  Copyright © 2020 foxsofter. All rights reserved.
//

#import "Module2.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@implementation Module2

- (void)onPageBuilderRegister:(ThrioModuleContext *)moduleContext {
    [self registerPageBuilder:^UIViewController *_Nullable (id params) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        return [sb instantiateViewControllerWithIdentifier:@"ThrioViewController2"];
    } forUrl:@"/biz2/native2"];
}

- (void)onRouteObserverRegister:(ThrioModuleContext *)moduleContext {
    [self registerRouteObserver:self];
}

- (void)onPageObserverRegister:(ThrioModuleContext *)moduleContext {
    [self registerPageObserver:self];
}

- (void)didPop:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didPop == 2  %@",routeSettings.url);
}

- (void)didPopTo:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didPopTo == 2  %@",routeSettings.url);
}

- (void)didPush:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didPush == 2  %@",routeSettings.url);
}

- (void)didRemove:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didRemove == 2  %@",routeSettings.url);
}

- (void)willAppear:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>willAppear == 2  %@",routeSettings.url);
}

- (void)didAppear:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didAppear == 2  %@",routeSettings.url);
}

- (void)willDisappear:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>willDisappear == 2  %@",routeSettings.url);
}

- (void)didDisappear:(NavigatorRouteSettings *)routeSettings {
    NSLog(@"====>>>didDisappear == 2  %@",routeSettings.url);
}

@end

NS_ASSUME_NONNULL_END
