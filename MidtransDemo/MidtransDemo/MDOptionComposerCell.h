//
//  MDOptionComposerCell.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 4/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDOption.h"

@class MDOptionComposerCell;

@protocol MDOptionComposerCellDelegate <NSObject>
- (void)optionCell:(MDOptionComposerCell *)cell didEditOption:(MDOption *)option;
@end

@interface MDOptionComposerCell : UITableViewCell
@property (nonatomic) MDOption *option;
@property (nonatomic, weak) id<MDOptionComposerCellDelegate>delegate;
@end
