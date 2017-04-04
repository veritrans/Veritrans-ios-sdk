//
//  MDOptionsViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionsViewController.h"
#import "MDOptionView.h"
#import "MDProductViewController.h"
#import "MDOptionManager.h"
#import "MDUtils.h"
#import <MidtransKit/MidtransKit.h>

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
    
    MDOptionView *optType = [MDOptionView viewWithIcon:[UIImage imageNamed:@"cc_click"]
                                         titleTemplate:@"%@ Credit Card Payment"
                                               options:@[@"Normal", @"Two Clicks", @"One Click"]
                                                  type:MDOptionPaymentType];
    [optType selectOption:[MDOptionManager shared].ccTypeOption];
    
    MDOptionView *opt3ds = [MDOptionView viewWithIcon:[UIImage imageNamed:@"3ds"]
                                        titleTemplate:@"3D Secure %@d"
                                              options:@[@"Enable", @"Disable"]
                                                 type:MDOption3DSecure];
    [opt3ds selectOption:[MDOptionManager shared].secure3DOption];
    
    MDOptionView *optAcqBank = [MDOptionView viewWithIcon:[UIImage imageNamed:@"bank"]
                                            titleTemplate:@"Issuing Bank by %@"
                                                  options:@[@"BNI", @"Mandiri", @"BCA", @"Maybank", @"BRI"]
                                                     type:MDOptionIssuingBank];
    [optAcqBank selectOption:[MDOptionManager shared].issuingBankOption];
    
    MDOptionView *optCustomExpiry = [MDOptionView viewWithIcon:[UIImage imageNamed:@"expiry"]
                                                 titleTemplate:@"%@"
                                                       options:@[@"No Expiry", @"1 Minute", @"1 Hour"]
                                                          type:MDOptionCustomExpiry];
    [optCustomExpiry selectOption:[MDOptionManager shared].expireTimeOption];
    
    MDOptionView *optSaveCard = [MDOptionView viewWithIcon:[UIImage imageNamed:@"save_card"]
                                             titleTemplate:@"Save Card Feature %@d"
                                                   options:@[@"Enable", @"Disable"]
                                                      type:MDOptionSaveCard];
    [optSaveCard selectOption:[MDOptionManager shared].saveCardOption];
    
    MDOptionView *optPromo = [MDOptionView viewWithIcon:[UIImage imageNamed:@"promo"]
                                          titleTemplate:@"Promo %@d"
                                                options:@[@"Enable", @"Disable"]
                                                   type:MDOptionPromo];
    [optPromo selectOption:[MDOptionManager shared].promoOption];
    
    MDOptionView *optPreauth = [MDOptionView viewWithIcon:[UIImage imageNamed:@"preauth"]
                                            titleTemplate:@"Pre Auth Feature %@d"
                                                  options:@[@"Enable", @"Disable"]
                                                     type:MDOptionPreauth];
    [optPreauth selectOption:[MDOptionManager shared].preauthOption];
    
    MDOptionView *optTheme = [MDOptionView viewWithIcon:[UIImage imageNamed:@"theme"]
                                          titleTemplate:@"%@ Color Theme"
                                                options:@[@"Blue", @"Red", @"Green", @"Orange", @"Black"]
                                                   type:MDOptionColorTheme
                                          isColorOption:YES];
    [optTheme selectOption:[MDOptionManager shared].colorOption];
    
    self.optionViews = @[
                         optType,
                         opt3ds,
                         optAcqBank,
                         optCustomExpiry,
                         optSaveCard,
                         optPromo,
                         optPreauth,
                         optTheme
                         ];
    
    [self prepareOptionViews:self.optionViews];
    
    defaults_observe_object(@"md_cc_type", ^(id note){
        MTCreditCardPaymentType type = [note unsignedIntegerValue];
        MDOptionView *opt3ds = [self optionViewWithType:MDOption3DSecure];
        MDOptionView *optSaveCard = [self optionViewWithType:MDOptionSaveCard];
        if (type == MTCreditCardPaymentTypeOneclick) {
            [opt3ds selectOption:@"Enable"];
            [optSaveCard selectOption:@"Enable"];
        }
        else if (type == MTCreditCardPaymentTypeTwoclick) {
            [optSaveCard selectOption:@"Enable"];
        }
    });
}

- (void)prepareOptionViews:(NSArray *)optViews {
    NSMutableDictionary *views = [NSMutableDictionary new];
    NSMutableString *constraintFormat = [NSMutableString stringWithString:@"V:|"];
    
    int i = 0;
    for (MDOptionView *optView in optViews) {
        optView.delegate = self;
        optView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.optionContainer addSubview:optView];
        [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[opt]-0-|"
                                                                                     options:0
                                                                                     metrics:0
                                                                                       views:@{@"opt":optView}]];
        
        NSString *optKey = [NSString stringWithFormat:@"opt%i", i];
        [constraintFormat appendString:[NSString stringWithFormat:@"-0-[%@]", optKey]];
        [views setObject:optView forKey:optKey];
        i++;
    }
    [constraintFormat appendString:@"-0-|"];
    
    [self.optionContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormat
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:views]];
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

- (void)optionView:(MDOptionView *)optionView didOptionSelect:(NSString *)option {
    switch (optionView.optionType) {
        case MDOptionColorTheme:
            [MDOptionManager shared].colorOption = option;
            break;
        case MDOptionPreauth:
            [MDOptionManager shared].preauthOption = option;
            break;
        case MDOptionPromo:
            [MDOptionManager shared].promoOption = option;
            break;
        case MDOptionSaveCard:
            [MDOptionManager shared].saveCardOption = option;
            break;
        case MDOptionCustomExpiry:
            [MDOptionManager shared].expireTimeOption = option;
            break;
        case MDOption3DSecure:
            [MDOptionManager shared].secure3DOption = option;
            break;
        case MDOptionPaymentType:
            [MDOptionManager shared].ccTypeOption = option;
            break;
        case MDOptionIssuingBank:
            [MDOptionManager shared].issuingBankOption = option;
            break;
    }
}

- (MDOptionView *)optionViewWithType:(MDOption)type {
    for (MDOptionView *optView in self.optionViews) {
        if (optView.optionType == type) {
            return optView;
        }
    }
    return nil;
}

- (IBAction)launchPressed:(id)sender {
    MDProductViewController *vc = [[MDProductViewController alloc] initWithNibName:@"MDProductViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
