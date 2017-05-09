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
#import "MDPayment.h"

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
    [optBNIPoint selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].bniPointOption]];
    
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
                [MDOption optionComposer:MDComposerTypeRadio name:@"Mandiri" value:[MDUtils installmentOfBank:@"mandiri" isRequired:NO]],
                [MDOption optionComposer:MDComposerTypeRadio name:@"BCA" value:[MDUtils installmentOfBank:@"bca" isRequired:NO]],
                [MDOption optionComposer:MDComposerTypeRadio name:@"BNI" value:[MDUtils installmentOfBank:@"bni" isRequired:NO]]];
    MDOptionView *optInstallment = [MDOptionView viewWithIcon:[UIImage imageNamed:@"installment"]
                                                titleTemplate:@"Installment %@"
                                                      options:options
                                                   identifier:OPTInstallment];
    [optInstallment selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].installmentOption]];
    
    //////////////////
    //payment channels
    options = @[[MDOption optionGeneralWithName:@"Show All" value:nil],
                [MDOption optionCheckListWithName:@"Show Selected Only" checkedList:nil]];
    MDOptionView *optPaymentChannels = [MDOptionView viewWithIcon:[UIImage imageNamed:@"payment_channel"]
                                                    titleTemplate:@"%@"
                                                          options:options
                                                       identifier:OPTPaymanetChannel];
    [optPaymentChannels selectOptionAtIndex:[options indexOfOption:[MDOptionManager shared].paymentChannel]];
    
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
                         optInstallment,
                         optPaymentChannels
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
    [MDUtils saveOptionWithView:optionView option:option];
}
- (void)optionView:(MDOptionView *)optionView didTapComposerOption:(MDOption *)option {
    [self showAlertAtOptionView:optionView option:option usePredefinedValue:NO];
}
- (void)optionView:(MDOptionView *)optionView didTapEditComposerOption:(MDOption *)option {
    [self showAlertAtOptionView:optionView option:option usePredefinedValue:YES];
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
    
    [MDUtils saveOptionWithView:self.selectedOptionView option:option];
    
    [viewController dismiss];
}
- (void)alertViewController:(MDAlertViewController *)viewController didApplyCheck:(NSArray *)values {
    NSUInteger index = viewController.tag;
    MDOption *option = self.selectedOptionView.options[index];
    option.value = [MDUtils paymentChannelsWithNames:values];
    option.subName = [NSString stringWithFormat:@"%@ Channels", @(values.count)];
    
    [self.selectedOptionView selectOptionAtIndex:index];
    [MDUtils saveOptionWithView:self.selectedOptionView option:option];
    
    [viewController dismiss];
}
- (void)alertViewController:(MDAlertViewController *)viewController didApplyRadio:(id)value {
    NSUInteger index = viewController.tag;
    MDOption *option = self.selectedOptionView.options[index];
    option.subName = value;
    
    if ([self.selectedOptionView.identifier isEqualToString:OPTInstallment]) {
        MidtransPaymentRequestV2Installment *term = option.value;
        term.required = [value isEqualToString:@"Required"]? YES: NO;
        
        NSString *bank = term.terms.allKeys.firstObject;
        MTAcquiringBank bankAcq;
        
        if ([bank isEqualToString:BankBCAKey]) {
            bankAcq = MTAcquiringBankBCA;
        }
        else if ([bank isEqualToString:BankMandiriKey]) {
            bankAcq = MTAcquiringBankMandiri;
        }
        else {
            bankAcq = MTAcquiringBankBNI;
        }
        
        MDOptionView *view = [self optionView:OPTAcquiringBank];
        NSUInteger index = [view.options indexOfObjectPassingTest:^BOOL(MDOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.value integerValue] == bankAcq;
        }];
        [view selectOptionAtIndex:index];
    }
    
    [self.selectedOptionView selectOptionAtIndex:index];
    [MDUtils saveOptionWithView:self.selectedOptionView option:option];
    
    [viewController dismiss];
}

#pragma mark - Helper

- (void)showAlertAtOptionView:(MDOptionView *)optionView
                       option:(MDOption *)option
           usePredefinedValue:(BOOL)usePredefinedValue {
    NSString *idf = optionView.identifier;
    if ([idf isEqualToString:OPTPermataVA] ||
        [idf isEqualToString:OPTBCAVA]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Custom VA Number"
                                                              predefinedText:option.value
                                                            inputPlaceholder:@"Custom VA Number"];
        alert.delegate = self;
        alert.predefinedInputText = usePredefinedValue? option.value: nil;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    else if ([idf isEqualToString:OPTInstallment]) {
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Enable Installment" radioButtons:@[@"Required", @"Optional"]];
        alert.predefinedRadio = usePredefinedValue? option.subName: nil;
        alert.delegate = self;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    else if ([idf isEqualToString:OPTPaymanetChannel]) {
        NSArray *channelNames = [[MDUtils allPaymentChannels] valueForKey:@"name"];
        MDAlertViewController *alert = [MDAlertViewController alertWithTitle:@"Select Payment Channels"
                                                                  checkLists:channelNames];
        alert.delegate = self;
        alert.predefinedCheckLists = usePredefinedValue? [option.value valueForKey:@"name"]: nil;
        alert.tag = [optionView.options indexOfObject:option];
        [alert show];
    }
    self.selectedOptionView = optionView;
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
