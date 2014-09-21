//
//  DMAppDelegate.m
//  DMPasscode
//
//  Created by CocoaPods on 09/20/2014.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "DMAppDelegate.h"
#import <DMPasscode/DMPasscode.h>

@implementation DMAppDelegate {
    UIViewController* _rootViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    _rootViewController = [[UIViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    [self addViews];
    return YES;
}

- (void)addViews {
    UIButton* setup = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, _rootViewController.view.frame.size.width, 50)];
    [setup setTitle:@"Setup" forState:UIControlStateNormal];
    [setup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setup addTarget:self action:@selector(actionSetup:) forControlEvents:UIControlEventTouchUpInside];
    [_rootViewController.view addSubview:setup];
    
    UIButton* check = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, _rootViewController.view.frame.size.width, 50)];
    [check setTitle:@"Check" forState:UIControlStateNormal];
    [check setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [check addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    [_rootViewController.view addSubview:check];
}

- (void)actionSetup:(UIButton *)sender {
    [DMPasscode setupPasscodeInViewController:_rootViewController completion:^(BOOL success) {}];
}

- (void)actionCheck:(UIButton *)sender {
    [DMPasscode showPasscodeInViewController:_rootViewController completion:^(BOOL success) {
        if (success) {
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        } else {
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }];
}

@end
