//
//  MDCardTableViewCell.h
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransMaskedCreditCard;
@interface MDCardTableViewCell : UITableViewCell
@property (nonatomic,strong) MidtransMaskedCreditCard *maskedCard;
- (void)configureCard:(NSDictionary *)maskedCreditCard;
@end
