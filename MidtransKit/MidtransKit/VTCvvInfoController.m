//
//  VTCvvInfoController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCvvInfoController.h"
#import "UIViewController+Modal.h"
#import "VTClassHelper.h"

@interface VTCvvInfoController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@end

@implementation VTCvvInfoController

- (instancetype)init {
    self = [[VTCvvInfoController alloc] initWithNibName:@"VTCvvInfoController" bundle:VTBundle];
    if (self) {
        self.modalSize = CGSizeMake(270, 300);
    }
    return self;
}

- (IBAction)okPressed:(id)sender {
    [self dismissCustomViewController:nil];
}

@end
