//
//  DMPasscodeInternalField.m
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import "DMPasscodeInternalField.h"
#import "DMPasscodeConfig.h"

@implementation DMPasscodeInternalField {
    NSString* _currentText;
    DMPasscodeConfig* _config;
}

- (id)initWithFrame:(CGRect)frame config:(DMPasscodeConfig *)config {
    if (self = [super initWithFrame:frame]) {
        _config = config;
        
        _emptyIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 2 - 1, self.bounds.size.width, 2)];
        _emptyIndicator.backgroundColor = _config.emptyFieldColor;
        [self addSubview:_emptyIndicator];
        
        _filledIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 6, self.bounds.size.height / 2 - 6, 12, 12)];
        _filledIndicator.backgroundColor = _config.fieldColor;
        _filledIndicator.layer.cornerRadius = 6;
        _filledIndicator.alpha = 0;
        [self addSubview:_filledIndicator];
    }
    return self;
}

- (void)setText:(NSString *)text {
    if ([_currentText isEqualToString:text]) {
        return; // only animate once
    }
    _currentText = text;
    
    if (_config.animationsEnabled) {
        _filledIndicator.transform  = text.length > 0 ? CGAffineTransformMakeScale(0.2, 0.2) : CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:0.2 animations:^() {
            _emptyIndicator.alpha = text.length > 0 ? 0.0f : 1.0f;
            _filledIndicator.alpha = text.length > 0 ? 1.0f : 0.0f;
            _filledIndicator.transform  = text.length > 0 ? CGAffineTransformMakeScale(1.3, 1.3) : CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            if (text.length > 0) {
                [UIView animateWithDuration:0.2 animations:^() {
                    _filledIndicator.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }];
    } else {
        _emptyIndicator.alpha = text.length > 0 ? 0.0f : 1.0f;
        _filledIndicator.alpha = text.length > 0 ? 1.0f : 0.0f;
    }
}

@end
