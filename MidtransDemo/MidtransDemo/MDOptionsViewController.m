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
#import "MDAlertViewController.h"
#import <MidtransKit/MidtransKit.h>

@interface MDOptionsViewController () <MDOptionViewDelegate, MDAlertViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *optionContainer;

@property (nonatomic) NSArray *optionViews;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic) MDOptionView *selectedOptionView;
@end

@implementation MDOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo Configuration";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    ///////////
    //cc payment type
    id options = @[[MDOption optionGeneralWithName:@"2-Clicks" value:@(MTCreditCardPaymentTypeTwoclick)],
                   [MDOption optionGeneralWithName:@"1-Click" value:@(MTCreditCardPaymentTypeOneclick)],
                   [MDOption optionGeneralWithName:@"Normal" value:@(MTCreditCardPaymentTypeNormal)]];
    MDOptionView *optType = [MDOptionView viewWithIcon:[UIImage imageNamed:@"cc_click"]
                                         titleTemplate:@"%@ Credit Card Payment"
                                               options:options
                                            identifier:OPTCreditCardFeature];
    [optType selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].ccTypeOption]];
    
    ///////////
    //acquiring bank
    options = @[[MDOption optionGeneralWithName:@"BNI" value:@(MTAcquiringBankBNI)],
                [MDOption optionGeneralWithName:@"BCA" value:@(MTAcquiringBankBCA)],
                [MDOption optionGeneralWithName:@"CIMB" value:@(MTAcquiringBankCIMB)],
                [MDOption optionGeneralWithName:@"BRI" value:@(MTAcquiringBankBRI)],
                [MDOption optionGeneralWithName:@"Mandiri" value:@(MTAcquiringBankMandiri)],
                [MDOption optionGeneralWithName:@"Maybank" value:@(MTAcquiringBankMaybank)]];
    MDOptionView *optAcqBank = [MDOptionView viewWithIcon:[UIImage imageNamed:@"bank"]
                                            titleTemplate:@"Issuing Bank by %@"
                                                  options:options
                                               identifier:OPTAcquiringBank];
    [optAcqBank selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].issuingBankOption]];
    
    ///////////
    //expire time
    MidtransTransactionExpire *minute = [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                                                               expireDuration:1
                                                                                 withUnitTime:MindtransTimeUnitTypeMinute];
    MidtransTransactionExpire *hour = [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                                                             expireDuration:1
                                                                               withUnitTime:MindtransTimeUnitTypeHour];
    options = @[[MDOption optionGeneralWithName:@"No Expiry" value:nil],
                [MDOption optionGeneralWithName:@"1 Minute" value:minute],
                [MDOption optionGeneralWithName:@"1 Hour" value:hour]];
    MDOptionView *optCustomExpiry = [MDOptionView viewWithIcon:[UIImage imageNamed:@"expiry"]
                                                 titleTemplate:@"%@"
                                                       options:options
                                                    identifier:OPTCustomExpire];
    [optCustomExpiry selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].expireTimeOption]];
    
    ///////////
    //save card
    options = @[[MDOption optionGeneralWithName:@"Disable" value:@NO],
                [MDOption optionGeneralWithName:@"Enable" value:@YES]];
    MDOptionView *optSaveCard = [MDOptionView viewWithIcon:[UIImage imageNamed:@"save_card"]
                                             titleTemplate:@"Save Card Feature %@d"
                                                   options:options
                                                identifier:OPTSaveCard];
    [optSaveCard selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].saveCardOption]];
    
    ///////////
    //3d secure
    options = @[[MDOption optionGeneralWithName:@"Disable" value:@NO],
                [MDOption optionGeneralWithName:@"Enable" value:@YES]];
    MDOptionView *opt3ds = [MDOptionView viewWithIcon:[UIImage imageNamed:@"3ds"]
                                        titleTemplate:@"3D Secure %@d"
                                              options:options
                                           identifier:OPT3DSecure];
    [opt3ds selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].secure3DOption]];
    
    
    ///////////
    //promo
    options = @[[MDOption optionGeneralWithName:@"Disable" value:@NO],
                [MDOption optionGeneralWithName:@"Enable" value:@YES]];
    MDOptionView *optPromo = [MDOptionView viewWithIcon:[UIImage imageNamed:@"promo"]
                                          titleTemplate:@"Promo %@d"
                                                options:options
                                             identifier:OPTPromo];
    [optPromo selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].promoOption]];
    
    ///////////
    //preauth
    options = @[[MDOption optionGeneralWithName:@"Disable" value:@NO],
                [MDOption optionGeneralWithName:@"Enable" value:@YES]];
    MDOptionView *optPreauth = [MDOptionView viewWithIcon:[UIImage imageNamed:@"preauth"]
                                            titleTemplate:@"Pre Auth Feature %@d"
                                                  options:options
                                               identifier:OPTPreauth];
    [optPreauth selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].preauthOption]];
    
    
    ///////////
    //bni point
    options = @[[MDOption optionGeneralWithName:@"Disable" value:@NO],
                [MDOption optionGeneralWithName:@"Enable" value:@YES]];
    MDOptionView *optBNIPoint = [MDOptionView viewWithIcon:[UIImage imageNamed:@"bni_point"]
                                             titleTemplate:@"BNI Point Only %@"
                                                   options:options
                                                identifier:OPTBNIPoint];
    [optBNIPoint selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].colorOption]];
    
    ///////////////
    //color scheme
    options = @[[MDOption optionColorWithName:@"Blue" value:RGB(47, 128, 194)],
                [MDOption optionColorWithName:@"Red" value:RGB(212, 56, 92)],
                [MDOption optionColorWithName:@"Green" value:RGB(59, 183, 64)],
                [MDOption optionColorWithName:@"Orange" value:RGB(255, 140, 0)],
                [MDOption optionColorWithName:@"Black" value:RGB(21, 21, 21)]];
    MDOptionView *optTheme = [MDOptionView viewWithIcon:[UIImage imageNamed:@"theme"]
                                          titleTemplate:@"%@ Color Theme"
                                                options:options
                                             identifier:OPTColor];
    [optTheme selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].colorOption]];
    
    ////////////
    //permata va
    options = @[[MDOption optionGeneralWithName:@"Disable" value:nil],
                [MDOption optionComposer:MDComposerTypeText name:@"Enable" value:@""]];
    MDOptionView *optPermataVA = [MDOptionView viewWithIcon:[UIImage imageNamed:@"custom_permata_va"]
                                              titleTemplate:@"Custom Permata VA %@d"
                                                    options:options
                                                 identifier:OPTPermataVA];
    [optPermataVA selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].permataVAOption]];
    
    /////////////
    //permata va
    options = @[[MDOption optionGeneralWithName:@"Disable" value:nil],
                [MDOption optionComposer:MDComposerTypeText name:@"Enable" value:@""]];
    MDOptionView *optBCAVA = [MDOptionView viewWithIcon:[UIImage imageNamed:@"custom_bca_va"]
                                          titleTemplate:@"Custom BCA VA %@d"
                                                options:options
                                             identifier:OPTBCAVA];
    [optBCAVA selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].bcaVAOption]];
    
    /////////////
    //installment
    options = @[[MDOption optionGeneralWithName:@"Disabled" value:nil],
                [MDOption optionComposer:MDComposerTypeRadio name:@"Mandiri" value:[self installmentBank:@"mandiri" isRequired:NO]],
                [MDOption optionComposer:MDComposerTypeRadio name:@"BCA" value:[self installmentBank:@"bca" isRequired:NO]],
                [MDOption optionComposer:MDComposerTypeRadio name:@"BNI" value:[self installmentBank:@"bni" isRequired:NO]]];
    MDOptionView *optInstallment = [MDOptionView viewWithIcon:[UIImage imageNamed:@"installment"]
                                                titleTemplate:@"Installment %@"
                                                      options:options
                                                   identifier:OPTInstallment];
    [optInstallment selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].installmentOption]];
    
    self.optionViews = @[
                         optType,
                         opt3ds,
                         optAcqBank,
                         optCustomExpiry,
                         optSaveCard,
                         optPromo,
                         optPreauth,
                         optTheme,
                         optBNIPoint,
                         optPermataVA,
                         optBCAVA,
                         optInstallment
                         ];
    
    [self prepareOptionViews:self.optionViews];
    
    defaults_observe_object(@"md_cc_type", ^(id note){
        MTCreditCardPaymentType type = [[MDOptionManager shared].ccTypeOption.value integerValue];
        if (type == MTCreditCardPaymentTypeOneclick) {
            [opt3ds selectOptionAtIndex:1];
            [optSaveCard selectOptionAtIndex:1];
        }
        else if (type == MTCreditCardPaymentTypeTwoclick) {
            [optSaveCard selectOptionAtIndex:1];
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
- (void)optionView:(MDOptionView *)optionView didTapHeader:(id)sender {
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
- (void)optionView:(MDOptionView *)optionView didTapOption:(MDOption *)option {
    [self cacheOptionWithView:optionView option:option];
}
- (void)optionView:(MDOptionView *)optionView didTapComposerOption:(MDOption *)option {
    NSString *idf = optionView.identifier;
    if ([idf isEqualToString:OPTPermataVA] ||
        [idf isEqualToString:OPTBCAVA]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Custom VA Number"
                                                              predefinedText:nil
                                                            inputPlaceholder:@"Custom VA Number"];
        alert.delegate = self;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    else if ([idf isEqualToString:OPTInstallment]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Installment" radioButtons:@[@"Required", @"Optional"]];
        alert.delegate = self;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    self.selectedOptionView = optionView;
}
- (void)optionView:(MDOptionView *)optionView didTapEditComposerOption:(MDOption *)option {
    NSString *idf = optionView.identifier;
    if ([idf isEqualToString:OPTPermataVA] ||
        [idf isEqualToString:OPTBCAVA]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Custom VA Number"
                                                              predefinedText:option.value
                                                            inputPlaceholder:@"Custom VA Number"];
        alert.delegate = self;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    else if ([idf isEqualToString:OPTInstallment]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Installment" radioButtons:@[@"Required", @"Optional"]];
        alert.predefinedRadio = option.subName;
        alert.delegate = self;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    self.selectedOptionView = optionView;
}

- (IBAction)launchPressed:(id)sender {
    MDProductViewController *vc = [[MDProductViewController alloc] initWithNibName:@"MDProductViewController"
                                                                            bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MDAlertViewControllerDelegate

- (void)alertViewController_didCancel:(MDAlertViewController *)viewController {
    [viewController dismiss];
}
- (void)alertViewController:(MDAlertViewController *)viewController didApplyInput:(NSString *)inputText {
    NSUInteger index = viewController.tag;
    MDOption *option = self.selectedOptionView.options[index];
    option.value = inputText;
    option.subName = inputText;
    
    [self.selectedOptionView selectOptionAtIndex:index];
    
    [self cacheOptionWithView:self.selectedOptionView option:option];
    
    [viewController dismiss];
}
- (void)alertViewController:(MDAlertViewController *)viewController didApplyCheck:(NSArray *)values {
    
}
- (void)alertViewController:(MDAlertViewController *)viewController didApplyRadio:(id)value {
    NSUInteger index = viewController.tag;
    MDOption *option = self.selectedOptionView.options[index];
    option.subName = value;
    
    if ([self.selectedOptionView.identifier isEqualToString:OPTInstallment]) {
        ((MidtransPaymentRequestV2Installment *)option.value).required = [value isEqualToString:@"Required"]? YES: NO;
    }
    
    [self.selectedOptionView selectOptionAtIndex:index];
    [self cacheOptionWithView:self.selectedOptionView option:option];
    
    [viewController dismiss];
}

#pragma mark - Helper

- (MidtransPaymentRequestV2Installment *)installmentBank:(NSString *)bank isRequired:(BOOL)required {
    return [MidtransPaymentRequestV2Installment modelWithTerms:@{bank:@[@6,@12]} isRequired:required];
}

- (void)cacheOptionWithView:(MDOptionView *)view option:(MDOption *)option {
    NSString *idf = view.identifier;
    if ([idf isEqualToString:OPTSaveCard]) {
        [MDOptionManager shared].saveCardOption = option;
    }
    else if ([idf isEqualToString:OPT3DSecure]) {
        [MDOptionManager shared].secure3DOption = option;
    }
    else if ([idf isEqualToString:OPTColor]) {
        [MDOptionManager shared].colorOption = option;
    }
    else if ([idf isEqualToString:OPTPromo]) {
        [MDOptionManager shared].promoOption = option;
    }
    else if ([idf isEqualToString:OPTPreauth]) {
        [MDOptionManager shared].preauthOption = option;
    }
    else if ([idf isEqualToString:OPTBNIPoint]) {
        [MDOptionManager shared].bniPointOption = option;
    }
    else if ([idf isEqualToString:OPTCustomExpire]) {
        [MDOptionManager shared].expireTimeOption = option;
    }
    else if ([idf isEqualToString:OPTAcquiringBank]) {
        [MDOptionManager shared].issuingBankOption = option;
    }
    else if ([idf isEqualToString:OPTCreditCardFeature]) {
        [MDOptionManager shared].ccTypeOption = option;
    }
    else if ([idf isEqualToString:OPTBCAVA]) {
        [MDOptionManager shared].bcaVAOption = option;
    }
    else if ([idf isEqualToString:OPTPermataVA]) {
        [MDOptionManager shared].permataVAOption = option;
    }
    else if ([idf isEqualToString:OPTInstallment]) {
        [MDOptionManager shared].installmentOption = option;
    }
}
- (MDOptionView *)optionView:(NSString *)identifier {
    for (MDOptionView *optView in self.optionViews) {
        if ([optView.identifier isEqualToString:identifier]) {
            return optView;
        }
    }
    return nil;
}

@end
