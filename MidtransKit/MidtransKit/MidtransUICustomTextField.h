//
//  MidtransUICustomTextField.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/20/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MidtransUICustomTextField : UITextField
@property (strong, nonatomic) NSString *errorMessage;
@property (assign, nonatomic) BOOL errorShown;
@property (assign, nonatomic) IBInspectable BOOL bottomLine;
@property (assign, nonatomic) IBInspectable NSInteger floatingFontSize;
@property (assign, nonatomic) IBInspectable UIColor *placeholderLabelColor;
@end
