//
//  MidtransNewCreditCardViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardViewController.h"
#import "MidtransNewCreditCardView.h"
#import "MidtransUISaveCardView.h"
@interface MidtransNewCreditCardViewController ()
@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (strong,nonatomic) NSMutableArray *constraintsInView;
@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintsInView = [NSMutableArray new];
    MidtransUISaveCardView *saveCreditCardView = [[MidtransUISaveCardView alloc] init];
    [self.view.additionalView addSubview:saveCreditCardView];
    //[self updateConstraints];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
- (void)updateConstraints {
    [self.view.additionalView removeConstraints:self.constraintsInView];
    [self.constraintsInView removeAllObjects];
    
    if (self.view.additionalView != nil) {
        UIView *view = self.view.additionalView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.constraintsInView addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.constraintsInView addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self.view.additionalView addConstraints:self.constraintsInView];
    }
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
