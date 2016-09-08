//
//  VTCardListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTCardCell.h"
#import "MidtransUIPaymentController.h"

@interface VTCardListController : MidtransUIPaymentController
@property (nonatomic) MidtransMaskedCreditCard *selectedMaskedCard;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
