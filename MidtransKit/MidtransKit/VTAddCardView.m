//
//  VTAddCardView.m
//  MidtransKit
//
//  Created by Arie on 7/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddCardView.h"
#import "MidtransUICardFormatter.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"
#import <IHKeyboardAvoiding_vt.h>

CGFloat const ScanButtonHeight = 45;

@interface VTAddCardView()<UITextFieldDelegate, MidtransUICardFormatterDelegate>
@property (weak, nonatomic) IBOutlet UIButton *scanCardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanCardHeight;
@end

@implementation VTAddCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.saveCardSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    self.scanCardButton.layer.cornerRadius = 2.0f;
    
    self.infoButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    switch ([MidtransCreditCardHelper typeFromString:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCardDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"AmexDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}

- (UIImage *)iconWithNumber:(NSString *)number {
    switch ([MidtransCreditCardHelper typeFromString:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"Visa" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCB" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"Amex" inBundle:VTBundle compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}

- (BOOL)isViewableError:(NSError *)error {
    if (error.code == -20) {
        //number invalid
        self.cardNumber.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -21) {
        //expiry date invalid
        self.cardExpiryDate.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -22) {
        //cvv number invalid
        self.cardCvv.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == MIDTRANS_ERROR_CODE_INVALID_BIN) {
        self.cardNumber.warning = UILocalizedString(@"creditcard.error.invalid-bin", nil);
        return YES;
    }
    else {
        return NO;
    }
}


- (void)setToken:(MidtransTransactionTokenResponse *)token {
    self.amountLabel.text = token.transactionDetails.grossAmount.formattedCurrencyNumber;
}

- (void)hideScanCardButton:(BOOL)hide {
    if (hide) {
        self.scanCardButton.hidden = YES;
        self.scanCardHeight.constant = 0;
    }
    else {
        self.scanCardButton.hidden = NO;
        self.scanCardHeight.constant = ScanButtonHeight;
    }
}

@end
