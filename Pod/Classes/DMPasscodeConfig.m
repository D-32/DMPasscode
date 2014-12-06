//
//  DMPasscodeConfig.m
//  Pods
//
//  Created by Dylan Marriott on 06.12.14.
//
//

#import "DMPasscodeConfig.h"

@implementation DMPasscodeConfig

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
    }
    return self;
}

@end
