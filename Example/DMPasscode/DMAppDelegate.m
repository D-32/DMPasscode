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
    UIButton* _setupButton;
    UIButton* _checkButton;
    UIButton* _removeButton;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    _rootViewController = [[UIViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    [self addViews];
    [self updateViews];
    return YES;
}

- (void)addViews {
    _setupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, _rootViewController.view.frame.size.width, 50)];
    [_setupButton setTitle:@"Setup" forState:UIControlStateNormal];
    [_setupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_setupButton addTarget:self action:@selector(actionSetup:) forControlEvents:UIControlEventTouchUpInside];
    [_rootViewController.view addSubview:_setupButton];
    
    _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, _rootViewController.view.frame.size.width, 50)];
    [_checkButton setTitle:@"Check" forState:UIControlStateNormal];
    [_checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_checkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_checkButton addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    [_rootViewController.view addSubview:_checkButton];
    
    _removeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, _rootViewController.view.frame.size.width, 50)];
    [_removeButton setTitle:@"Remove" forState:UIControlStateNormal];
    [_removeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_removeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_removeButton addTarget:self action:@selector(actionRemove:) forControlEvents:UIControlEventTouchUpInside];
    [_rootViewController.view addSubview:_removeButton];
}

- (void)actionSetup:(UIButton *)sender {
    [DMPasscode setupPasscodeInViewController:_rootViewController completion:^(BOOL success) {
        [self updateViews];
    }];
}

- (void)actionCheck:(UIButton *)sender {
    [DMPasscode showPasscodeInViewController:_rootViewController completion:^(BOOL success) {
        if (success) {
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        } else {
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [self updateViews];
    }];
}

- (void)actionRemove:(id)sender {
    [DMPasscode removePasscode];
    [_checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self updateViews];
}

- (void)updateViews {
    BOOL passcodeSet = [DMPasscode isPasscodeSet];
    _checkButton.enabled = passcodeSet;
    _removeButton.enabled = passcodeSet;
}

@end
