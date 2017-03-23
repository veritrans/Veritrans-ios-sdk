//
//  MDOptionView.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDOptionView;

@protocol MDOptionViewDelegate <NSObject>
- (void)optionView:(MDOptionView *)optionView didHeaderTap:(id)sender;
@end

@interface MDOptionView : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic) id selectedOption;
@property (nonatomic, weak) id<MDOptionViewDelegate>delegate;

+ (instancetype)viewWithIcon:(UIImage *)icon titleTemplate:(NSString *)titleTemplate options:(NSArray <NSString*>*)options;
@end
