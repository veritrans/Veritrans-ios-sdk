//
//  VTPaymentListView.h
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTPaymentListFooter.h"
#import "VTPaymentListHeader.h"
@interface VTPaymentListView : UIView
@property (nonatomic) VTPaymentListFooter *footer;
@property (nonatomic) VTPaymentListHeader *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
