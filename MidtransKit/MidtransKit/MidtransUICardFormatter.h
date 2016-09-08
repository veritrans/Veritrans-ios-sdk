//
//  VTCardFormatter.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MidtransUICardFormatter;

@protocol MidtransUICardFormatterDelegate <NSObject>
- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter;
@end

@interface MidtransUICardFormatter : NSObject

@property (nonatomic) UITextField *textField;
@property (nonatomic, assign) NSInteger numberLimit;
@property (nonatomic, assign) id<MidtransUICardFormatterDelegate>delegate;

- (instancetype)initWithTextField:(UITextField *)textField;
- (BOOL)updateTextFieldContentAndPosition;

@end
