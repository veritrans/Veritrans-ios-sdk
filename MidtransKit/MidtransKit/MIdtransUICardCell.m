//
//  MIdtransUICardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransUICardCell.h"
#import "MidtransUICCFrontView.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCreditCard.h>
#import <MidtransCoreKit/MidtransCreditCardHelper.h>

@interface MIdtransUICardCell ()
@property (nonatomic) IBOutlet MidtransUICCFrontView *frontCardView;
@end

@implementation MIdtransUICardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.frontCardView.deleteButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    self.frontCardView.deleteButton.hidden = !editing;
}

- (void)deletePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cardCellShouldRemoveCell:)]) {
        [self.delegate cardCellShouldRemoveCell:self];
    }
}

- (void)setMaskedCard:(MidtransMaskedCreditCard *)maskedCard {
    _maskedCard = maskedCard;
    
    self.frontCardView.numberLabel.text = [maskedCard.maskedNumber formattedCreditCardNumber];
    
    NSString *iconName = [MidtransCreditCardHelper nameFromString:maskedCard.maskedNumber];
    self.frontCardView.iconView.image = [UIImage imageNamed:iconName inBundle:VTBundle compatibleWithTraitCollection:nil];
    
    self.frontCardView.expiryLabel.text = @"XX/XX";
}

@end
