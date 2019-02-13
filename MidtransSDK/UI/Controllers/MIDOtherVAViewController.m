//
//  MIDOtherVAViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/9/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDOtherVAViewController.h"
#import "HMSegmentedControl.h"
#import "MidtransUIThemeManager.h"
#import "VTKITConstant.h"
#import "VTClassHelper.h"
#import "UIColor+VTColor.h"
@interface MIDOtherVAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *smallTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallLogo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *buttonDisclosure;

@end

@implementation MIDOtherVAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.paymentMethod.title;
    self.segmentedControl.sectionTitles = @[@"ATM BERSAMA",@"PRIMA",@"ALTO"];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorColor = [[MidtransUIThemeManager shared] themeColor];
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],NSFontAttributeName: [UIFont fontWithName:FONT_NAME_MEDIUM size:14.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName: [UIFont fontWithName:FONT_NAME_MEDIUM size:16.0f]};
    self.smallTextLabel.text =[NSString stringWithFormat:@"Pastikan ada logo ATM Bersama di belakang kartu ATM"];
    // Do any additional setup after loading the view from its nib.
    [self.smallLogo setImage:[UIImage imageNamed:@"atm_bersama" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSString *imageNamed = [[self.segmentedControl.sectionTitles[segmentedControl.selectedSegmentIndex] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *textName =self.segmentedControl.sectionTitles[segmentedControl.selectedSegmentIndex];
    self.smallTextLabel.text =[NSString stringWithFormat:@"Pastikan ada logo %@ di belakang kartu ATM",textName];
     [self.smallLogo setImage:[UIImage imageNamed:imageNamed inBundle:VTBundle compatibleWithTraitCollection:nil]];
    
}
- (IBAction)confirmPaymentButtonDidTapped:(id)sender {
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
