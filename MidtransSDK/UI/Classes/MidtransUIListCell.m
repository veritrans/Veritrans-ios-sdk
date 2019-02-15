//
//  MidtransUIListCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIListCell.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@implementation MidtransUIListCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.promoNotificationView.layer.cornerRadius = 5.0f;
    self.promoNotificationView.layer.masksToBounds = YES;
}
- (void)configureWithModel:(MIDPaymentDetail *)model info:(MIDPaymentInfo *)info {
    self.promoNotificationView.hidden =  YES;
    self.paymentMethodNameLabel.text = model.title;
    self.paymentMethodDescriptionLabel.text = model.paymentDescription;
    NSString *imagePath =[NSString stringWithFormat:@"%@",model.paymentID];
    if ([model.paymentID isEqualToString:@"echannel"]) {
        imagePath = @"mandiri_va";
    }
    if ([model.paymentID isEqualToString:@"credit_card"]) {
        if (info.promo.promos.count) {
            self.promoNotificationView.hidden =  NO;
        }
    }
    else if ([model.paymentID isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        self.paymentMethodNameLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Credit/Debit Card"];
        NSArray *capArray = [info.merchant.enabledPrinciples valueForKeyPath:@"capitalizedString"];
        self.paymentMethodDescriptionLabel.text =  [NSString stringWithFormat:@"%@ %@",[VTClassHelper getTranslationFromAppBundleForString:@"Pay With"],[capArray componentsJoinedByString:@", "]];
        if ([capArray containsObject:@"Jcb"]) {
            self.paymentMethodDescriptionLabel.text = [self.paymentMethodDescriptionLabel.text stringByReplacingOccurrencesOfString:@"Jcb" withString:@"JCB"];
        }
        imagePath = [info.merchant.enabledPrinciples componentsJoinedByString:@"-"];
        
    }
    self.paymentMethodLogo.image = [UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    if ([model.status isEqualToString:@"down"]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        self.paymentMethodNameLabel.alpha = 0.4f;
        self.paymentMethodDescriptionLabel.alpha = 0.4f;
        self.paymentMethodLogo.alpha = 0.4;
        self.tscTextStatusLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.61 alpha:1.0];
        self.tscSeparatorLineView.backgroundColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.61 alpha:.65];
        self.tscSeparatorLineView.hidden = NO;
        self.tscTextStatusLabel.hidden = NO;
    } else {
        self.textStatusHeightConstraint.constant = 0;
    }
}

@end
