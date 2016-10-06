//
//  VTPaymentStatusXLTunaiViewModel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusViewModel.h"

@interface VTPaymentStatusXLTunaiViewModel : VTPaymentStatusViewModel
@property (nonatomic, readonly) NSString *xlOrderID;
@property (nonatomic, readonly) NSString *xlMerchantID;
@property (nonatomic, readonly) NSString *xlExpiration;
@end
