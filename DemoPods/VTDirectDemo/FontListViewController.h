//
//  FontListViewController.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 7/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontListViewControllerDelegate <NSObject>

- (void)didSelectFontNames:(NSArray *)fontNames;

@end

@interface FontListViewController : UIViewController
@property (nonatomic, weak) id<FontListViewControllerDelegate>delegate;
@end
