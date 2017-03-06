//
//  MidtransUIListCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIListCell.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransPaymentListModel.h>

@implementation MidtransUIListCell

- (void)configurePaymetnList:(MidtransPaymentListModel *)paymentList {
    self.paymentMethodNameLabel.text = paymentList.title;
    self.paymentMethodDescriptionLabel.text = paymentList.internalBaseClassDescription;
      NSString *imagePath =[NSString stringWithFormat:@"%@",paymentList.internalBaseClassIdentifier];
    if ([paymentList.internalBaseClassIdentifier isEqualToString:@"echannel"]) {
        imagePath = @"mandiri_va";
    }
    else if ([paymentList.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
    self.paymentMethodNameLabel.text = @"Credit/Debit Card";
    }

    self.paymentMethodLogo.image = [UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
