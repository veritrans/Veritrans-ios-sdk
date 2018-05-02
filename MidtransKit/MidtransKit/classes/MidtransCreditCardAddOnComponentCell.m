//
//  MidtransCreditCardAddOnComponentCell.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransCreditCardAddOnComponentCell.h"
#import "AddOnConstructor.h"
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"

@implementation MidtransCreditCardAddOnComponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
    self.addOnInformationButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    self.checkButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    
    [self.addOnInformationButton setImage:[self templateImageNamed:@"hint"] forState:UIControlStateNormal];
    
    [self.checkButton setBackgroundImage:[self templateImageNamed:@"checkbox_uncheck"] forState:UIControlStateNormal];
    [self.checkButton setBackgroundImage:[self templateImageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)configurePromoWithData:(AddOnConstructor *)promo {
   self.addOnTitleLabel.text = promo.addOnTitle;
    self.addOnInformationButton.hidden = YES;
    self.customValueLabel.text =  [NSNumber numberWithInt:[promo.addOnDescriptions intValue]].formattedCurrencyNumber;
}
- (void)configurePaymentAddOnWithData:(AddOnConstructor *)addOn {
    self.customValueLabel.hidden = YES;
    self.addOnTitleLabel.text = addOn.addOnTitle;
}
- (IBAction)addOnInformationButtonDIdTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(informationButtonDidTappedWithTag:)]) {
        [self.delegate informationButtonDidTappedWithTag:[sender tag]];
    }
}

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
@end
