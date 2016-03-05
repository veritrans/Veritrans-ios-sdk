//
//  VTInputCvvController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTInputCvvController.h"
#import "VTTextField.h"
#import "VTClassHelper.h"

@interface VTInputCvvController ()
@property (nonatomic) IBOutlet VTTextField *cvvTextField;
@property (nonatomic) IBOutlet UILabel *cvvLabel;
@end

@implementation VTInputCvvController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *containerView = _backCardView.superview;
    
    _frontCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:_frontCardView];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:_frontCardView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_backCardView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:_frontCardView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_backCardView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:_frontCardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_backCardView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:_frontCardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_backCardView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
    
    _backCardView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    
    [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            _frontCardView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            _backCardView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        }];
    } completion:^(BOOL finished) {
        [_cvvTextField becomeFirstResponder];
    }];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -47;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"BackBarIcon" inBundle:VTBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 12, 0, 0)];
    
    [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 130, 30)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backButton]];
    
    [_cvvTextField addTarget:self action:@selector(CVVChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)CVVChanged:(UITextField *)sender {
    _cvvLabel.text = sender.text;
}

- (void)backPressed:(id)sender {
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            _backCardView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            _frontCardView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        }];
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_cvvTextField]) {
        return [textField filterCvvNumber:string range:range];
    } else {
        return YES;
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
