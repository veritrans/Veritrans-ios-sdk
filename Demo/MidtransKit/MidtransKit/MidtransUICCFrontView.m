//
//  MidtransUICCFrontView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUICCFrontView.h"
#import "VTClassHelper.h"

@implementation MidtransUICCFrontView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.deleteButton.hidden = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame maskedCard:(MidtransMaskedCreditCard *)maskedCard {
    if (self = [super initWithFrame:frame]) {
        self.numberLabel.text = [maskedCard.maskedNumber formattedCreditCardNumber];
        NSString *iconName = [MidtransCreditCardHelper nameFromString:maskedCard.maskedNumber];
        self.iconView.image = [UIImage imageNamed:iconName inBundle:VTBundle compatibleWithTraitCollection:nil];
        self.expiryLabel.text = @"XX/XX";
        self.deleteButton.hidden = YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.deleteButton.hidden = YES;
    }
    return self;
}

@end
