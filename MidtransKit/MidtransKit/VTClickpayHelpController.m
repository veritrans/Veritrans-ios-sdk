//
//  VTClickpayHelpController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClickpayHelpController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"

@interface VTClickpayHelpController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@end

@implementation VTClickpayHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    VTPaymentGuideController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    NSString *path = [VTBundle pathForResource:@"clickpayGuide" ofType:@"plist"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
