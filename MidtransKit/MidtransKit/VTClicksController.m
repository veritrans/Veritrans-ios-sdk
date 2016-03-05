//
//  VTClicksController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClicksController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"

@interface VTClicksController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation VTClicksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    VTPaymentGuideController *guide = [self.storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    
    NSString *path = [VTBundle pathForResource:@"cimbClicksGuide" ofType:@"plist"];
    guide.guides = [NSArray arrayWithContentsOfFile:path];
    
    [self addSubViewController:guide toView:_helpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downloadGuidePressed:(UIButton *)sender {
}
- (IBAction)confirmPaymentPressed:(UIButton *)sender {
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
