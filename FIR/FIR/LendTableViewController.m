//
//  LendTableViewController.m
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "LendTableViewController.h"
#import "InvestCell.h"
#import "LoanViewController.h"
#import "DataSource.h"
#import "FIRLoan.h"
#import "FIRRiskScoreLoan.h"

@interface LendTableViewController ()

@end

@implementation LendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"InvestCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Invest"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return [[DataSource sharedDataSource] othersLoansArray].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestCell *cell = (InvestCell *)[tableView dequeueReusableCellWithIdentifier:@"Invest" forIndexPath:indexPath];
    FIRRiskScoreLoan *riskLoan = (FIRRiskScoreLoan *)[[[DataSource sharedDataSource] othersLoansArray] objectAtIndex:indexPath.row];
    cell.scoreLabel.text = riskLoan.riskScore.stringValue;
    NSDictionary *loan = riskLoan.loanSnapshot.value;
    cell.nameLabel.text = loan[@"name"] != nil ? loan[@"name"] : loan[@"phoneNumber"];
    cell.moneyLabel.text =  [NSString stringWithFormat:@"₹ %@", [loan[@"money"] stringValue]];
    cell.locationLabel.text = [FIRLoan getDistanceFromSnapshot:loan];
    cell.investButton.tag = indexPath.row;
    [cell.investButton addTarget:self action:@selector(invest:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)invest:(UIButton *)button {
    LoanViewController *loanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoanVC"];
    FIRRiskScoreLoan *riskLoan = (FIRRiskScoreLoan *)[[[DataSource sharedDataSource] othersLoansArray] objectAtIndex:button.tag];
    loanViewController.riskScoreLoan = riskLoan;
    [self.navigationController pushViewController:loanViewController animated:true];
}

@end
