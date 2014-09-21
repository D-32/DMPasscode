//
//  DMPasscodeInternalViewController.m
//  Pods
//
//  Created by Dylan Marriott on 20/09/14.
//
//

#import "DMPasscodeInternalViewController.h"
#import "DMPasscodeInternalField.h"

@interface DMPasscodeInternalViewController () <UITextFieldDelegate>
@end

@implementation DMPasscodeInternalViewController {
    __weak id<DMPasscodeInternalViewControllerDelegate> _delegate;
    NSMutableArray* _textFields;
    UITextField* _input;
    UILabel* _instructions;
    UILabel* _error;
}

- (id)initWithDelegate:(id<DMPasscodeInternalViewControllerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _instructions = [[UILabel alloc] init];
        _error = [[UILabel alloc] init];
        _textFields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem* closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    _instructions.frame = CGRectMake(0, 85, self.view.frame.size.width, 30);
    _instructions.font = [UIFont systemFontOfSize:16];
    _instructions.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    _instructions.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_instructions];
    
    _error.frame = CGRectMake(self.view.frame.size.width / 2 - 78, 190, 156, 30);
    _error.font = [UIFont systemFontOfSize:14];
    _error.textColor = [UIColor whiteColor];
    _error.backgroundColor = [UIColor colorWithRed:0.63 green:0.00 blue:0.00 alpha:1.00];
    _error.textAlignment = NSTextAlignmentCenter;
    _error.layer.cornerRadius = 4;
    _error.clipsToBounds = YES;
    _error.alpha = 0;
    [self.view addSubview:_error];
    
    CGFloat y_padding = 140;
    CGFloat itemWidth = 24;
    int space = 20;
    CGFloat x_padding = (self.view.bounds.size.width - (itemWidth * 4) - (space * 3)) / 2;
    
    for (int i = 0; i < 4; i++) {
        DMPasscodeInternalField* field = [[DMPasscodeInternalField alloc] initWithFrame:CGRectMake(x_padding + ((itemWidth + space) * i), y_padding, itemWidth, itemWidth)];
        [self.view addSubview:field];
        [_textFields addObject:field];
    }
    
 
    _input = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_input setDelegate:self];
    [_input addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    _input.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_input];
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
    for (DMPasscodeInternalField* field in _textFields) {
        field.text = @"";
    }
    for (int i = 0; i < sender.text.length; i++) {
        DMPasscodeInternalField* field = [_textFields objectAtIndex:i];
        NSRange range;
        range.length = 1;
        range.location = i;
        field.text = [sender.text substringWithRange:range];
    }
    
    NSString* code = sender.text;
    if (code.length == 4) {
        [_delegate enteredCode:code];
    }
}

- (void)close:(id)sender {
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
}

- (void)setInstructions:(NSString *)instructions {
    _instructions.text = instructions;
}


@end
