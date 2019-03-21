//
//  MidtransCreditCardAddOnComponentCell.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddOnConstructor;
@protocol MidtransCreditCardAddOnComponentCellDelegate <NSObject>
- (void)informationButtonDidTappedWithTag:(NSInteger)index;
- (void)checkButton_didTap:(UIButton *)button;
@end
@interface MidtransCreditCardAddOnComponentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *addOnTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *customValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *addOnInformationButton;
@property (weak,nonatomic) id<MidtransCreditCardAddOnComponentCellDelegate>delegate;
- (void)configurePaymentAddOnWithData:(AddOnConstructor *)addOn;
- (void)configurePromoWithData:(AddOnConstructor *)promo;
@end
