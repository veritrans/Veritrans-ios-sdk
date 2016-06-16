//
//  VTPaymentGuideViewController.m
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentGuideViewController.h"
#import "VTPaymentGuideView.h"
#import "UIViewController+HeaderSubtitle.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "VTClassHelper.h"
@interface VTPaymentGuideViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentGuideView *view;
@property (strong, nonatomic) NSString *paymentMethodName;
@end

@implementation VTPaymentGuideViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setHeaderWithTitle:NSLocalizedString(self.paymentMethodName,nil) subTitle:NSLocalizedString(@"Payment Instructions",nil)];
    NSString *paymentName = [[self.paymentMethodName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *path = [VTBundle pathForResource:[NSString stringWithFormat:@"%@Guide",[paymentName lowercaseString]] ofType:@"plist"];
    self.view.guideTextView.text = @"data";
}

- (instancetype)initGuideWithPaymentMethodName:(NSString *)paymentMethodName {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.paymentMethodName = paymentMethodName;
        NSLog(@"payment name %@",paymentMethodName);
        
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
