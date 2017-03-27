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
                                         defaultOption:[MDOptionManager shared].ccPaymentType];
    optType.optionType = MDOptionPaymentType;
    
    MDOptionView *opt3ds = [MDOptionView viewWithIcon:[UIImage imageNamed:@"3ds"]
                                        titleTemplate:@"3D Secure %@d"
                                              options:@[@"Enable", @"Disable"]
                                        defaultOption:[MDOptionManager shared].secure3D];
    opt3ds.optionType = MDOption3DSecure;
    
    MDOptionView *optAcqBank = [MDOptionView viewWithIcon:[UIImage imageNamed:@"bank"]
                                            titleTemplate:@"Issuing Bank by %@"
                                                  options:@[@"BNI", @"Mandiri", @"BCA", @"Maybank", @"BRI"]
                                            defaultOption:[MDOptionManager shared].issuingBank];
    optAcqBank.optionType = MDOptionIssuingBank;
    
    MDOptionView *optCustomExpiry = [MDOptionView viewWithIcon:[UIImage imageNamed:@"expiry"]
                                                 titleTemplate:@"%@"
                                                       options:@[@"No Expiry", @"1 Minute", @"1 Hour"]
                                                 defaultOption:[MDOptionManager shared].customExpiry];
    optCustomExpiry.optionType = MDOptionCustomExpiry;
    
    MDOptionView *optSaveCard = [MDOptionView viewWithIcon:[UIImage imageNamed:@"save_card"]
                                             titleTemplate:@"Save Card Feature %@d"
                                                   options:@[@"Enable", @"Disable"]
                                             defaultOption:[MDOptionManager shared].saveCard];
    optSaveCard.optionType = MDOptionSaveCard;
    
    MDOptionView *optPromo = [MDOptionView viewWithIcon:[UIImage imageNamed:@"promo"]
                                          titleTemplate:@"Promo %@d"
                                                options:@[@"Enable", @"Disable"]
                                          defaultOption:[MDOptionManager shared].promo];
    optPromo.optionType = MDOptionPromo;
    
    MDOptionView *optPreauth = [MDOptionView viewWithIcon:[UIImage imageNamed:@"preauth"]
                                            titleTemplate:@"Pre Auth Feature %@d"
                                                  options:@[@"Enable", @"Disable"]
                                            defaultOption:[MDOptionManager shared].preauth];
    optPreauth.optionType = MDOptionPreauth;
    
    MDOptionView *optTheme = [MDOptionView viewWithIcon:[UIImage imageNamed:@"theme"]
                                          titleTemplate:@"%@ Color Theme"
                                                options:@[@"Blue", @"Red", @"Green", @"Orange", @"Black"]
                                          defaultOption:[MDOptionManager shared].colorTheme
                                          isColorOption:YES];
    optTheme.optionType = MDOptionColorTheme;
    
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
            [MDOptionManager shared].colorTheme = option;
            break;
        case MDOptionPreauth:
            [MDOptionManager shared].preauth = option;
            break;
        case MDOptionPromo:
            [MDOptionManager shared].promo = option;
            break;
        case MDOptionSaveCard:
            [MDOptionManager shared].saveCard = option;
            break;
        case MDOptionCustomExpiry:
            [MDOptionManager shared].customExpiry = option;
            break;
        case MDOption3DSecure:
            [MDOptionManager shared].secure3D = option;
            break;
        case MDOptionPaymentType:
            [MDOptionManager shared].ccPaymentType = option;
            break;
        case MDOptionIssuingBank:
            [MDOptionManager shared].issuingBank = option;
            break;
    }
}

- (IBAction)launchPressed:(id)sender {
    MDProductViewController *vc = [[MDProductViewController alloc] initWithNibName:@"MDProductViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
