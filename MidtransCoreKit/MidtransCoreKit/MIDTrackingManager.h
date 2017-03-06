//
//  MIDTrackingManager.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDTrackingManager : NSObject
+ (MIDTrackingManager *)shared;
- (void)trackEventName:(NSString *)eventName;

@end
