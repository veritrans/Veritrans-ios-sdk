//
//  MidtransPaymentCCAddOnDataSource.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MidtransPaymentCCAddOnDataSource : NSObject <UITableViewDataSource>
@property (strong, nonatomic) NSArray *paymentAddOnArray;
@end
