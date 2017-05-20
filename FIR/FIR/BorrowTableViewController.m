//
//  BorrowTableViewController.m
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "BorrowTableViewController.h"
#import "InvestCell.h"
#import "FIRRiskScoreLoan.h"
#import "DataSource.h"

@interface BorrowTableViewController ()

@end

@implementation BorrowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"InvestCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Borrow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DataSource sharedDataSource] myLoansArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InvestCell *cell = (InvestCell *)[tableView dequeueReusableCellWithIdentifier:@"Borrow" forIndexPath:indexPath];
    FIRRiskScoreLoan *riskLoan = (FIRRiskScoreLoan *)[[[DataSource sharedDataSource] myLoansArray] objectAtIndex:indexPath.row];
    NSDictionary *loan = riskLoan.loanSnapshot.value;
    cell.nameLabel.text = loan[@"name"] != nil ? loan[@"name"] : loan[@"phoneNumber"];
    cell.moneyLabel.text =  [NSString stringWithFormat:@"₹ %@", [loan[@"money"] stringValue]];
    return cell;
    return cell;
}

@end
