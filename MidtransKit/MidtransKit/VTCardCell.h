//
//  VTCardCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTMaskedCreditCard.h>


@protocol VTCardCellDelegate;

@interface VTCardCell : UICollectionViewCell
@property (nonatomic) VTMaskedCreditCard *maskedCard;
@property (nonatomic, assign) id<VTCardCellDelegate>delegate;
@end

@protocol VTCardCellDelegate <NSObject>
- (void)cardCellShouldRemoveCell:(VTCardCell *)cell;
@end
