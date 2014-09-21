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

/**
 *  The passcode screen has to be manually opened. You decide when it should be presented.
 *  The chosen code is stored inside the keychain.
 *  First let the user set a passcode by calling the setupPasscodeInViewController:completion: method.
 *  If you want to authenticate the user, simple call showPasscodeInViewController:completion.
 */
@interface DMPasscode : NSObject

/**
 *  Setup a new passcode.
 *
 *  @param viewController The view controller in which the passcode screen will be presented
 *  @param completion     The completion block with a BOOL to inidcate if the setup was successfull
 */
+ (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;

/**
 *  Authenticate the user.
 *
 *  @param viewController The view controller in which the passcode screen will be presented
 *  @param completion     The completion block with a BOOL to inidcate if the authentication was successfull
 */
+ (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;

/**
 *  Remove the passcode from the keychain.
 */
+ (void)removePasscode;

/**
 *  Check if a passcode is already set.
 *
 *  @return BOOL indicating if a passcode is set
 */
+ (BOOL)isPasscodeSet;

@end
