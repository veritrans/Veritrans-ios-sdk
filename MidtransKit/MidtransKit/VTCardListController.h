//
//  VTCardListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTCardCell.h"
#import "VTPaymentController.h"

@interface VTCardListController : VTPaymentController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
