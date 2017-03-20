//
//  AcquiringBankTableViewController.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcquiringBankTableViewControllerDelegate <NSObject>

- (void)didSelectAcquiringBank:(NSDictionary *)acquiringBank;

@end

@interface AcquiringBankTableViewController : UITableViewController
@property (nonatomic, weak) id<AcquiringBankTableViewControllerDelegate>delegate;
@end
