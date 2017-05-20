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

@interface LendTableViewController ()

@end

@implementation LendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"InvestCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Invest"];
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
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Leave Blank...
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Invest" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LoanViewController *loanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoanVC"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loanViewController];
        [weakSelf presentViewController:navController animated:true completion:nil];
    }];
    rowAction.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:160.0/255.0 alpha:1.0];
    return @[rowAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestCell *cell = (InvestCell *)[tableView dequeueReusableCellWithIdentifier:@"Invest" forIndexPath:indexPath];
    return cell;
}

@end
