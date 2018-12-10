//
//  MIDCheckoutOption.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MIDCheckoutable <NSObject>

- (NSDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
