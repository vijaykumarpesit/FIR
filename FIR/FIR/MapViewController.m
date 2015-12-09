//
//  MapViewController.m
//  FIR
//
//  Created by Sachin Vas on 12/9/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *pointAnnotation;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Location";
    
    self.pointAnnotation = [[MKPointAnnotation alloc] init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.accidentMetdata.lattitude, self.accidentMetdata.longitude);
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.accidentMetdata.lattitude longitude:self.accidentMetdata.longitude];
    
    __block CLPlacemark* placemark;
    __block typeof(self) weakSelf = self;
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             weakSelf.pointAnnotation.title = [NSString stringWithFormat:@"%@", placemark.name];
             weakSelf.pointAnnotation.subtitle = [NSString stringWithFormat:@"%@, %@", placemark.postalCode, placemark.locality];
             [weakSelf.mapView removeAnnotation:weakSelf.pointAnnotation];
             [weakSelf.mapView addAnnotation:weakSelf.pointAnnotation];
         }
     }];
    [self.mapView addAnnotation:self.pointAnnotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.accidentMetdata.lattitude, self.accidentMetdata.longitude), MKCoordinateSpanMake(0.003f, 0.003f));
    [self.mapView setRegion:region animated:YES];
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

@end
