//
//  MidtransCreditCardAddOnComponentCell.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransCreditCardAddOnComponentCell.h"
#import "AddOnConstructor.h"
@implementation MidtransCreditCardAddOnComponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.addOnImageView.highlighted = selected;
}
- (void)configurePaymentAddOnWithData:(AddOnConstructor *)addOn {
    self.addOnTitleLabel.text = addOn.addOnTitle;
}
- (IBAction)addOnInformationButtonDIdTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(informationButtonDidTappedWithTag:)]) {
        [self.delegate informationButtonDidTappedWithTag:[sender tag]];
    }
}
@end
