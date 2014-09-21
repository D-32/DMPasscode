//
//  DMPasscode.h
//  DMPasscode
//
//  Created by Dylan Marriott on 20/09/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PasscodeCompletionBlock)(BOOL);

@interface DMPasscode : NSObject

+ (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;
+ (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;
+ (void)removePasscode;
+ (BOOL)isPasscodeSet;

@end
