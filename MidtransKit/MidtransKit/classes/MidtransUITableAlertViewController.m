//
//  MidtransTableAlertViewController.m
//  MidtransKit
//
//  Created by Tommy.Yohanes on 9/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUITableAlertViewController.h"
#import "VTClassHelper.h"
#import "UIViewController+Modal.h"

@interface MidtransUITableAlertViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) NSString* closeButtonTitle;
@property (nonatomic) NSArray* list;
@end

@implementation MidtransUITableAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CABasicAnimation *scale1 = [CABasicAnimation animation];
    scale1.keyPath = @"transform.scale";
    scale1.toValue = @0.95;
    scale1.fromValue = @1.05;
    scale1.duration = 0.1;
    scale1.beginTime = 0.0;
    
    CABasicAnimation *scale2 = [CABasicAnimation animation];
    scale2.keyPath = @"transform.scale";
    scale2.toValue = @1;
    scale2.fromValue = @0.95;
    scale2.duration = 0.09;
    scale2.beginTime = 0.1;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animation];
    fadeIn.keyPath = @"opacity";
    fadeIn.toValue = @1.0;
    fadeIn.fromValue = @0.5;
    fadeIn.duration = 0.8;
    fadeIn.beginTime = 0.0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.19;
    animationGroup.animations = @[scale1, scale2, fadeIn];
    [self.containerView.layer addAnimation:animationGroup forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithTitle:(NSString *)title
            closeButtonTitle:(NSString *)closeButtonTitle
                    withList:(NSArray *)list
{
    self = [super initWithNibName:@"MidtransUITableAlertViewController" bundle:VTBundle];
    if (self) {
        self.title = title;
        self.closeButtonTitle = closeButtonTitle;
        self.list = list;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.list[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
    return cell;
}
- (IBAction)didSelectCloseButton:(id)sender {
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissCustomViewController:nil];
    });
}

@end
