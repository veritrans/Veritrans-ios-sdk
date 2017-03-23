//
//  MDOptionsViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionsViewController.h"
#import "MDOptionView.h"

@interface MDOptionsViewController () <MDOptionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *optionContainer;

@property (nonatomic) NSArray *optionViews;
@property (nonatomic, assign) BOOL animating;
@end

@implementation MDOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo Configuration";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    MDOptionView *opt1 = [MDOptionView viewWithIcon:[UIImage imageNamed:@"cc_click"] titleTemplate:@"%@ Credit Card Payment" options:@[@"Normal", @"Two Clicks", @"One Click"]];
    MDOptionView *opt2 = [MDOptionView viewWithIcon:[UIImage imageNamed:@"3ds"] titleTemplate:@"3D Secure %@d" options:@[@"Enable", @"Disable"]];
    MDOptionView *opt3 = [MDOptionView viewWithIcon:[UIImage imageNamed:@"bank"] titleTemplate:@"Issuing Bank by %@" options:@[@"BNI", @"Mandiri", @"BCA", @"Maybank", @"BRI"]];
    self.optionViews = @[opt1, opt2, opt3];
    
    [self prepareOptionViews:self.optionViews];
    
    NSDictionary *views = @{@"opt1":opt1, @"opt2":opt2, @"opt3":opt3};
    [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[opt1]-0-|" options:0 metrics:0 views:views]];
    [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[opt2]-0-|" options:0 metrics:0 views:views]];
    [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[opt3]-0-|" options:0 metrics:0 views:views]];
    [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[opt1]-0-[opt2]-0-[opt3]-0-|" options:0 metrics:0 views:views]];
}

- (void)prepareOptionViews:(NSArray *)optViews {
    for (MDOptionView *optView in optViews) {
        optView.delegate = self;
        optView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.optionContainer addSubview:optView];
    }
}

- (void)optionView:(MDOptionView *)optionView didHeaderTap:(id)sender {
    if (self.animating)
        return;
    
    self.animating = YES;
    [UIView animateWithDuration:0.25 animations:^{
        for (MDOptionView *optv in self.optionViews) {
            if ([optv isEqual:optionView]) {
                optv.selected = !optv.selected;
            }
            else {
                optv.selected = NO;
            }
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

@end
