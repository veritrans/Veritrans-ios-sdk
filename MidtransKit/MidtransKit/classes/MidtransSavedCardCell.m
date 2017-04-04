//
//  MidtransSavedCardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransSavedCardCell.h"
#import "VTClassHelper.h"

@interface MidtransSavedCardCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *promoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ccImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ccToBankPadding;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bankToPromoPadding;
@end

@implementation MidtransSavedCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMaskedCard:(MidtransMaskedCreditCard *)maskedCard {
    _maskedCard = maskedCard;

    self.descLabel.text = maskedCard.formattedNumber;
    self.ccImageView.image = maskedCard.darkIcon;
    
    [self updateTitle];
}

- (void)setHavePromo:(BOOL)havePromo {
    _havePromo = havePromo;
    self.promoImageView.image = havePromo? [UIImage imageNamed:@"ccOfferIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]:nil;
    
    self.bankToPromoPadding.constant = havePromo? 8:0;
}

- (void)setBankName:(NSString *)bankName {
    _bankName = bankName;
    
    self.bankImageView.image = [UIImage imageNamed:[bankName lowercaseString] inBundle:VTBundle compatibleWithTraitCollection:nil];
    
    [self updateTitle];
    
    self.ccToBankPadding.constant = bankName.length? 8:0;
}

- (void)updateTitle {
    NSString *cardName = [MidtransCreditCardHelper nameFromString:self.maskedCard.maskedNumber];
    self.titleLabel.text = cardName;
    if (self.bankName) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", cardName, [self.bankName uppercaseString]];
    }
}

@end
