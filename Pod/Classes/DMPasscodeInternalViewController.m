//
//  DMPasscodeInternalViewController.m
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import "DMPasscodeInternalViewController.h"
#import "DMPasscodeInternalField.h"
#import "DMPasscodeConfig.h"

@interface DMPasscodeInternalViewController () <UITextFieldDelegate>
@end

@implementation DMPasscodeInternalViewController {
    __weak id<DMPasscodeInternalViewControllerDelegate> _delegate;
    NSMutableArray* _textFields;
    UITextField* _input;
    UILabel* _instructions;
    UILabel* _error;
    DMPasscodeConfig* _config;
}

- (id)initWithDelegate:(id<DMPasscodeInternalViewControllerDelegate>)delegate config:(DMPasscodeConfig *)config {
    if (self = [super init]) {
        _delegate = delegate;
        _config = config;
        _instructions = [[UILabel alloc] init];
        _error = [[UILabel alloc] init];
        _textFields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = _config.backgroundColor;
    self.navigationController.navigationBar.barTintColor = _config.navigationBarBackgroundColor;
    UIBarButtonItem* closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
    closeItem.tintColor = _config.navigationBarForegroundColor;
    self.navigationItem.leftBarButtonItem = closeItem;
    self.navigationController.navigationBar.barStyle = (UIBarStyle)_config.statusBarStyle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName :_config.navigationBarFont,
                                                                    NSForegroundColorAttributeName: _config.navigationBarTitleColor};
    self.title = _config.navigationBarTitle;
    
    _instructions.frame = CGRectMake(0, 85, self.view.frame.size.width, 30);
    _instructions.font = _config.instructionsFont;
    _instructions.textColor = _config.descriptionColor;
    _instructions.textAlignment = NSTextAlignmentCenter;
    _instructions.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_instructions];
    
    _error.frame = CGRectMake(0, 190, 0, 0); // size set when text is set
    _error.font = _config.errorFont;
    _error.textColor = _config.errorForegroundColor;
    _error.backgroundColor = _config.errorBackgroundColor;
    _error.textAlignment = NSTextAlignmentCenter;
    _error.layer.cornerRadius = 4;
    _error.clipsToBounds = YES;
    _error.alpha = 0;
    _error.numberOfLines = 0;
    _error.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_error];
    
    CGFloat y_padding = 140;
    CGFloat itemWidth = 24;
    CGFloat space = 20;
    CGFloat totalWidth = (itemWidth * 4) + (space * 3);
    CGFloat x_padding = (self.view.bounds.size.width - totalWidth) / 2;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(x_padding, y_padding, totalWidth, itemWidth)];
    container.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    for (int i = 0; i < 4; i++) {
        DMPasscodeInternalField* field = [[DMPasscodeInternalField alloc] initWithFrame:CGRectMake(((itemWidth + space) * i), 0, itemWidth, itemWidth) config:_config];
        UITapGestureRecognizer* singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [field addGestureRecognizer:singleFingerTap];
        [container addSubview:field];
        [_textFields addObject:field];
    }
    [self.view addSubview:container];
    
 
    _input = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_input setDelegate:self];
    [_input addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    _input.keyboardType = UIKeyboardTypeNumberPad;
    _input.keyboardAppearance = _config.inputKeyboardAppearance;
    [self.view addSubview:_input];
    [_input becomeFirstResponder];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if([_input isFirstResponder]){
        [_input resignFirstResponder];
    }
    [_input becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 4|| returnKey;
}

- (void)editingChanged:(UITextField *)sender {
    for (int i = 0; i < sender.text.length; i++) {
        DMPasscodeInternalField* field = [_textFields objectAtIndex:i];
        NSRange range;
        range.length = 1;
        range.location = i;
        field.text = [sender.text substringWithRange:range];
    }
    for (int i = (int)sender.text.length; i < 4; i++) {
        DMPasscodeInternalField* field = [_textFields objectAtIndex:i];
        field.text = @"";
    }
    
    NSString* code = sender.text;
    if (code.length == 4) {
        [_delegate enteredCode:code];
    }
}

- (void)close:(id)sender {
    [_input resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate canceled];
}

- (void)reset {
    for (DMPasscodeInternalField* field in _textFields) {
        field.text = @"";
    }
    _input.text = @"";
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _error.text = errorMessage;
    _error.alpha = errorMessage.length > 0 ? 1.0f : 0.0f;
    
    CGSize size = [_error.text sizeWithAttributes:@{NSFontAttributeName: _error.font}];
    size.width += 28;
    size.height += 28;
    _error.frame = CGRectMake(self.view.frame.size.width / 2 - size.width / 2, _error.frame.origin.y, size.width, size.height);
}

- (void)setInstructions:(NSString *)instructions {
    _instructions.text = instructions;
}


@end
