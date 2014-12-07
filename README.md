# DMPasscode

[![Build Status](https://img.shields.io/travis/D-32/DMPasscode/master.svg?style=flat)](https://travis-ci.org/D-32/DMPasscode)
[![Version](https://img.shields.io/cocoapods/v/DMPasscode.svg?style=flat)](http://cocoadocs.org/docsets/DMPasscode)
![License](https://img.shields.io/cocoapods/l/DMPasscode.svg?style=flat)
[![twitter: @dylan36032](http://img.shields.io/badge/twitter-%40dylan36032-blue.svg?style=flat)](https://twitter.com/dylan36032)

A simple passcode screen that can be displayed manually. If Touch ID is available the user can skip the screen and instead use his fingerprint to unlock.  
Can be easily customized to fit your design.

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
	+ (void)setConfig:(DMPasscodeConfig *)config;
 
## Customisation

You can pass `DMPasscode` a configuration. Just create a new `DMPasscodeConfiguration`.  
Following properties are available to customise the passcode screen:

	animationsEnabled
	backgroundColor
	navigationBarBackgroundColor
	navigationBarForegroundColor
	statusBarStyle
	fieldColor
	emptyFieldColor
	errorBackgroundColor
	errorForegroundColor
	descriptionColor

