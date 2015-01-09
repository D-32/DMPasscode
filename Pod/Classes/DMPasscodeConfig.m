//
//  DMPasscodeConfig.m
//  Pods
//
//  Created by Dylan Marriott on 06.12.14.
//
//

#import "DMPasscodeConfig.h"

#define NSLocalizedStringPasscode(key, comment) \
[[DMPasscodeConfig bundleWithName:@"DMPasscode.bundle"] localizedStringForKey:(key) value:@"" table:@"DMPasscodeLocalisation"]

@implementation DMPasscodeConfig

+ (NSBundle*)bundleWithName:(NSString*)name {
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:frameworkBundlePath]){
        return [NSBundle bundleWithPath:frameworkBundlePath];
    }
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.animationsEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.navigationBarBackgroundColor = nil;
        self.navigationBarForegroundColor = nil;
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.fieldColor = [UIColor grayColor];
        self.emptyFieldColor = [UIColor grayColor];
        self.errorBackgroundColor = [UIColor colorWithRed:0.63 green:0.00 blue:0.00 alpha:1.00];
        self.errorForegroundColor = [UIColor whiteColor];
        self.descriptionColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.inputKeyboardAppearance = UIKeyboardAppearanceDefault;
        self.errorFont = [UIFont systemFontOfSize:14];
        self.instructionsFont = [UIFont systemFontOfSize:16];
        self.navigationBarTitle = @"";
        self.navigationBarFont = [UIFont systemFontOfSize:16];
        self.navigationBarTitleColor = [UIColor darkTextColor];
        self.enterNewCodeTitle = NSLocalizedStringPasscode(@"dmpasscode_enter_new_code", @"");
        self.enterCoodeToUnlockTitle = NSLocalizedStringPasscode(@"dmpasscode_enter_to_unlock", @"");
        self.repeatCodeTitle = NSLocalizedStringPasscode(@"dmpasscode_repeat", @"");
        self.noMatchTitle = NSLocalizedStringPasscode(@"dmpasscode_not_match", @"");
        self.okayTitle = NSLocalizedStringPasscode(@"dmpasscode_okay", @"");
        self.leftAttemptsTitle = NSLocalizedStringPasscode(@"dmpasscode_n_left", @"");
        self.touchIdReasonTitle = NSLocalizedStringPasscode(@"dmpasscode_touchid_reason", @"");
    }
    return self;
}

@end
