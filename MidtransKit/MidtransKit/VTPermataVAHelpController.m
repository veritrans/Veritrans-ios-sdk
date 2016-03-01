//
//  VTPermataVAHelpController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPermataVAHelpController.h"
#import "MBXPageViewController.h"
#import "VTPaymentGuideController.h"
#import "VTClassHelper.h"

@interface VTPermataVAHelpController ()<MBXPageControllerDataSource, MBXPageControllerDataDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation VTPermataVAHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initiate MBXPageController
    MBXPageViewController *MBXPageController = [MBXPageViewController new];
    MBXPageController.MBXDataSource = self;
    MBXPageController.MBXDataDelegate = self;
    MBXPageController.pageMode = MBX_SegmentController;
    [MBXPageController reloadPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons
{
    return @[self.segmentController];
}

- (UIView *)MBXPageContainer
{
    return self.containerView;
}

- (NSArray *)MBXPageControllers
{
    // Or Load it from a xib file
    UIViewController *demo2 = [UIViewController new];

    VTPaymentGuideController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    
    NSString *path = [VTBundle pathForResource:@"permataVaGuideAtm" ofType:@"plist"];
    vc.guides = [NSArray arrayWithContentsOfFile:path];
    
    // The order matters.
    return @[vc, demo2];
}



#pragma mark - MBXPageViewController Delegate

- (void)MBXPageChangedToIndex:(NSInteger)index
{

}

@end
