//
//  SNPMaintainView.m
//  MidtransKit
//
//  Created by Vanbungkring on 6/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPMaintainView.h"

@implementation SNPMaintainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.maintainButton.layer.cornerRadius = 5.0f;
    self.maintainButton.layer.borderColor = self.maintainButton.tintColor.CGColor;
    self.maintainButton.layer.borderWidth = 1.;
    self.maintainButton.layer.cornerRadius = 5.;
    
}

- (void)hide {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.superview sendSubviewToBack:self];
    }];
}
- (void)showInView:(UIView *)view
         withTitle:(NSString *)title
        andContent:(NSString *)content
    andButtonTitle:(NSString *)buttonTitle {
    self.alpha = 0;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    [self.maintainButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];

}
- (IBAction)buttonViewDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(maintainViewButtonDidTapped:)]) {
        [self.delegate maintainViewButtonDidTapped:self.maintainButton.titleLabel.text];
    }
}

@end
