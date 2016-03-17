//
//  VTCardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardCell.h"
#import "VTCCFrontView.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/VTCreditCard.h>

@interface VTCardCell ()
@property (nonatomic) IBOutlet VTCCFrontView *frontCardView;
@end

@implementation VTCardCell

- (void)awakeFromNib {
    [_frontCardView.deleteButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    _frontCardView.deleteButton.hidden = !editing;
}

- (void)deletePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cardCellShouldRemoveCell:)]) {
        [self.delegate cardCellShouldRemoveCell:self];
    }
}

- (void)setMaskedCard:(VTMaskedCreditCard *)maskedCard {
    if (!maskedCard) return;
    
    _maskedCard = maskedCard;
    
    _frontCardView.numberLabel.text = [maskedCard.maskedNumber formattedCreditCardNumber];
    
    NSString *iconName = [VTCreditCard typeStringWithNumber:maskedCard.maskedNumber];
    _frontCardView.iconView.image = [UIImage imageNamed:iconName];
    
    _frontCardView.expiryLabel.text = @"XX/XX";
}

@end
