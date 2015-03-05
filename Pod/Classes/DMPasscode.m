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

#undef NSLocalizedString
#define NSLocalizedString(key, comment) \
[bundle localizedStringForKey:(key) value:@"" table:@"DMPasscodeLocalisation"]

static DMPasscode* instance;
static const NSString* KEYCHAIN_NAME = @"passcode";
static NSBundle* bundle;
NSString * const DMUnlockErrorDomain = @"com.dmpasscode.error.unlock";

@interface DMPasscode () <DMPasscodeInternalViewControllerDelegate>
@end

@implementation DMPasscode {
    PasscodeCompletionBlock _completion;
    DMPasscodeInternalViewController* _passcodeViewController;
    int _mode; // 0 = setup, 1 = input
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

+ (void)removePasscode {
    [instance removePasscode];
}

+ (BOOL)isPasscodeSet {
    return [instance isPasscodeSet];
}

+ (void)setConfig:(DMPasscodeConfig *)config {
    [instance setConfig:config];
}

#pragma mark - Instance methods
- (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion {
    _completion = completion;
    [self openPasscodeWithMode:0 viewController:viewController];
}

- (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion {
    NSAssert([self isPasscodeSet], @"No passcode set");
    _completion = completion;
    LAContext* context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"dmpasscode_touchid_reason", nil) reply:^(BOOL success, NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    switch (error.code) {
                        case LAErrorUserCancel:
                            _completion(NO, nil);
                            break;
                        case LAErrorSystemCancel:
                            _completion(NO, nil);
                            break;
                        case LAErrorAuthenticationFailed:
                            _completion(NO, error);
                            break;
                        case LAErrorPasscodeNotSet:
                        case LAErrorTouchIDNotEnrolled:
                        case LAErrorTouchIDNotAvailable:
                        case LAErrorUserFallback:
                            [self openPasscodeWithMode:1 viewController:viewController];
                            break;
                    }
                } else {
                    _completion(success, nil);
                }
            });
        }];
    } else {
        // no touch id available
        [self openPasscodeWithMode:1 viewController:viewController];
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
- (void)openPasscodeWithMode:(int)mode viewController:(UIViewController *)viewController {
    _mode = mode;
    _count = 0;
    _passcodeViewController = [[DMPasscodeInternalViewController alloc] initWithDelegate:self config:_config];
    DMPasscodeInternalNavigationController* nc = [[DMPasscodeInternalNavigationController alloc] initWithRootViewController:_passcodeViewController];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [viewController presentViewController:nc animated:YES completion:nil];
    if (_mode == 0) {
        [_passcodeViewController setInstructions:NSLocalizedString(@"dmpasscode_enter_new_code", nil)];
    } else if (_mode == 1) {
        [_passcodeViewController setInstructions:NSLocalizedString(@"dmpasscode_enter_to_unlock", nil)];
    }
}

- (void)closeAndNotify:(BOOL)success withError:(NSError *)error {
    [_passcodeViewController dismissViewControllerAnimated:YES completion:^() {
        _completion(success, error);
    }];
}

#pragma mark - DMPasscodeInternalViewControllerDelegate
- (void)enteredCode:(NSString *)code {
    if (_mode == 0) {
        if (_count == 0) {
            _prevCode = code;
            [_passcodeViewController setInstructions:NSLocalizedString(@"dmpasscode_repeat", nil)];
            [_passcodeViewController setErrorMessage:@""];
            [_passcodeViewController reset];
        } else if (_count == 1) {
            if ([code isEqualToString:_prevCode]) {
                [[DMKeychain defaultKeychain] setObject:code forKey:KEYCHAIN_NAME];
                [self closeAndNotify:YES withError:nil];
            } else {
                [_passcodeViewController setInstructions:NSLocalizedString(@"dmpasscode_enter_new_code", nil)];
                [_passcodeViewController setErrorMessage:NSLocalizedString(@"dmpasscode_not_match", nil)];
                [_passcodeViewController reset];
                _count = 0;
                return;
            }
        }
    } else if (_mode == 1) {
        if ([code isEqualToString:[[DMKeychain defaultKeychain] objectForKey:KEYCHAIN_NAME]]) {
            [self closeAndNotify:YES withError:nil];
        } else {
            if (_count == 1) {
                [_passcodeViewController setErrorMessage:NSLocalizedString(@"dmpasscode_1_left", nil)];
            } else {
                [_passcodeViewController setErrorMessage:[NSString stringWithFormat:NSLocalizedString(@"dmpasscode_n_left", nil), 2 - _count]];
            }
            [_passcodeViewController reset];
            if (_count >= 2) { // max 3 attempts
                NSError *errorMatchingPins = [NSError errorWithDomain:DMUnlockErrorDomain code:DMErrorUnlocking userInfo:nil];
                [self closeAndNotify:NO withError:errorMatchingPins];
            }
        }
    }
    _count++;
}

- (void)canceled {
    _completion(NO, nil);
}

@end
