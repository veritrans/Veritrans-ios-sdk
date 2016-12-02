//
//  MidtransUIConfiguration.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define UICONFIG ((MidtransUIConfiguration*)[MidtransUIConfiguration shared])

#import <Foundation/Foundation.h>

@interface MidtransUIConfiguration : NSObject
@property (nonatomic, assign) BOOL hideStatusPage;
+ (MidtransUIConfiguration *_Nonnull)shared;
@end
