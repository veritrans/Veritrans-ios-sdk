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

@interface VTAddCardView()<UITextFieldDelegate, MidtransUICardFormatterDelegate>

@end

@implementation VTAddCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.cardNumber];
    self.ccFormatter.delegate = self;
    self.ccFormatter.numberLimit = 16;
    self.scanCardButton.layer.cornerRadius = 2.0f;
    self.cardNumber.delegate = self;
    self.cardExpiryDate.delegate = self;
    self.cardCvv.delegate = self;
    
    self.infoButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
    
    [self.cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
}

- (void)dealloc {
    [self.cardExpiryDate removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:self.cardExpiryDate]) {
        self.cardFrontView.expiryLabel.text = self.cardExpiryDate.text;
    }
    else if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:self.cardNumber]) {
        self.cardFrontView.expiryLabel.text = self.cardExpiryDate.text;
    }
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

- (void)setToken:(MidtransTransactionTokenResponse *)token {
    self.amountLabel.text = token.transactionDetails.grossAmount.formattedCurrencyNumber;
}

- (BOOL)isViewError:(NSError *)error {
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
    else {
        return NO;
    }
}



#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    if (self.cardNumber.text.length < 1) {
        self.cardFrontView.numberLabel.text = @"XXXX XXXX XXXX XXXX";
        self.cardFrontView.iconView.image = nil;
        self.cardNumber.infoIcon = nil;
    }
    else {
        self.cardFrontView.numberLabel.text = self.cardNumber.text;
        NSString *originNumber = [self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.cardNumber.infoIcon = [self iconDarkWithNumber:originNumber];
        self.cardFrontView.iconView.image = [self iconWithNumber:originNumber];
    }
}

@end
