//
//  MDOptionView.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDOption.h"

@class MDOptionView;

@protocol MDOptionViewDelegate <NSObject>
- (void)optionView:(MDOptionView *)optionView didTapHeader:(id)sender;
- (void)optionView:(MDOptionView *)optionView didTapOption:(MDOption *)option;
- (void)optionView:(MDOptionView *)optionView didTapComposerOption:(MDOption *)option;
- (void)optionView:(MDOptionView *)optionView didTapEditComposerOption:(MDOption *)option;
@end

@interface MDOptionView : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic) NSArray <MDOption*>*options;
@property (nonatomic, weak) id<MDOptionViewDelegate>delegate;

+ (MDOptionView *)viewWithIcon:(UIImage *)icon
                 titleTemplate:(NSString *)titleTemplate
                       options:(NSArray <MDOption*>*)options
                    identifier:(NSString *)identifier;

- (void)selectOptionAtIndex:(NSInteger)index;
- (void)resetOptionView;
@end
