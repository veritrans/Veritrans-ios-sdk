//
//  MidtransNewCreditCardView.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardView.h"
#import "MidtransUICardFormatter.h"
#import "VTClassHelper.h"
#import "MidtransUITextField.h"
#import "MidtransUIThemeManager.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransPaymentMethodHeader.h"

@interface MidtransNewCreditCardView()
@property (nonatomic) IBOutlet MidtransPaymentMethodHeader *headerView;
@end

@implementation MidtransNewCreditCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addOnTableView.scrollEnabled = false;
    self.addOnTableView.allowsMultipleSelection = YES;
    self.secureBadgeWrapper.layer.cornerRadius = 3.0f;
    self.secureBadgeWrapper.layer.borderWidth = 1.0f;
    self.secureBadgeWrapper.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.cvvInfoButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    UIImage *image = [[UIImage imageNamed:@"hint" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.cvvInfoButton setImage:image forState:UIControlStateNormal];
    
    UIEdgeInsets insets = self.deleteButton.titleEdgeInsets;
    insets.left = 8;
    self.deleteButton.titleEdgeInsets = insets;
    [self.deleteButton setImage:[self templateImageNamed:@"trash-icon"] forState:UIControlStateNormal];
    self.deleteButton.layer.borderColor = self.deleteButton.tintColor.CGColor;
    self.deleteButton.layer.borderWidth = 1.;
    self.deleteButton.layer.cornerRadius = 5.;
}
- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)configureAmountTotal:(MidtransTransactionTokenResponse *)tokenResponse {
    self.headerView.priceAmountLabel.text = tokenResponse.transactionDetails.grossAmount.formattedCurrencyNumber;
}
- (UIImage *)iconWithBankName:(NSString *)bankName {
    return [UIImage imageNamed:[bankName lowercaseString] inBundle:VTBundle compatibleWithTraitCollection:nil];
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
        [self sendTrackingEvent:@"cc num validation"];
        self.creditCardNumberTextField.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -21) {
        //expiry date invalid
         [self sendTrackingEvent:@"cc expiry validation"];
        self.cardExpireTextField.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -22) {
        //cvv number invalid
         [self sendTrackingEvent:@"cc cvv validation"];
        self.cardCVVNumberTextField.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == MIDTRANS_ERROR_CODE_INVALID_BIN) {
        self.creditCardNumberTextField.warning = UILocalizedString(@"creditcard.error.invalid-bin", nil);
        return YES;
    }
    else {
        return NO;
    }
}
- (void)sendTrackingEvent:(NSString *)eventName {
    [[MIDTrackingManager shared] trackEventName:eventName];
}
@end
