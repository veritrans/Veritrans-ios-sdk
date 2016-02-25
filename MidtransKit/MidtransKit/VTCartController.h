//
//  VTCartController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTCartController : UIViewController
@property (nonatomic, readonly) NSArray *items;

+ (instancetype)cartWithItems:(NSArray *)items;
@end
