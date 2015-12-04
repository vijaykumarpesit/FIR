//
//  SubmitViewController.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "SubmitViewController.h"
#import <Parse/Parse.h>
#import "DataSource.h"
#import "FIRAccidentMetaData.h"



@interface SubmitViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vehicleNo1;

@property (weak, nonatomic) IBOutlet UITextField *vehicleNo2;

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.vehicleNo1.text = @"KA-03-HY-3266";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sumbmitAccidentReport:(id)sender {
    
    FIRAccidentMetaData *metadata = [[[DataSource sharedDataSource] accidentMetaDataArry] firstObject];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    [query whereKey:@"vehicleNumbers" containedIn:metadata.vehicleNumbers.allObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            //Already found update the item//TODO
            
        } else {
            //Craete PF Object
            
            PFObject* accident = [PFObject objectWithClassName:@"Accident"];
            accident[@"date"] = metadata.date;
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:metadata.lattitude longitude:metadata.longitude];
            accident[@"geoPoint"] = geoPoint;
            accident[@"reportedByPhoneNOs"] = [NSMutableArray arrayWithObject:[[[DataSource sharedDataSource] currentUser] phoneNumber]];
            
            
            NSMutableArray *spotArray = [NSMutableArray array];
            for (NSString *filePath in metadata.spotImages) {
                @autoreleasepool {
                    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
                    PFFile *file = [PFFile fileWithData:imageData];
                    [file saveInBackground];
                    [spotArray addObject:file];
                }
            }
            
            NSMutableArray *victimArray = [NSMutableArray array];
            for (NSString *filePath in metadata.victimImages) {
                @autoreleasepool {
                    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
                    PFFile *file = [PFFile fileWithData:imageData];
                    [file saveInBackground];
                    [victimArray addObject:file];
                }
            }
            
            NSMutableArray *documentArray = [NSMutableArray array];
            for (NSString *filePath in metadata.documentsImages) {
                @autoreleasepool {
                    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
                    PFFile *file = [PFFile fileWithData:imageData];
                    [file saveInBackground];
                    [documentArray addObject:file];
                }
            }
            
            accident[@"spotImages"] = spotArray;
            accident[@"victimImages"] = victimArray;
            accident[@"documentImages"] = documentArray;
            accident[@"vehicleNumbers"] = @[self.vehicleNo1.text,self.vehicleNo2.text];
            
            [accident saveInBackground];
        }
        
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Submission Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
 
    });
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    
}

@end
