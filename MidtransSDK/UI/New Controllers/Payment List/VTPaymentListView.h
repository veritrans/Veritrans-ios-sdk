//
//  VTPaymentListView.h
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransLoadingView.h"
#import "MidtransPaymentMethodHeader.h"

#import "MidtransSDK.h"

@class VTPaymentListView,MidtransPaymentRequestV2Response;

@protocol VTPaymentListViewDelegate <NSObject>
- (void)paymentListView:(VTPaymentListView *)view didSelectModel:(MidtransPaymentListModel *)model;
@end

@interface VTPaymentListView : UIView

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, weak) id<VTPaymentListViewDelegate>delegate;
@property (nonatomic) MidtransPaymentMethodHeader *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *secureBadgeImage;

- (void)setPaymentInfo:(MIDPaymentInfo *)info;

@end
