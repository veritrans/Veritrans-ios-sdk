//
//  PaymentCreditCardView.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 2/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "PaymentCreditCardView.h"

@implementation PaymentCreditCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addBorderBottom:self.creditcardTextField];
    [self addBorderBottom:self.validDateTextField];
    [self addBorderBottom:self.cvvTextField];
}
- (void)addBorderBottom:(UITextField *)textfield{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textfield.frame.size.height - 1, textfield.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [textfield.layer addSublayer:bottomBorder];
}
@end
