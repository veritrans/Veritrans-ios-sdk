//
//  VTCreditCard+Utilities.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 4/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCard+Utilities.h"
#import "VTClassHelper.h"

@implementation VTCreditCard (Utilities)

- (UIImage *)cardIcon {
    VTCreditCardType type = [VTCreditCard typeWithNumber:self.number];
    switch (type) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"Visa" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCB" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeUnknown:
            return nil;
    }
}

- (UIImage *)cardIconDark {
    VTCreditCardType type = [VTCreditCard typeWithNumber:self.number];
    switch (type) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeUnknown:
            return nil;
    }
}


@end
