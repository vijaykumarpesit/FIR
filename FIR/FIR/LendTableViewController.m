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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Leave Blank...
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Invest" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LoanViewController *loanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoanVC"];
        [weakSelf.navigationController pushViewController:loanViewController animated:true];
    }];
    rowAction.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:160.0/255.0 alpha:1.0];
    return @[rowAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestCell *cell = (InvestCell *)[tableView dequeueReusableCellWithIdentifier:@"Invest" forIndexPath:indexPath];
    FIRRiskScoreLoan *riskLoan = (FIRRiskScoreLoan *)[[[DataSource sharedDataSource] othersLoansArray] objectAtIndex:indexPath.row];
    cell.scoreLabel.text = riskLoan.riskScore.stringValue;
    FIRLoan *loan = ((FIRLoan *)riskLoan.loanSnapshot);
    cell.nameLabel.text = loan.userID;
    cell.moneyLabel.text = loan.money.stringValue;
    cell.locationLabel.text = loan.getDistance;
    return cell;
}

@end
