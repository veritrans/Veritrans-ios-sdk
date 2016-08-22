//
//  VTCardFormatter.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTCardFormatter;

@protocol VTCardFormatterDelegate <NSObject>
- (void)formatter_didTextFieldChange:(VTCardFormatter *)formatter;
@end

@interface VTCardFormatter : NSObject

@property (nonatomic) UITextField *textField;
@property (nonatomic, assign) NSInteger numberLimit;
@property (nonatomic, assign) id<VTCardFormatterDelegate>delegate;

- (instancetype)initWithTextField:(UITextField *)textField;
- (BOOL)updateTextFieldContentAndPosition;

@end
