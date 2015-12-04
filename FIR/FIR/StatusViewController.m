//
//  SecondViewController.m
//  FIR
//
//  Created by Vijay on 03/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "StatusViewController.h"
#import "FIRComplaintCell.h"
#import <Parse/Parse.h>
#import "DataSource.h"
#import "FIRAccidentMetaData.h"
#import "UIImageView+AFNetworking.h"


@interface StatusViewController ()

@property (nonatomic, strong) NSArray *registeredFIR;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registeredFIR = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FIRComplaintCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //[self loadComplaintData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.registeredFIR.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 300.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FIRComplaintCell *cell = (FIRComplaintCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FIRAccidentMetaData *metadata = self.registeredFIR[indexPath.row];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:metadata.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    cell.time.text = dateString;
    PFFile *file = metadata.spotImages[0];
    NSURL *fileURL = [NSURL URLWithString:file.url];
    [cell.imageView setImageWithURL:fileURL placeholderImage:nil];
    return cell;
}

- (void)loadComplaintData {
    
    NSString *phoneNO = [[DataSource sharedDataSource] currentUser].phoneNumber;
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    [query whereKey:@"reportedByPhoneNOs" containedIn:@[phoneNO]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        for (PFObject *accident in objects) {
            
            FIRAccidentMetaData *metaData = [[FIRAccidentMetaData alloc] init];
            NSNumber *lattitudeValue = accident[@"lattitude"];
            metaData.lattitude = lattitudeValue.floatValue;
            
            NSNumber *longitudeValue = accident[@"longitude"];
            metaData.longitude = longitudeValue.floatValue;
            metaData.date = accident[@"date"];
            metaData.spotImages = accident[@"spotImages"];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
