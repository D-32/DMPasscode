# DMPasscode

[![Build Status](https://travis-ci.org/D-32/DMPasscode.svg)](https://travis-ci.org/D-32/DMPasscode)
[![Version](https://img.shields.io/cocoapods/v/DMPasscode.svg?style=flat)](http://cocoadocs.org/docsets/DMPasscode)
[![License](https://img.shields.io/cocoapods/l/DMPasscode.svg?style=flat)](http://cocoadocs.org/docsets/DMPasscode)

A simple passcode screen that can be displayed manually. If Touch ID is available the user can skip the screen and instead use his fingerprint to unlock.

![image](http://46.105.26.1/uploads/passcode.png)

## Installation

DMPasscode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DMPasscode"
If you're not using CocoaPods you'll find the source code files inside `Pod/Classes`. You'll also have to add the `DMPasscode.bundle` to your project.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The class `DMPasscode` contains following methods:
	
	+ (void)setupPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;
	+ (void)showPasscodeInViewController:(UIViewController *)viewController completion:(PasscodeCompletionBlock)completion;
	+ (void)removePasscode;
	+ (BOOL)isPasscodeSet;
 