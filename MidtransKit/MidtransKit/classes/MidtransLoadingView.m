//
//  MidtransLoadingView.m
//  MidtransKit
//
//  Created by Arie on 10/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransLoadingView.h"
#import "VTClassHelper.h"
#import "MidtransLoadingIndicator.h"
@interface MidtransLoadingView()
@property (weak, nonatomic) IBOutlet MidtransLoadingIndicator *loadingIndicator;

@end;
@implementation MidtransLoadingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLoadingView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLoadingView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initLoadingView];
    }
    return self;
}
- (void)initLoadingView {
    UIView *view = [[VTBundle loadNibNamed:@"MidtransLoadingView" owner:self options:nil] firstObject];
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = false;
    self.alpha = 0.0f;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.loadingIndicator startAnimating];

    self.backgroundColor = [UIColor whiteColor];
}
- (void)showWithTitle:(NSString *)title {
    self.loadingTitleLabel.text = title?title:@"Loading";
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    self.loadingIndicator.hidden = NO;

    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    }];

}
- (void)show {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    self.loadingIndicator.hidden = NO;
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)remove {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
         [self.superview sendSubviewToBack:self];
    }];
}
- (void)showInView:(UIView *)view withText:(NSString *)text {
    self.alpha = 0;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    
    self.loadingTitleLabel.text = text?text:@"Loading";
    self.loadingIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    }];
}

@end
