//
//  MDOptionView.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDOption) {
    MDOptionPaymentType,
    MDOption3DSecure,
    MDOptionIssuingBank,
    MDOptionSaveCard,
    MDOptionPromo,
    MDOptionPreauth,
    MDOptionColorTheme,
    MDOptionCustomExpiry
};

@class MDOptionView;

@protocol MDOptionViewDelegate <NSObject>
- (void)optionView:(MDOptionView *)optionView didHeaderTap:(id)sender;
- (void)optionView:(MDOptionView *)optionView didOptionSelect:(NSString *)option;
@end

@interface MDOptionView : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) MDOption optionType;
@property (nonatomic, weak) id<MDOptionViewDelegate>delegate;

+ (instancetype)viewWithIcon:(UIImage *)icon
               titleTemplate:(NSString *)titleTemplate
                     options:(NSArray <NSString*>*)options
               defaultOption:(NSString *)defaultOption
               isColorOption:(BOOL)isColorOption;
+ (instancetype)viewWithIcon:(UIImage *)icon
               titleTemplate:(NSString *)titleTemplate
                     options:(NSArray <NSString*>*)options
               defaultOption:(NSString *)defaultOption;
@end
