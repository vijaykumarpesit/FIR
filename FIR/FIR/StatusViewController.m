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
#import "SubmitViewController.h"
#import "ImageMetaData.h"


@interface StatusViewController ()

@property (nonatomic, strong) NSMutableArray *registeredFIR;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *objectIDs;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registeredFIR = [[NSMutableArray alloc] init];
    self.objectIDs = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FIRComplaintCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadComplaintData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.registeredFIR.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.registeredFIR.count > 0) {
        return @"Stauts";
    }
    return nil;
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
    
    NSMutableString *vehicleNoString = [[NSMutableString alloc] init];
    
    for (NSString *vehilceNo in metadata.vehicleNumbers) {
        
        [vehicleNoString appendString:vehilceNo];
        [vehicleNoString appendString:@" "];

    }
    
    cell.vehicleNumber.text = vehicleNoString;
    
    if (metadata.status == 2) {
        cell.status.text = @"Filed";
    }
    if (file) {
        NSURL *fileURL = [NSURL URLWithString:file.url];
        [cell.bgImageView setImageWithURL:fileURL placeholderImage:[UIImage imageNamed:@"accidentPlaceHolder"]];
    } else {
        [cell.bgImageView setImage:[UIImage imageNamed:@"accidentPlaceHolder"]];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"StatusToSubmit" sender:self];
}

- (void)loadComplaintData {
    
    NSString *phoneNO = [[DataSource sharedDataSource] currentUser].phoneNumber;
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    
    if (![[[DataSource sharedDataSource] currentUser] isPolice]) {
        [query whereKey:@"reportedByPhoneNOs" containedIn:@[phoneNO]];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        for (PFObject *accident in objects) {
            
            [self.objectIDs addObject:accident.objectId];
            
            FIRAccidentMetaData *metaData = [[FIRAccidentMetaData alloc] init];
            
            PFGeoPoint *geoPoint = accident[@"geoPoint"];
            metaData.longitude = geoPoint.longitude;
            metaData.lattitude = geoPoint.latitude;
            metaData.date = accident[@"date"];
            metaData.spotImages = accident[@"spotImages"];
            metaData.victimImages = accident[@"victimImages"];
            metaData.vehicleNoImages = accident[@"vehicleNoImages"];
            metaData.vehicleNumbers =  accident[@"vehicleNumbers"];
            metaData.status = [accident[@"status"] integerValue];
            metaData.reportedByPhoneNOs = accident[@"reportedByPhoneNOs"];
            
            for (PFFile *file in metaData.spotImages) {
                ImageMetaData *imageMetaData = [[ImageMetaData alloc] init];
                imageMetaData.imageType = AccidentImageTypeOther;
                imageMetaData.file = file;
                imageMetaData.filePath = file.url;
                [metaData.images addObject:imageMetaData];
            }
            
            for (PFFile *file in metaData.victimImages) {
                ImageMetaData *imageMetaData = [[ImageMetaData alloc] init];
                imageMetaData.filePath = file.url;
                imageMetaData.file = file;
                imageMetaData.imageType = AccidentImageTypeVictim;
                [metaData.images addObject:imageMetaData];
            

            }
            
            for (PFFile *file in metaData.vehicleNoImages) {
                ImageMetaData *imageMetaData = [[ImageMetaData alloc] init];
                imageMetaData.filePath = file.url;
                imageMetaData.file = file;
                imageMetaData.imageType = AccidentImageTypeNumberPlate;
                [metaData.images addObject:imageMetaData];

            }
            
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[SubmitViewController class]]) {
        SubmitViewController *submitVC = (SubmitViewController *)segue.destinationViewController;
        submitVC.isInEditMode = YES;
        submitVC.accidentMetdata = self.registeredFIR[self.selectedIndexPath.row];
        submitVC.selectedObjectID = self.objectIDs[self.selectedIndexPath.row];
        
    }
}

@end
