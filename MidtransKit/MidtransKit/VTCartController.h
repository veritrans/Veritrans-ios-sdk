//
//  VTCartController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTUser.h>

@interface VTCartController : UIViewController
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) VTUser *user;

+ (instancetype)cartWithUser:(VTUser *)user andItems:(NSArray *)items;
@end
