//
//  VTSubGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTSubGuideController.h"
#import "MidtransUIStringHelper.h"
#import "VTClassHelper.h"
#import "VTGuideView.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTSubGuideController ()

@property (strong, nonatomic) NSArray <VTInstruction*>*instructions;
@property (strong, nonatomic) IBOutlet VTGuideView *view;

@end

@implementation VTSubGuideController

@dynamic view;

- (instancetype)initWithInstructions:(NSArray <VTInstruction*>*)instructions {
    self = [super initWithNibName:[self.class description] bundle:VTBundle];
    if (self) {
        self.instructions = instructions;        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.instructions = self.instructions;
}



@end
