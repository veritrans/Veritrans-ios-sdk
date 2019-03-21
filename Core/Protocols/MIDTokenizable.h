//
//  MIDTokenizable.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 06/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MIDTokenizable <NSObject>
- (NSDictionary *)dictionaryValue;
@end

NS_ASSUME_NONNULL_END
