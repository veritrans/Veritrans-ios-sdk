//
//  VTCardCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransMaskedCreditCard.h>


@protocol MidtransCardCellDelegate;

@interface VTCardCell : UICollectionViewCell
@property (nonatomic) MidtransMaskedCreditCard *maskedCard;
@property (nonatomic, weak) id<MidtransCardCellDelegate>delegate;
@property (nonatomic) BOOL editing;
@end

@protocol MidtransCardCellDelegate <NSObject>
- (void)cardCellShouldRemoveCell:(VTCardCell *)cell;
@end
