//
//  VTVAController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAController.h"
#import "VTTextField.h"
#import "VTVAGuideController.h"

@interface VTVAController ()
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet VTTextField *emailTextField;

@property (nonatomic, assign) VTVAType vaType;

@end

@implementation VTVAController

+ (instancetype)controllerWithVaType:(VTVAType)vaType {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTVAController *vc = [sb instantiateViewControllerWithIdentifier:@"VTVAController"];
    vc.vaType = vaType;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    switch (self.vaType) {
        case VTVATypeBCA:
            self.title = @"BCA Bank Transfer";
            break;
        case VTVATypeMandiri:
            self.title = @"Mandiri Bank Transfer";
            break;
        case VTVATypePermata:
            self.title = @"Permata Bank Transfer";
            break;
        case VTVATypeOther:
            self.title = @"Other Bank Transfer";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTVAGuideController *vc = [VTVAGuideController controllerWithVAType:_vaType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)paymentPressed:(UIButton *)sender {
    switch (self.vaType) {
        case VTVATypeBCA:
            break;
        case VTVATypeMandiri:
            break;
        case VTVATypePermata:
            break;
        case VTVATypeOther:
            break;
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
