//
//  SNPAccordion.h
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SNPAccordion;
@protocol OCBorghettiViewDelegate <NSObject>
- (void)accordion:(SNPAccordion *)accordion
   willSelectView:(UIView *)view
        withTitle:(NSString *)title
          andIcon:(UIImage *)icon;
- (BOOL)accordion:(SNPAccordion *)accordion
 shouldSelectView:(UIView *)view
        withTitle:(NSString *)title
          andIcon:(UIImage *)icon;
- (void)accordion:(SNPAccordion *)accordion
    didSelectView:(UIView *)view
        withTitle:(NSString *)title
          andIcon:(UIImage *)icon;
@end;
@interface SNPAccordion :UIView
- (void)addSectionWithTitle:(NSString *)sectionTitle
                    andView:(id)sectionView
                    andIcon:(UIImage *)icon;

/**
 Sets the active section.
 */
@property (nonatomic, assign) NSInteger activeSection;

/**
 Sets section header height.
 */
@property (nonatomic, assign) NSInteger headerHeight;

/**
 Sets section header font.
 */
@property (nonatomic, strong) UIFont *headerFont;

/**
 Sets section header font color.
 */
@property (nonatomic, strong) UIColor *headerTitleColor;

/**
 Sets section header background color.
 */
@property (nonatomic, strong) UIColor *headerColor;

/**
 Sets section header border color.
 
 @warning Section title border is not visible by default. Set a color to display it.
 */
@property (nonatomic, strong) UIColor *headerBorderColor;

@property (nonatomic,strong) UIImage *iconImage;
/**
 Sets the delegate.
 
 @see OCBorghettiViewDelegate protocol
 */
@property (nonatomic, weak) id <OCBorghettiViewDelegate> delegate;


@end
