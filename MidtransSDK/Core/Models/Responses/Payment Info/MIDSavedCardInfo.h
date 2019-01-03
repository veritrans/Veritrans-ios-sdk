//
//  MIDSavedCard.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 27/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDSavedCardInfo : NSObject<MIDMappable>

@property (nonatomic) NSString *token;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *maskedCard;
@property (nonatomic) NSString *expireDate;

@end

NS_ASSUME_NONNULL_END
