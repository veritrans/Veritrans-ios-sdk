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

/**
 DidYouKnowView is a view that contains confirmation about Midtrans secure payment
 */
@property (nonatomic, assign) BOOL hideDidYouKnowView;

+ (MidtransUIConfiguration *_Nonnull)shared;
@end
