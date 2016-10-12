//
//  VTCardListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTPaymentController.h"

@interface VTCardListController : VTPaymentController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL hideCloseButton;

- (void)presentOnViewController:(UIViewController *)viewController;
@end
