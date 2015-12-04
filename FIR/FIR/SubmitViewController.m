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



@interface SubmitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *vehicleNo1;

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    
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

    //Craete PF Object
    
    FIRAccidentMetaData *metadata = [[[DataSource sharedDataSource] accidentMetaDataArry] firstObject];
    PFObject* accident = [PFObject objectWithClassName:@"Accident"];
    accident[@"date"] = metadata.date;
    accident[@"lattitude"] =@(metadata.lattitude);
    accident[@"longitude"] =@(metadata.longitude);
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
    //accident[@"description"] = @""

    [accident saveInBackground];
}

@end
