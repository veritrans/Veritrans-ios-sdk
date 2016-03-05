//
//  VTVAGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAGuideController.h"
#import "MBXPageViewController.h"
#import "VTPaymentGuideController.h"
#import "VTClassHelper.h"

@interface VTVAGuideController ()<MBXPageControllerDataSource, MBXPageControllerDataDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation VTVAGuideController

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
    NSMutableArray *vcs = [NSMutableArray new];
    
    NSString *path = [VTBundle pathForResource:@"permataVaGuide" ofType:@"plist"];
    NSArray *allGuides = [NSArray arrayWithContentsOfFile:path];
    
    for (int i=0; i<[allGuides count]; i++) {
        NSDictionary *guide = allGuides[i];
        
        if (i>1) {
            [_segmentController insertSegmentWithTitle:guide[@"name"] atIndex:i animated:NO];
        } else {
            [_segmentController setTitle:guide[@"name"] forSegmentAtIndex:i];
        }
        
        VTPaymentGuideController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
        vc.guides = guide[@"guides"];
        [vcs addObject:vc];
    }
    
    // The order matters.
    return vcs;
}



#pragma mark - MBXPageViewController Delegate

- (void)MBXPageChangedToIndex:(NSInteger)index
{
    
}

@end
