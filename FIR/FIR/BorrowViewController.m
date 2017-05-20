//
//  BorrowViewController.m
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "BorrowViewController.h"
#import "FIRLoan.h"
#import "DataSource.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BorrowViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;
@property (weak, nonatomic) IBOutlet UISlider *daysSlider;
@property (weak, nonatomic) IBOutlet UITableView *documentsView;
@end

@implementation BorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.documentsView.delegate = self;
    self.documentsView.dataSource = self;
    
    [self.amountSlider addTarget:self action:@selector(amountChanged:) forControlEvents:UIControlEventValueChanged];
    [self.daysSlider addTarget:self action:@selector(daysChanged:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)amountChanged:(UISlider *)sender {
    NSInteger value = sender.value;
    self.amountTextField.text = [NSString stringWithFormat:@"₹ %ld", value];
}

- (void)daysChanged:(UISlider *)sender {
    NSInteger value = sender.value;
    self.daysTextField.text = [NSString stringWithFormat:@"%ld day(s)", (long)value];
}


- (IBAction)submitTapped:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"Creating New Loan";
    [self.view addSubview:hud];
    hud.center = self.view.center;
    FIRLoan *loan = [[FIRLoan alloc] init];
    NSString *money = [self.amountTextField.text componentsSeparatedByString:@" "][1];
    loan.money = [NSNumber numberWithInteger:money.integerValue];
    NSString *days = [self.daysTextField.text componentsSeparatedByString:@" "][0];
    loan.duartion = days;
    loan.phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
    loan.loanID = [self GetUUID];
    loan.name = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [loan saveLoan];
    __weak typeof(self) weakSelf = self;
    hud.completionBlock = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
    };
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Document"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Document"];
    }
    cell.textLabel.text = @"None";
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
@end
