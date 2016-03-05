//
//  VTVAConfirmationController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAConfirmationController.h"

@interface VTVAConfirmationController ()
@property (strong, nonatomic) IBOutlet UILabel *billpayCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *importantNoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiryLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation VTVAConfirmationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveVAPressed:(UIButton *)sender {
}
- (IBAction)helpPressed:(UIButton *)sender {
}
- (IBAction)finishPressed:(UIButton *)sender {
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
