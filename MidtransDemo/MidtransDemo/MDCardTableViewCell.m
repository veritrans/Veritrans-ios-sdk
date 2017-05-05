//
//  MidtransSavedCardCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDCardTableViewCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MDCardTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ccImageView;

@end

@implementation MDCardTableViewCell
- (void)configureCard:(MidtransMaskedCreditCard *)maskedCreditCard {
    _maskedCard = maskedCreditCard;
    self.titleLabel.text = maskedCreditCard.maskedNumber;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
