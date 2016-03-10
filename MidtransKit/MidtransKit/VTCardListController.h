//
//  VTCardListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTCardCell.h"
#import <MidtransCoreKit/VTUser.h>

@interface VTCardListController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) VTUser *user;

+ (instancetype)controllerWithUser:(VTUser *)user items:(NSArray *)items;

@end
