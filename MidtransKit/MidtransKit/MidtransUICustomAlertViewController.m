//
//  MidtransUICustomAlertViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUICustomAlertViewController.h"
#import "VTClassHelper.h"
#import "UIViewController+Modal.h"
#import "MidtransUIThemeManager.h"

@interface MidtransUICustomAlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionAlertLabel;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *alertViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraints;

@property (strong, nonatomic) NSString *titleAlertText;
@property (strong, nonatomic) NSString *descriptionAlertText;
@property (strong, nonatomic) NSString *okButtonText;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *cancelButtonText;
@property (weak, nonatomic) id<MidtransUICustomAlertViewControllerDelegate>delegate;
@end

@implementation MidtransUICustomAlertViewController
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(NSString *)image
                     delegate:(id<MidtransUICustomAlertViewControllerDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle {
    self = [super initWithNibName:@"MidtransUICustomAlertViewController" bundle:VTBundle];
    if (self) {
        _titleAlertText = title;
        _imageName = image;
        _descriptionAlertText = message;
        _okButtonText = okButtonTitle;
        _cancelButtonText = cancelButtonTitle;
        _delegate = delegate;
    }
    return self;
}
- (IBAction)backgroundViewDidTapped:(id)sender {
    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.okButton.userInteractionEnabled = YES;
    [self.okButton addTarget:self action:@selector(okButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_imageName|| _imageName.length>0) {
        self.imageViewConstraintHeight.constant = 128;
        self.imageViewContent.image = [UIImage imageNamed:_imageName inBundle:VTBundle compatibleWithTraitCollection:nil];
    }
    self.titleAlertLabel.text = self.titleAlertText;
    self.descriptionAlertLabel.text = self.descriptionAlertText;
    [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [self.okButton setTitle:self.okButtonText forState:UIControlStateNormal];
    self.okButton.layer.cornerRadius = self.buttonHeightConstraints.constant/2.0f;
    [self.okButton setBackgroundColor:[[MidtransUIThemeManager shared] themeColor]];
    
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
    [self.alertViewContainer.layer addAnimation:animationGroup forKey:nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)okButtonDidTapped:(id)sender {
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didSelectOKButtonAlertViewController:)]) {
            [self.delegate didSelectOKButtonAlertViewController:self];
        }
          [self dismissCustomViewController:nil];
    });
}

@end
