//
//  MIdtransUICardCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransMaskedCreditCard.h>


@protocol MidtransUICardCellDelegate;

@interface MIdtransUICardCell : UICollectionViewCell
@property (nonatomic) MidtransMaskedCreditCard *maskedCard;
@property (nonatomic, weak) id<MidtransUICardCellDelegate>delegate;
@property (nonatomic) BOOL editing;
@end

@protocol MidtransUICardCellDelegate <NSObject>
- (void)cardCellShouldRemoveCell:(MIdtransUICardCell *)cell;
@end
