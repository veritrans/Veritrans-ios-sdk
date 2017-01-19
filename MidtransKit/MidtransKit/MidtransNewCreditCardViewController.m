//
//  MidtransNewCreditCardViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardViewController.h"
#import "MidtransNewCreditCardView.h"
@interface MidtransNewCreditCardViewController ()
@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;

@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.additionalViewHeightConstraints.constant = 1000;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
