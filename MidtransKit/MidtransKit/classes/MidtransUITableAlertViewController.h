//
//  MidtransTableAlertViewController.h
//  MidtransKit
//
//  Created by Tommy.Yohanes on 9/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransUITableAlertViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate>

- (instancetype)initWithTitle:(NSString *)title
             closeButtonTitle:(NSString *)closeButtonTitle
                     withList:(NSArray*) list;

@end
