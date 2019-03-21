//
//  SNPMaintainView.h
//  MidtransKit
//
//  Created by Vanbungkring on 6/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SNPMaintainViewDelegate <NSObject>
- (void)maintainViewButtonDidTapped:(NSString *)title;
@end
@interface SNPMaintainView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *maintainButton;
@property (weak, nonatomic) id<SNPMaintainViewDelegate>delegate;
- (void)hide;
- (void)showInView:(UIView *)view
         withTitle:(NSString *)title
        andContent:(NSString *)content
    andButtonTitle:(NSString *)buttonTitle;
@end
