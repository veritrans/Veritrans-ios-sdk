//
//  VTCardCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTCreditCard.h>

typedef NS_ENUM(NSUInteger, CardPageState) {
    CardPageStateFront,
    CardPageStateBack
};

@protocol VTCardCellDelegate;

@interface VTCardCell : UICollectionViewCell
@property (nonatomic) IBOutlet UIView *frontCardView;
@property (nonatomic) IBOutlet UIView *backCardView;
@property (nonatomic) VTCreditCard *creditCard;
@property (nonatomic, assign) id<VTCardCellDelegate>delegate;
@end

@protocol VTCardCellDelegate <NSObject>
- (void)cardCellShouldRemoveCell:(VTCardCell *)cell;
- (void)cardCell:(VTCardCell *)cell didChangePage:(CardPageState)pageState duration:(NSTimeInterval)duration;
- (void)cardCell:(VTCardCell *)cell willChangePage:(CardPageState)pageState duration:(NSTimeInterval)duration;
@end
