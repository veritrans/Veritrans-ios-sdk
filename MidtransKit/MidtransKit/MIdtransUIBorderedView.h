//
//  MIdtransUIBorderedView.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIdtransUIBorderedView : UIView

@property (nonatomic) IBInspectable UIColor *borderLineColor;
@property (nonatomic) IBInspectable NSInteger borderLineWidth;
@property (nonatomic, assign) IBInspectable BOOL topLine;
@property (nonatomic, assign) IBInspectable BOOL bottomLine;

@end
