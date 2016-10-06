//
//  TableViewCell.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransKit/MidtransUIPaymentViewController.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) MidtransItemDetail *item;
@end
