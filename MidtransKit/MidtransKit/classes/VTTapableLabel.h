//
//  VTTapableLabel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const VTTapableLabelDidTapLink = @"VTTapableLabelDidTapLink";

@interface VTTapableLabel : UILabel
@property (nonatomic) NSString *tapableText;
@end
