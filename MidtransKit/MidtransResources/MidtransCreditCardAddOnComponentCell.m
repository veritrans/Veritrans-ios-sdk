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
    self.addOnImageView.tintColor = [[MidtransUIThemeManager shared] themeColor];
    
    [self.addOnInformationButton setImage:[self templateImageNamed:@"hint"] forState:UIControlStateNormal];
    self.addOnImageView.highlightedImage = [self templateImageNamed:@"checkbox_checked"];
    self.addOnImageView.image = [self templateImageNamed:@"checkbox_uncheck"];
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

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
@end
