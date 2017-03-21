//
//  AcquiringBankTableViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "AcquiringBankTableViewController.h"
#import <MidtransKit/MidtransKit.h>

@interface AcquiringBankTableViewController ()
@property (nonatomic) NSArray *banks;
@end

@implementation AcquiringBankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
     MTAcquiringBankUnknown,
     MTAcquiringBankBCA,
     MTAcquiringBankBRI,
     MTAcquiringBankCIMB,
     MTAcquiringBankMandiri,
     MTAcquiringBankBNI,
     MTAcquiringBankMaybank
     */
    self.banks = @[@{@"type":@(MTAcquiringBankBCA), @"string":@"BCA"},
                   @{@"type":@(MTAcquiringBankBRI), @"string":@"BRI"},
                   @{@"type":@(MTAcquiringBankCIMB), @"string":@"CIMB"},
                    @{@"type":@(MTAcquiringBankDanamon), @"string":@"Danamon"},
                   @{@"type":@(MTAcquiringBankMandiri), @"string":@"Mandiri"},
                   @{@"type":@(MTAcquiringBankBNI), @"string":@"BNI"},
                   @{@"type":@(MTAcquiringBankMaybank), @"string":@"Maybank"}];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"acquiring_bank"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.banks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acquiring_bank"];
    cell.textLabel.text = self.banks[indexPath.row][@"string"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectAcquiringBank:)]) {
        [self.delegate didSelectAcquiringBank:self.banks[indexPath.row]];
    }
}

@end
