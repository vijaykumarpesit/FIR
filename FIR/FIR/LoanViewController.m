//
//  LoanViewController.m
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "LoanViewController.h"
#import "FIRDataBase.h"

@interface LoanViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *riskScore;
@property (weak, nonatomic) IBOutlet UITableView *documents;
@end

@implementation LoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *loanDict = self.riskScoreLoan.loanSnapshot.value;
    
    self.nameLabel.text = loanDict[@"name"];
    self.moneyLabel.text = [loanDict[@"money"] stringValue];
    self.riskScore.text = self.riskScoreLoan.riskScore.stringValue;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invest" style:UIBarButtonItemStylePlain target:self action:@selector(submitTapped:)];
    
    if (loanDict[@"phoneNumber"]) {
        FIRDatabaseReference *db = [FIRDataBase sharedDataBase].ref;
        
        [[[db child:@"acounts"] child:loanDict[@"phoneNumber"] ] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.value) {
                NSDictionary *adharCardInfo = snapshot.value[@"completeAdharInfo"];
                NSMutableString *address  = [NSMutableString string];
                if (adharCardInfo[@"_co"]) {
                    [address appendString:adharCardInfo[@"_co"]];
                }
                
                if (adharCardInfo[@"_house"]) {
                    [address appendString:adharCardInfo[@"_house"]];
                }
                
                if (adharCardInfo[@"_street"]) {
                    [address appendString:adharCardInfo[@"_street"]];
                }
                
                if (adharCardInfo[@"_po"]) {
                    [address appendString:adharCardInfo[@"_po"]];
                }
                
                if (adharCardInfo[@"_dist"]) {
                    [address appendString:adharCardInfo[@"_dist"]];
                }
                
                if (adharCardInfo[@"_state"]) {
                    [address appendString:adharCardInfo[@"_state"]];
                }
                
                self.addressLabel.text = address;
            }
        }];
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitTapped:(id)sender {
    
    //Need to make a call to submit call. investmentID creation
    
    [self.navigationController popViewControllerAnimated:YES];
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
