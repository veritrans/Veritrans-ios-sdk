//
//  MDOrderViewController.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ACFloatingTextField;
@interface MDOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet ACFloatingTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
