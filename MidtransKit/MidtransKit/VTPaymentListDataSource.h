//
//  VTPaymentListDataSource.h
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VTPaymentListDataSource : NSObject <UITableViewDataSource>
@property (nonatomic,strong)NSArray *paymentList;
@end
