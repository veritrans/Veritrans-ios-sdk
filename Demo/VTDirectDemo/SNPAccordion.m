//
//  SNPAccordion.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPAccordion.h"

@interface SNPAccordion ()
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) BOOL shouldAnimate;
@property (nonatomic, assign) BOOL hasBorder;
@end

@implementation SNPAccordion
@synthesize headerBorderColor = _headerBorderColor;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
        [self initSNPAccordion];
    
    return self;
}

- (void)initSNPAccordion {
    self.views = [NSMutableArray new];
    self.sections = [NSMutableArray new];
    
    self.headerHeight = 30;
    self.headerColor = [UIColor blackColor];
    self.headerFont = [UIFont fontWithName:@"SourceSans-Pro" size:16];
    self.headerTitleColor = [UIColor whiteColor];
    self.headerBorderColor = [UIColor lightGrayColor];
    self.headerTitleActiveColor = [UIColor colorWithRed:0.18 green:0.50 blue:0.76 alpha:1.0];
    self.hasBorder = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.shouldAnimate = NO;
}

#pragma mark Add Section and View

- (void)addSectionWithTitle:(NSString *)sectionTitle
                    andView:(id)sectionView andIcon:(UIImage *)icon {
    UIButton *section = [[UIButton alloc] init];
    
    [section setBackgroundColor:self.headerColor];
    [section setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [section setAutoresizesSubviews:YES];
    [section setAdjustsImageWhenHighlighted:NO];
    [section setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [section setTitle:sectionTitle forState:UIControlStateNormal];
    [section.titleLabel setFont:self.headerFont];
    section.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 30, 0.0f,0);
    section.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 30, 0.0f, 0);
    UIImageView *imageLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageLeftView.contentMode = UIViewContentModeScaleAspectFit;
    [section addSubview:imageLeftView];
    [imageLeftView setImage:icon];
    [section setTitleColor:self.headerTitleColor
                  forState:UIControlStateNormal];
    
    [sectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [sectionView setAutoresizesSubviews:YES];
    
    [self.sections addObject:section];
    [self.views addObject:sectionView];
    
    [self addSubview:section];
    [self addSubview:sectionView];
    
    [section setTag:self.sections.count - 1];
    imageLeftView.tag = self.sections.count - 1;
    [section addTarget:self
                action:@selector(sectionSelected:)
      forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Setter

- (void)setHeaderBorderColor:(UIColor *)accordionSectionBorderColor
{
    _headerBorderColor = accordionSectionBorderColor;
    self.hasBorder = YES;
}

- (void)setActiveSection:(NSInteger)accordionActiveSection {
    if (accordionActiveSection >= 0 && accordionActiveSection < self.sections.count) {
        if ([self.delegate respondsToSelector:@selector(accordion:willSelectView:withTitle:andIcon:)]) {
            [self.delegate accordion:self
                      willSelectView:self.views[accordionActiveSection]
                           withTitle:[[self.sections[accordionActiveSection] titleLabel] text] andIcon:nil];
        }
        
        if ([self.delegate respondsToSelector:@selector(accordion:shouldSelectView:withTitle:andIcon:)] &&
            [self.delegate accordion:self
                    shouldSelectView:self.views[accordionActiveSection]
                           withTitle:[[self.sections[accordionActiveSection] titleLabel] text] andIcon:nil] == NO) return;
        
        _activeSection = accordionActiveSection;
        [self setNeedsLayout];
        
        if ([self.delegate respondsToSelector:@selector(accordion:didSelectView:withTitle:andIcon:)]) {
            [self.delegate accordion:self
                       didSelectView:self.views[self.activeSection]
                           withTitle:[[self.sections[self.activeSection] titleLabel] text] andIcon:nil];
        }
    }
}

#pragma mark - Private
- (void)sectionSelected:(id)sender
{
    self.activeSection = [sender tag];
}

- (void)didAddSubview:(UIView *)subview
{
    if (![subview isKindOfClass:[UIButton class]])
        self.numberOfSections += 1;
}

- (void)layoutSubviews {
    int height = 0;
    
    for (int i = 0; i < self.views.count; i++) {
        UIButton *sectionTitle = self.sections[i];
        id sectionView = self.views[i];
        
        CGRect sectionTitleFrame = [sectionTitle frame];
        sectionTitleFrame.origin.x = 0;
        sectionTitleFrame.size.width = self.frame.size.width;
        sectionTitleFrame.size.height = self.headerHeight;
        [sectionTitle setFrame:sectionTitleFrame];
        
        [sectionTitle setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -5.0f, 0.0f, 0.0f)];
        [sectionTitle setImageEdgeInsets:UIEdgeInsetsMake(0.0f, self.frame.size.width - 25.0f , 0.0f, 0.0f)];
        
        CGRect sectionViewFrame = [sectionView frame];
        sectionViewFrame.origin.x = 0;
        sectionViewFrame.size.width = self.frame.size.width;
        sectionViewFrame.size.height = (self.frame.size.height - (self.numberOfSections * self.headerHeight));
        [sectionView setFrame:sectionViewFrame];
        
        sectionTitleFrame.origin.y = height;
        height += sectionTitleFrame.size.height;
        sectionViewFrame.origin.y = height;
        
        if (self.activeSection == i) {
            [sectionTitle setImage:[UIImage imageNamed:@"arrow_up"]
                          forState:UIControlStateNormal];
            
            sectionViewFrame.size.height = (self.frame.size.height - (self.numberOfSections * self.headerHeight));
            [sectionTitle setTitleColor:self.headerTitleActiveColor forState:UIControlStateNormal];
            [sectionView setFrame:CGRectMake(0, sectionViewFrame.origin.y, self.frame.size.width, 0)];
            
            if ([sectionView respondsToSelector:@selector(setScrollsToTop:)])
                [sectionView setScrollsToTop:YES];
        } else {
            [sectionTitle setImage:[UIImage imageNamed:@"arrow_down"]
                          forState:UIControlStateNormal];
            [sectionTitle setTitleColor:self.headerTitleColor forState:UIControlStateNormal];
            sectionViewFrame.size.height = 0;
            
            if ([sectionView respondsToSelector:@selector(setScrollsToTop:)])
                [sectionView setScrollsToTop:NO];
        }
        
        [self processBorder:sectionTitle atIndex:i];
        
        height += sectionViewFrame.size.height;
        
        if ([sectionView respondsToSelector:@selector(setClipsToBounds:)])
            [sectionView setClipsToBounds:YES];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.shouldAnimate ? 0.1f : 0.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [sectionTitle setFrame:sectionTitleFrame];
        [sectionView setFrame:sectionViewFrame];
        [UIView commitAnimations];
    }
    
    self.shouldAnimate = YES;
}

- (void)processBorder:(UIButton *)sectionTitle
              atIndex:(NSInteger)index
{
    if (self.hasBorder) {
        if (index > 0) {
            UIView *topBorder = [[UIView alloc] init];
            topBorder.frame = CGRectMake(0.0f, 0.0f, sectionTitle.frame.size.width, 1.5f);
            topBorder.backgroundColor = self.headerBorderColor;
            topBorder.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            if (sectionTitle.subviews.count < 3) [sectionTitle addSubview:topBorder];
        }
    }
}


@end
