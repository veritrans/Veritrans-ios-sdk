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
@end

@implementation MidtransSavedCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMaskedCard:(MidtransMaskedCreditCard *)maskedCard {
    _maskedCard = maskedCard;

    NSString *cardName = [MidtransCreditCardHelper nameFromString:maskedCard.maskedNumber];
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", cardName, [maskedCard.maskedNumber substringToIndex:4]];
    self.descLabel.text = maskedCard.formattedNumber;
    self.ccImageView.image = maskedCard.darkIcon;
}

- (void)setHavePromo:(BOOL)havePromo {
    _havePromo = havePromo;
    self.promoImageView.image = havePromo? [UIImage imageNamed:@"ccOfferIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]:nil;
}

@end
