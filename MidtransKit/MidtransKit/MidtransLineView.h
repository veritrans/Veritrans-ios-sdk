//
//  MIdtransLineView.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransLineView : UIView

@property (assign, nonatomic) IBInspectable BOOL isVerticalLine;
@property (strong, nonatomic) IBInspectable UIColor *lineColor;
@property (assign, nonatomic) IBInspectable BOOL dashed;
@property (assign, nonatomic) IBInspectable CGFloat dashLength;
@property (assign, nonatomic) IBInspectable CGFloat spaceLength;
@property (assign, nonatomic) IBInspectable BOOL drawOnTop;

@end
