//
//  VTAddCardView.m
//  MidtransKit
//
//  Created by Arie on 7/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddCardView.h"
#import "MidtransUICardFormatter.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"

#import <IHKeyboardAvoiding_vt.h>

CGFloat const ScanButtonHeight = 45;

@interface VTAddCardView()<MidtransUICardFormatterDelegate>
@property (weak, nonatomic) IBOutlet UIButton *scanCardButton;
@property (weak, nonatomic) IBOutlet UIButton *installmentNextButton;
@property (weak, nonatomic) IBOutlet UIButton *installmentPrevButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanCardHeight;
@end

@implementation VTAddCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.installmentCollectionView.userInteractionEnabled = NO;
    self.installmentCollectionView.layer.cornerRadius = 2.0f;
    self.installmentCollectionView.layer.masksToBounds = YES;
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
    
}


@end
