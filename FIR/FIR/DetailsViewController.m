//
//  DetailsViewController.m
//  FIR
//
//  Created by Sachin Vas on 12/9/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "DetailsViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *fathersNameField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfIncidentField;
@property (weak, nonatomic) IBOutlet UITextField *timeOfIncidentField;
@property (weak, nonatomic) IBOutlet UITextField *placeOfIncident;
@property (weak, nonatomic) IBOutlet UITextView *detailsOfIncidentView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.accidentMetdata.lattitude longitude:self.accidentMetdata.longitude];
    
    __block CLPlacemark* placemark;
    __block typeof(self) weakSelf = self;
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             weakSelf.placeOfIncident.text = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality]
             ;
         }
     }];
    
    NSString *date = [NSDateFormatter localizedStringFromDate:self.accidentMetdata.date
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];

    self.dateOfIncidentField.text = date;
    NSString *time = [NSDateFormatter localizedStringFromDate:self.accidentMetdata.date
                                                    dateStyle:NSDateFormatterNoStyle
                                                    timeStyle:NSDateFormatterShortStyle];

    self.timeOfIncidentField.text = time;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitButtonClicked:(id)sender {
    if (self.objectID) {
        PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
        [query whereKey:@"objectId" equalTo:self.objectID];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
           
            PFObject *accident = (PFObject *) [objects lastObject];
            accident[@"status"] = @(2);
            [accident saveInBackground];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }
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
