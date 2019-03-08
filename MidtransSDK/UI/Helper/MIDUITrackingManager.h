//
//  MIDTrackingManager.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDUITrackingManager : NSObject
+ (MIDUITrackingManager *)shared;
- (void)trackEventName:(NSString *)eventName;
- (void)trackEventName:(NSString *)eventName additionalParameters:(NSDictionary *)additionalParameters;
@end

@interface NSDictionary (parse)

- (NSString *)queryStringValue;
- (NSArray *)pairsOfArray:(NSArray *)values key:(NSString *)key;

@end
