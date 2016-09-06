//
//  VTCCFrontView.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTXibView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTCCFrontView : VTXibView

- (instancetype)initWithFrame:(CGRect)frame maskedCard:(MidtransMaskedCreditCard *)maskedCard;

@property (nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) IBOutlet UILabel *expiryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@end
