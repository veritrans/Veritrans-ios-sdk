//
//  VTVAGuideController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAGuideController.h"
#import "MBXPageViewController_vt.h"
#import "VTPaymentGuideController.h"
#import "VTClassHelper.h"

@interface VTVAGuideController ()<MBXPageControllerDataSource_vt, MBXPageControllerDataDelegate_vt>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, assign) VTVAType vaType;
@end

@implementation VTVAGuideController

+ (instancetype)controllerWithVAType:(VTVAType)vaType {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTVAGuideController *vc = [sb instantiateViewControllerWithIdentifier:@"VTVAGuideController"];
    vc.vaType = vaType;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headerDescription = NSLocalizedString(@"Payment Instructions",nil);
    switch (self.vaType) {
        case VTVATypeBCA:
            self.headerTitle = NSLocalizedString(@"BCA Bank Transfer",nil);
            break;
        case VTVATypeMandiri:
            self.headerTitle = NSLocalizedString(@"Mandiri Bank Transfer",nil);
            break;
        case VTVATypePermata:
            self.headerTitle = NSLocalizedString(@"Permata Bank Transfer",nil);
            break;
        case VTVATypeOther:
            self.headerTitle = NSLocalizedString(@"Other Bank Transfer",nil);
            break;
    }
    
    // Initiate MBXPageController
    MBXPageViewController_vt *MBXPageController = [MBXPageViewController_vt new];
    MBXPageController.MBXDataSource = self;
    MBXPageController.MBXDataDelegate = self;
    MBXPageController.pageMode = MBX_SegmentController;
    [MBXPageController reloadPages];
}

- (IBAction)gotItPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSArray *)usedGuides {
    NSString *path;
    switch (self.vaType) {
        case VTVATypeBCA:
            path = [VTBundle pathForResource:@"bcaVaGuide" ofType:@"plist"];
            break;
        case VTVATypeMandiri:
            path = [VTBundle pathForResource:@"mandiriVaGuide" ofType:@"plist"];
            break;
        case VTVATypePermata:
            path = [VTBundle pathForResource:@"permataVaGuide" ofType:@"plist"];
            break;
        case VTVATypeOther:
            path = [VTBundle pathForResource:@"otherVaGuide" ofType:@"plist"];
            break;
    }
    return [NSArray arrayWithContentsOfFile:path];
}

- (NSArray *)MBXPageControllers {
    NSMutableArray *vcs = [NSMutableArray new];
    
    NSArray *guides = [self usedGuides];
    
    for (int i=0; i<[guides count]; i++) {
        NSDictionary *guide = guides[i];
        
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
