//
//  TableViewCell.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransKit/VTPaymentViewController.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) VTItemDetail *item;
@end
