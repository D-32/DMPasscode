//
//  DMPasscodeInternalField.h
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DMPasscodeConfig;

@interface DMPasscodeInternalField : UIView

@property (nonatomic, strong, readonly) UIView* emptyIndicator;
@property (nonatomic, strong, readonly) UIView* filledIndicator;
@property (nonatomic, strong) NSString* text;

- (id)initWithFrame:(CGRect)frame config:(DMPasscodeConfig *)config;

@end
