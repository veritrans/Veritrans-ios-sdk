//
//  VTPaymentListView.h
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "MidtransUIPaymentListFooter.h"
#import "MidtransUIPaymentListHeader.h"
#import "MidtransLoadingView.h"

@class VTPaymentListView;

@protocol VTPaymentListViewDelegate <NSObject>
- (void)paymentListView:(VTPaymentListView *)view didSelectAtIndex:(NSUInteger)index;
@end

@interface VTPaymentListView : UIView

@property (nonatomic) MidtransUIPaymentListFooter *footer;
@property (nonatomic) MidtransUIPaymentListHeader *header;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, weak) id<VTPaymentListViewDelegate>delegate;

- (void)setPaymentMethods:(NSArray *)paymentMethods andItems:(NSArray *)items;

@end
