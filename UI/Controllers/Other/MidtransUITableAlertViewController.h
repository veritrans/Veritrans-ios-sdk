//
//  MidtransTableAlertViewController.h
//  MidtransKit
//
//  Created by Tommy.Yohanes on 9/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MTOtherBankType) {
    MTOtherBankTypeATMBersama,
    MTOtherBankTypePrima,
    MTOtherBankTypeAlto
};

@interface MidtransUITableAlertViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate>

- (instancetype)initWithType:(MTOtherBankType) type;

@end
