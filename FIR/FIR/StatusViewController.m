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

@property (nonatomic, strong) NSMutableArray *registeredFIR;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registeredFIR = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FIRComplaintCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadComplaintData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.registeredFIR.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 130.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FIRComplaintCell *cell = (FIRComplaintCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FIRAccidentMetaData *metadata = self.registeredFIR[indexPath.row];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:metadata.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    cell.time.text = dateString;
    
    PFFile *file  = nil;
    
    if (metadata.spotImages.count) {
        file = metadata.spotImages[0];
    } else if(metadata.vehicleNoImages.count) {
        file = metadata.vehicleNoImages[0];
    } else if(metadata.victimImages.count) {
        file = metadata.victimImages[0];
    }
    
    if (file) {
        NSURL *fileURL = [NSURL URLWithString:file.url];
        [cell.bgImageView setImageWithURL:fileURL placeholderImage:[UIImage imageNamed:@"accidentPlaceHolder"]];
    } else {
        [cell.bgImageView setImage:[UIImage imageNamed:@"accidentPlaceHolder"]];
        
    }
    return cell;
}

- (void)loadComplaintData {
    
    NSString *phoneNO = [[DataSource sharedDataSource] currentUser].phoneNumber;
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    //[query whereKey:@"reportedByPhoneNOs" containedIn:@[phoneNO]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        for (PFObject *accident in objects) {
            
            FIRAccidentMetaData *metaData = [[FIRAccidentMetaData alloc] init];
            
            PFGeoPoint *geoPoint = accident[@"geoPoint"];
            metaData.longitude = geoPoint.longitude;
            metaData.lattitude = geoPoint.latitude;
            metaData.date = accident[@"date"];
            metaData.spotImages = accident[@"spotImages"];
            metaData.victimImages = accident[@"victimImages"];
            metaData.vehicleNoImages = accident[@"vehicleNoImages"];
            [self.registeredFIR addObject:metaData];
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
