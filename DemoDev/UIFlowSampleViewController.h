//
//  UIFlowSampleViewController.h
//  VTDirectDemo
//
//  Created by Vanbungkring on 12/21/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransCustomerDetails;
@interface UIFlowSampleViewController : UIViewController
@property (nonatomic,strong) NSNumber *totalAmountTobePaid;
@property (nonatomic,strong) MidtransCustomerDetails *customerDetails;
@end
