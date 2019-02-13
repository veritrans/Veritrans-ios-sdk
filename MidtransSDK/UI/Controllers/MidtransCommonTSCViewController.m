//
//  MidtransCommonTSCViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/2/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MidtransCommonTSCViewController.h"
#import "VTClassHelper.h"
#import "VTGuideCell.h"
@interface MidtransCommonTSCViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *guides;
@end

@implementation MidtransCommonTSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"BNI Points Terms & Conditions"];
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_bni_point_tsc"];
    
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_bni_point_tsc"] ofType:@"plist"];
    }
    self.guides = [VTClassHelper instructionsFromFilePath:guidePath];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if(indexPath.row %2 ==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        static VTGuideCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
        });
        if(indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        }
        [cell setInstruction:self.guides[indexPath.row-1] number:indexPath.row];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(agreeTermAndConditionDidtapped:)]) {
        [self.delegate agreeTermAndConditionDidtapped:self.bankID];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
