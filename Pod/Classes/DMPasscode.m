//
//  DMPasscode.m
//  DMPasscode
//
//  Created by Dylan Marriott on 20/09/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "DMPasscode.h"
#import "DMPasscodeInternalNavigationController.h"
#import "DMPasscodeInternalViewController.h"
#import "DMKeychain.h"

#ifdef __IPHONE_8_0
#import <LocalAuthentication/LocalAuthentication.h>
#endif

static DMPasscode* instance;
static const NSString* KEYCHAIN_NAME = @"passcode";
static NSBundle* bundle;

@interface DMPasscode () <DMPasscodeInternalViewControllerDelegate>

@property BOOL showingPasscode;
@property DMPasscodeInternalViewController* passcodeViewController;

@end

@implementation DMPasscode {
    PasscodeCompletionBlock _completion;
    DMPasscodeMode _mode;
    int _count;
    NSString* _prevCode;
    DMPasscodeConfig* _config;
}

+ (void)initialize {
    [super initialize];
    instance = [[DMPasscode alloc] init];
    bundle = [DMPasscode bundleWithName:@"DMPasscode.bundle"];
}

- (instancetype)init {
    if (self = [super init]) {
        _config = [[DMPasscodeConfig alloc] init];
    }
    return self;
}

+ (NSBundle*)bundleWithName:(NSString*)name {
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:frameworkBundlePath]){
        return [NSBundle bundleWithPath:frameworkBundlePath];
    }
    return nil;
}

#pragma mark - Public
+ (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion {
    [instance setupPasscodeInViewController:viewController completion:completion];
}

+ (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion {
    [instance showPasscodeInViewController:viewController completion:completion];
}

+ (void)lockScreenWithCompletion:(PasscodeCompletionBlock)completion
{
    if (![DMPasscode isPasscodeSet])
        return;
    
    if ([DMPasscode isShowingPasscode]) {
        [instance.passcodeViewController dismissViewControllerAnimated:NO completion:Nil];
    }
    
    UIWindow* main_window = [[UIApplication sharedApplication] keyWindow];
    [main_window.rootViewController.view endEditing:YES];
    
    [instance showPasscodeInViewController:main_window.rootViewController completion:completion animated:NO mode:DMPM_lockScreen];
}

+ (void)removePasscode {
    [instance removePasscode];
}

+ (BOOL)isPasscodeSet {
    return [instance isPasscodeSet];
}

+ (void)setConfig:(DMPasscodeConfig *)config {
    [instance setConfig:config];
}

+ (BOOL)isShowingPasscode
{
    return instance.showingPasscode;
}

+ (void)setShowingPasscode:(BOOL)showing
{
    instance.showingPasscode = showing;
}

#pragma mark - Instance methods
- (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion {
    _completion = completion;
    [self openPasscodeWithMode:DMPM_setup viewController:viewController];
}

- (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion
{
    [self showPasscodeInViewController:viewController completion:completion animated:YES];
}

- (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion animated:(BOOL)animated
{
    [self showPasscodeInViewController:viewController completion:completion animated:animated mode:DMPM_input];
}

- (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion animated:(BOOL)animated mode:(DMPasscodeMode)mode{
    NSAssert([self isPasscodeSet], @"No passcode set");
    _completion = completion;
    LAContext* context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:_config.touchIdReasonTitle reply:^(BOOL success, NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    switch (error.code) {
                        case LAErrorUserCancel:
                        case LAErrorSystemCancel:
                        case LAErrorAuthenticationFailed:
                            _completion(NO);
                            break;
                        case LAErrorPasscodeNotSet:
                        case LAErrorTouchIDNotEnrolled:
                        case LAErrorTouchIDNotAvailable:
                        case LAErrorUserFallback:
                            [self openPasscodeWithMode:mode viewController:viewController animated:animated];
                            break;
                    }
                } else {
                    _completion(success);
                }
            });
        }];
    } else {
        // no touch id available
        [self openPasscodeWithMode:mode viewController:viewController animated:animated];
    }
}

- (void)removePasscode {
    [[DMKeychain defaultKeychain] removeObjectForKey:KEYCHAIN_NAME];
}

- (BOOL)isPasscodeSet {
    BOOL ret = [[DMKeychain defaultKeychain] objectForKey:KEYCHAIN_NAME] != nil;
    return ret;
}

- (void)setConfig:(DMPasscodeConfig *)config {
    _config = config;
}

#pragma mark - Private
- (void)openPasscodeWithMode:(DMPasscodeMode)mode viewController:(UIViewController *)viewController
{
    [self openPasscodeWithMode:mode viewController:viewController animated:YES];
}

- (void)openPasscodeWithMode:(DMPasscodeMode)mode viewController:(UIViewController *)viewController animated:(BOOL)animated {
    _mode = mode;
    _count = 0;
    
    self.passcodeViewController = [[DMPasscodeInternalViewController alloc] initWithDelegate:self config:_config mode:_mode];
    DMPasscodeInternalNavigationController* nc = [[DMPasscodeInternalNavigationController alloc] initWithRootViewController:self.passcodeViewController];
        
    [viewController presentViewController:nc
                                 animated:animated
                               completion:^{
                               }];
    if (_mode == DMPM_setup) {
        [self.passcodeViewController setInstructions:_config.enterNewCodeTitle];
    } else if (_mode == DMPM_input || _mode == DMPM_lockScreen) {
        [self.passcodeViewController setInstructions:_config.enterCoodeToUnlockTitle];
    }
}

- (void)closeAndNotify:(BOOL)success {
    [self.passcodeViewController dismissViewControllerAnimated:YES completion:^() {
        _completion(success);
    }];
}

#pragma mark - DMPasscodeInternalViewControllerDelegate
- (void)enteredCode:(NSString *)code {
    if (_mode == DMPM_setup) {
        if (_count == 0) {
            _prevCode = code;
            [self.passcodeViewController setInstructions:_config.repeatCodeTitle];
            [self.passcodeViewController reset];
        } else if (_count == 1) {
            if ([code isEqualToString:_prevCode]) {
                [[DMKeychain defaultKeychain] setObject:code forKey:KEYCHAIN_NAME];
                [self closeAndNotify:YES];
            } else {
                UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:_config.noMatchTitle
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:_config.okayTitle, nil];
                [errorAlert show];
                [self closeAndNotify:NO];
            }
        }
    } else if (_mode == DMPM_input || _mode == DMPM_lockScreen) {
        if ([code isEqualToString:[[DMKeychain defaultKeychain] objectForKey:KEYCHAIN_NAME]]) {
            [self closeAndNotify:YES];
        } else {
            [self.passcodeViewController setErrorMessage:[NSString stringWithFormat:_config.leftAttemptsTitle, 2 - _count]];
            [self.passcodeViewController reset];
            if (_count >= 2) { // max 3 attempts
                [self closeAndNotify:NO];
            }
        }
    }
    _count++;
}

- (void)canceled {
    _completion(NO);
}

@end
