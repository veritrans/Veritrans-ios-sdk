//
//  VTKeyboardAccessoryView.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 4/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTKeyboardAccessoryView.h"
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"

@interface VTKeyboardAccessoryView ()
@property (nonatomic) NSArray *fields;
@property (nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation VTKeyboardAccessoryView

- (id)initWithFrame:(CGRect)frame fields:(NSArray *)fields {
    if (self = [super initWithFrame:frame]) {
        self.fields = fields;
        
        UIColor *themedColor = [[MidtransUIThemeManager shared] themeColor];
        [self.doneButton setTitleColor:themedColor forState:UIControlStateNormal];
        
        UIImage *buttonImage = [[UIImage imageNamed:@"nextIcon" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.nextButton setImage:buttonImage forState:UIControlStateNormal];
        self.nextButton.tintColor = themedColor;
        
        buttonImage = [[UIImage imageNamed:@"prevIcon" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.prevButton setImage:buttonImage forState:UIControlStateNormal];
        self.prevButton.tintColor = themedColor;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (selectedIndex == _fields.count) {
        _selectedIndex = _fields.count - 1;
    }
    if (selectedIndex < 0) {
        _selectedIndex = 0;
    }
    _nextButton.enabled = _selectedIndex != _fields.count-1;
    _prevButton.enabled = _selectedIndex != 0;
    
    UITextField *selectedField = [self fieldAtIndex:_selectedIndex];
    [selectedField becomeFirstResponder];
}

- (UITextField *)fieldAtIndex:(NSInteger)index {
    for (int i=0; i < _fields.count; i++) {
        if (i == index) {
            return _fields[i];
        }
    }
    return nil;
}

- (IBAction)donePressed:(id)sender {
    [[self fieldAtIndex:self.selectedIndex] resignFirstResponder];
}
- (IBAction)nextPressed:(id)sender {
    self.selectedIndex = self.selectedIndex + 1;
}
- (IBAction)prevPressed:(id)sender {
    self.selectedIndex = self.selectedIndex - 1;
}

- (void)setFields:(NSArray *)fields {
    _fields = fields;
    for (UITextField *field in fields) {
        field.inputAccessoryView = self;
        [field addTarget:self action:@selector(editingBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
}

- (void)editingBegin:(UITextField *)textField {
    self.selectedIndex = [_fields indexOfObject:textField];;
}


@end
