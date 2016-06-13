//
//  VTIndomaretGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretGuideController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"

@interface VTIndomaretGuideController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@end

@implementation VTIndomaretGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderWithTitle:@"Pay At Indomaret" subTitle:@"Payment Instructions"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentGuideController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    NSString *path = [VTBundle pathForResource:@"indomaretGuide" ofType:@"plist"];
    vc.guides = [NSArray arrayWithContentsOfFile:path];
    [self addSubViewController:vc toView:_helpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotItPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
