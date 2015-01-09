//
//  DMPasscodeInternalViewController.h
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DMPM_setup,
    DMPM_input,
    DMPM_lockScreen,
} DMPasscodeMode;

@protocol DMPasscodeInternalViewControllerDelegate <NSObject>

- (void)enteredCode:(NSString *)code;
- (void)canceled;

@end

@class DMPasscodeConfig;

@interface DMPasscodeInternalViewController : UIViewController

- (id)initWithDelegate:(id<DMPasscodeInternalViewControllerDelegate>)delegate config:(DMPasscodeConfig *)config mode:(DMPasscodeMode)mode;
- (void)reset;
- (void)setErrorMessage:(NSString *)errorMessage;
- (void)setInstructions:(NSString *)instructions;

@end
