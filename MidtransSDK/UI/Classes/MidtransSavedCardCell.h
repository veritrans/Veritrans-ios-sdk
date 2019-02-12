//
//  MidtransSavedCardCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransSavedCardCell : UITableViewCell
@property (nonatomic) MidtransMaskedCreditCard *maskedCard;
@property (nonatomic) NSString *bankName;
@property (nonatomic, assign) BOOL havePromo;
@end
