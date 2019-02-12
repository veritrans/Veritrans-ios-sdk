//
//  MidtransPaymentMethodHeader.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransPaymentMethodHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic) IBOutlet UILabel *priceAmountLabel;
@end
