//
//  MDAlertViewController.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 5/4/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDAlertOptionType) {
    MDAlertOptionTypeInput = 1,
    MDAlertOptionTypeRadio = 2,
    MDAlertOptionTypeCheck = 3
};

@class MDAlertViewController;

@protocol MDAlertViewControllerDelegate <NSObject>

- (void)alertViewController_didCancel:(MDAlertViewController *)viewController;
- (void)alertViewController:(MDAlertViewController *)viewController didApplyInput:(NSString *)inputText;
- (void)alertViewController:(MDAlertViewController *)viewController didApplyRadio:(id)value;
- (void)alertViewController:(MDAlertViewController *)viewController didApplyCheck:(NSArray *)values;

@end

@interface MDAlertViewController : UIViewController

@property (nonatomic, weak) id<MDAlertViewControllerDelegate>delegate;
@property (nonatomic, assign) MDAlertOptionType type;
@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic) NSString *inputPlaceholder;
@property (nonatomic) NSString *inputText;
@property (nonatomic) NSString *predefinedInputText;
@property (nonatomic) id predefinedRadio;
@property (nonatomic) NSArray *predefinedCheckLists;

+ (MDAlertViewController *)alertWithTitle:(NSString *)title radioButtons:(NSArray <NSString*>*)radioButtons;
+ (MDAlertViewController *)alertWithTitle:(NSString *)title checkLists:(NSArray <NSString*>*)checkLists;
+ (MDAlertViewController *)alertWithTitle:(NSString *)title
                           predefinedText:(NSString *)predefinedText
                         inputPlaceholder:(NSString *)placeholder;
- (void)show;
- (void)dismiss;

@end
