//
//  VTErrorStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTErrorStatusController.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTErrorStatusController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentTypeLabel;

@property (nonatomic) NSError *error;
@end

@implementation VTErrorStatusController

- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error {
    self = [[VTErrorStatusController alloc] initWithNibName:@"VTErrorStatusController" bundle:VTBundle];
    if (self) {
        self.error = error;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SNPUITrackingManager shared] trackEventName:@"pg error"];
    self.title = UILocalizedString(@"payment.failed",nil);
    
    self.navigationItem.hidesBackButton = YES;
    
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY:self.error};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
