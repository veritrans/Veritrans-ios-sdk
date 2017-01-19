//
//  MidtransUICustomTextField.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/20/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUICustomTextField.h"

@interface MidtransUICustomTextField()
@property (strong, nonatomic) NSAttributedString *floatingPlaceholder;
@property (strong, nonatomic) UILabel *floatingPlaceholderLabel;
@property (strong, nonatomic) UIButton *errorButton;
@property (strong, nonatomic) UIImageView *errorArrow;
@property (strong, nonatomic) UILabel *errorMessageLabel;

@end
@implementation MidtransUICustomTextField
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.floatingPlaceholder = self.attributedPlaceholder;
        _floatingPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _floatingPlaceholderLabel.font = self.font;
        _floatingPlaceholderLabel.attributedText = self.floatingPlaceholder;
        _floatingPlaceholderLabel.backgroundColor = [UIColor clearColor];
        _floatingPlaceholderLabel.textColor = self.textColor;
        [self addSubview:_floatingPlaceholderLabel];
        
        _errorButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 17, (self.frame.size.height - 17) /2.0f, 17, 17)];
        [_errorButton setImage:[UIImage imageNamed:@"icon-error"] forState:UIControlStateNormal];
        [_errorButton addTarget:self action:@selector(errorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _errorButton.hidden = YES;
        [self addSubview:_errorButton];

        
        self.clipsToBounds = NO;
        
        [self addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    }
    return self;
}
- (void)errorButtonTapped:(id)sender {
    self.errorArrow.hidden = !self.errorArrow.hidden;
    self.errorMessageLabel.hidden = self.errorArrow.hidden;
}
- (void)textChange:(id)sender {
    [self setErrorMessage:@""];
    if ([self.text isEqualToString:@""]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.floatingPlaceholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.floatingPlaceholderLabel.font = self.font;
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            if (self.floatingFontSize > 0) {
                self.floatingPlaceholderLabel.font = [self.font fontWithSize:self.floatingFontSize];
            }
            else {
                self.floatingPlaceholderLabel.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize*0.85];
            }
            [self.floatingPlaceholderLabel sizeToFit];
        }];
    }
}
- (void)showErrorBubble {
    [self setErrorShown:YES];
}

- (void)setErrorShown:(BOOL)errorShown {
    _errorShown = errorShown;
    self.errorMessageLabel.hidden = self.errorArrow.hidden = !errorShown;
}

- (void)startEditing {
    if (![self.errorMessage isEqualToString:@""] && self.errorMessage)
        self.errorMessageLabel.hidden = self.errorArrow.hidden = NO;
}

- (void)editingDidEnd {
    self.errorMessageLabel.hidden = self.errorArrow.hidden = YES;
}

- (void)setText:(NSString *)text {
    if ([self.text isEqualToString:text]) {
        [self startEditing];
    } else {
        [super setText:text];
        [self textChange:nil];
    }
}
@end
