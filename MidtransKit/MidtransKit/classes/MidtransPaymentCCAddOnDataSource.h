//
//  MidtransPaymentCCAddOnDataSource.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol MidtransPaymentCCAddOnDataSourceDelegate <NSObject>
- (void)informationButtonDidTappedWithTag:(NSInteger)index;
@end

@interface MidtransPaymentCCAddOnDataSource : NSObject <UITableViewDataSource>
@property (strong, nonatomic) NSArray *paymentAddOnArray;
@property (weak,nonatomic) id<MidtransPaymentCCAddOnDataSourceDelegate>delegate;
@end
