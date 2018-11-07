//
//  MIDTrackingManager.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNPUITrackingManager : NSObject
+ (SNPUITrackingManager *)shared;
- (void)trackEventName:(NSString *)eventName;
- (void)trackEventName:(NSString *)eventName additionalParameters:(NSDictionary *)additionalParameters;
@end
